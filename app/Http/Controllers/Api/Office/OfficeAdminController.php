<?php

namespace App\Http\Controllers\Api\Office;

use App\Http\Controllers\Controller;
use App\Http\Resources\RoleResource;
use App\Http\Resources\UserResource;
use App\Models\Role;
use App\Models\TransactionType;
use App\Models\User;
use App\Services\AuditService;
use App\Services\UserApproval;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;

/**
 * Office admin area: manage the people in the admin's own office and look
 * up what that office may file. Never touches other offices, and never
 * grants or edits the admin/superadmin roles (those stay with superadmin).
 */
class OfficeAdminController extends Controller
{
    private const PROTECTED_ROLES = UserApproval::PROTECTED_ROLES;

    private const CONTACT_RULE = ['nullable', 'string', 'max:20', 'regex:/^\+?[0-9][0-9\s\-()]{6,18}$/'];

    public function users(Request $request)
    {
        return UserResource::collection(
            User::query()
                ->where('office_id', $request->user()->office_id)
                ->with(['roles', 'office'])
                ->orderBy('name')
                ->get()
        );
    }

    public function storeUser(Request $request, AuditService $audit)
    {
        $request->merge(['username' => User::normalizeUsername($request->input('username'))]);
        $data = $request->validate([
            'name' => ['required', 'string', 'max:120'],
            'username' => User::usernameRules(false),
            'email' => ['required', 'email', 'max:190', 'unique:users,email'],
            'password' => ['required', 'string', 'min:8'],
            'contact_number' => self::CONTACT_RULE,
            'is_active' => ['sometimes', 'boolean'],
            'role_ids' => ['sometimes', 'array'],
            'role_ids.*' => ['integer', $this->assignableRoleRule()],
        ], User::USERNAME_MESSAGES);
        $officeId = (int) $request->user()->office_id;

        return DB::transaction(function () use ($request, $data, $officeId, $audit) {
            // Created by the office admin, so approved from the start.
            $user = User::create([
                'name' => $data['name'],
                'username' => $data['username'] ?? null,
                'email' => $data['email'],
                'office_id' => $officeId,
                'Contact_number' => $data['contact_number'] ?? null,
                'password' => Hash::make($data['password']),
                'is_active' => $data['is_active'] ?? true,
                'approved_at' => now(),
                'approved_by' => $request->user()->id,
            ]);
            $user->roles()->sync($data['role_ids'] ?? []);
            $user->load(['roles', 'office']);

            $audit->log($request, 'office.users.create', $user, [
                'payload' => [
                    'name' => $data['name'],
                    'username' => $user->username,
                    'email' => $data['email'],
                    'office_id' => $officeId,
                    'is_active' => $user->is_active,
                    'role_ids' => $data['role_ids'] ?? [],
                ],
            ]);

            return (new UserResource($user))->response()->setStatusCode(201);
        });
    }

    public function updateUser(Request $request, User $user, AuditService $audit)
    {
        $this->assertManageable($request, $user);

        if ($request->has('username')) {
            $request->merge(['username' => User::normalizeUsername($request->input('username'))]);
        }
        $data = $request->validate([
            'name' => ['required', 'string', 'max:120'],
            'username' => User::usernameRules(false, $user->id),
            'email' => ['required', 'email', 'max:190', 'unique:users,email,' . $user->id],
            'password' => ['nullable', 'string', 'min:8'],
            'contact_number' => self::CONTACT_RULE,
            'is_active' => ['sometimes', 'boolean'],
            'role_ids' => ['sometimes', 'array'],
            'role_ids.*' => ['integer', $this->assignableRoleRule()],
        ], User::USERNAME_MESSAGES);

        return DB::transaction(function () use ($request, $user, $data, $audit) {
            $before = [
                'name' => $user->name,
                'username' => $user->username,
                'email' => $user->email,
                'is_active' => (bool) $user->is_active,
                'role_ids' => $user->roles()->pluck('roles.id')->all(),
            ];

            $user->name = $data['name'];
            if (array_key_exists('username', $data)) {
                $user->username = $data['username'];
            }
            $user->email = $data['email'];
            $user->is_active = $data['is_active'] ?? $user->is_active;
            if (array_key_exists('contact_number', $data)) {
                $user->Contact_number = $data['contact_number'];
            }
            if (!empty($data['password'])) {
                $user->password = Hash::make($data['password']);
            }
            $user->save();

            if (array_key_exists('role_ids', $data)) {
                $user->roles()->sync($data['role_ids'] ?? []);
            }
            $user->load(['roles', 'office']);

            $audit->log($request, 'office.users.update', $user, [
                'before' => $before,
                'after' => [
                    'name' => $user->name,
                    'username' => $user->username,
                    'email' => $user->email,
                    'is_active' => (bool) $user->is_active,
                    'role_ids' => $user->roles->pluck('id')->all(),
                ],
            ]);

            return new UserResource($user);
        });
    }

    public function deactivateUser(Request $request, User $user, AuditService $audit)
    {
        $this->assertManageable($request, $user);

        $user->is_active = false;
        $user->save();

        $audit->log($request, 'office.users.deactivate', $user, [
            'note' => 'Deactivated by office admin',
        ]);

        return response()->json(['message' => 'User deactivated.']);
    }

    /** Lets someone who signed up for this office sign in. */
    public function approveUser(Request $request, User $user, UserApproval $approval, AuditService $audit)
    {
        $this->assertManageable($request, $user);
        $approval->approve($user, $request->user());
        $audit->log($request, 'office.users.approve', $user);

        return new UserResource($user->load(['roles', 'office']));
    }

    /** Turns down someone who signed up for this office (removes the request). */
    public function rejectUser(Request $request, User $user, UserApproval $approval, AuditService $audit)
    {
        $this->assertManageable($request, $user);
        $audit->log($request, 'office.users.reject', $user, ['payload' => ['email' => $user->email, 'name' => $user->name]]);
        $approval->reject($user);

        return response()->json(['message' => 'Request rejected.']);
    }

    /** Roles an office admin may give out: everything except admin/superadmin. */
    public function roles()
    {
        return RoleResource::collection(
            Role::query()->whereNotIn('code', self::PROTECTED_ROLES)->orderBy('name')->get()
        );
    }

    /** Processes the admin's office may start (for "New transaction"). */
    public function transactionTypes(Request $request)
    {
        $types = TransactionType::query()
            ->fileableBy((int) $request->user()->office_id)
            ->orderBy('name')
            ->get(['id', 'code', 'name']);

        return response()->json(['data' => $types]);
    }

    /**
     * Office admins manage regular members of their own office only: not
     * themselves, not other offices, not other admins or superadmins.
     */
    private function assertManageable(Request $request, User $target): void
    {
        $me = $request->user();

        abort_if((int) $target->office_id !== (int) $me->office_id, 404);
        abort_if($target->id === $me->id, 422, 'You cannot change your own account here.');

        $target->loadMissing('roles');
        abort_if(
            $target->roles->contains(fn ($r) => in_array($r->code, self::PROTECTED_ROLES, true)),
            403,
            'Admins and superadmins can only be changed by a superadmin.'
        );
    }

    private function assignableRoleRule()
    {
        return Rule::exists('roles', 'id')->whereNotIn('code', self::PROTECTED_ROLES);
    }
}
