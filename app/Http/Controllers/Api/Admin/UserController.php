<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\StoreUserRequest;
use App\Http\Requests\Admin\UpdateUserRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use App\Services\AuditService;
use App\Services\UserApproval;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    public function index()
    {
        return UserResource::collection(
            User::query()
                ->with(['roles', 'office'])
                ->orderBy('name')
                ->get()
        );
    }

    public function store(StoreUserRequest $request, AuditService $audit)
    {
        $data = $request->validated();

        return DB::transaction(function () use ($request, $data, $audit) {
            // Created by a superadmin, so approved from the start.
            $user = User::create([
                'name' => $data['name'],
                'email' => $data['email'],
                'office_id' => $data['office_id'] ?? null,
                'Contact_number' => $data['contact_number'] ?? null,
                'password' => Hash::make($data['password']),
                'is_active' => $data['is_active'] ?? true,
                'approved_at' => now(),
                'approved_by' => $request->user()->id,
            ]);

            if (!empty($data['role_ids'])) {
                $user->roles()->sync($data['role_ids']);
            }

            $user->load(['roles', 'office']);

            $audit->log($request, 'users.create', $user, [
                'payload' => [
                    'name' => $data['name'],
                    'email' => $data['email'],
                    'office_id' => $data['office_id'] ?? null,
                    'is_active' => $user->is_active,
                    'role_ids' => $data['role_ids'] ?? [],
                ],
            ]);

            return (new UserResource($user))->response()->setStatusCode(201);
        });
    }

    public function update(UpdateUserRequest $request, User $user, AuditService $audit)
    {
        $data = $request->validated();

        return DB::transaction(function () use ($request, $user, $data, $audit) {
            $before = [
                'name' => $user->name,
                'email' => $user->email,
                'office_id' => $user->office_id,
                'is_active' => (bool) $user->is_active,
                'role_ids' => $user->roles()->pluck('roles.id')->all(),
            ];

            $user->name = $data['name'];
            $user->email = $data['email'];
            $user->is_active = $data['is_active'] ?? $user->is_active;

            if (array_key_exists('office_id', $data)) {
                $user->office_id = $data['office_id'];
            }

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

            $after = [
                'name' => $user->name,
                'email' => $user->email,
                'office_id' => $user->office_id,
                'is_active' => (bool) $user->is_active,
                'role_ids' => $user->roles()->pluck('roles.id')->all(),
            ];

            $audit->log($request, 'users.update', $user, [
                'before' => $before,
                'after' => $after,
            ]);

            return new UserResource($user);
        });
    }

    /** Lets an account created on the login page sign in. */
    public function approve(Request $request, User $user, UserApproval $approval, AuditService $audit)
    {
        $approval->approve($user, $request->user());
        $audit->log($request, 'users.approve', $user);

        return new UserResource($user->load(['roles', 'office']));
    }

    /** Turns down an account created on the login page (removes it). */
    public function reject(Request $request, User $user, UserApproval $approval, AuditService $audit)
    {
        $audit->log($request, 'users.reject', $user, ['payload' => ['email' => $user->email, 'name' => $user->name]]);
        $approval->reject($user);

        return response()->json(['message' => 'Request rejected.']);
    }

    public function destroy(Request $request, User $user, AuditService $audit)
    {
        if ($request->user()?->id === $user->id) {
            return response()->json(['message' => 'You cannot delete your own account.'], 422);
        }

        $user->is_active = false;
        $user->save();

        $audit->log($request, 'users.deactivate', $user, [
            'note' => 'User marked inactive (no hard delete in Step 2)',
        ]);

        return response()->json(['message' => 'User deactivated.']);
    }
}
