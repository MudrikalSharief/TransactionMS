<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Office;
use App\Models\Role;
use App\Models\User;
use App\Services\AuditService;
use App\Services\UserApproval;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;

/**
 * "Create an account" on the login page. The same details a superadmin
 * enters for a new user, plus a contact number; the account starts
 * inactive and cannot sign in until an admin approves it.
 */
class RegistrationController extends Controller
{
    /** What the sign-up form offers: every office, and the roles one may ask for. */
    public function options(): JsonResponse
    {
        return response()->json([
            'offices' => Office::query()->orderBy('name')->get(['id', 'code', 'name']),
            'roles' => Role::query()
                ->whereNotIn('code', UserApproval::PROTECTED_ROLES)
                ->orderBy('name')
                ->get(['id', 'code', 'name']),
        ]);
    }

    public function register(Request $request, AuditService $audit): JsonResponse
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:120'],
            'email' => ['required', 'email', 'max:190', 'unique:users,email'],
            'contact_number' => ['required', 'string', 'max:20', 'regex:/^\+?[0-9][0-9\s\-()]{6,18}$/'],
            'password' => ['required', 'string', 'min:8'],
            'office_id' => ['required', 'integer', 'exists:offices,id'],
            'role_ids' => ['required', 'array', 'min:1'],
            'role_ids.*' => ['integer', Rule::exists('roles', 'id')->whereNotIn('code', UserApproval::PROTECTED_ROLES)],
        ], [
            'email.unique' => 'An account with this email already exists.',
            'contact_number.regex' => 'Enter a valid contact number, for example 09171234567.',
            'office_id.required' => 'Choose your office.',
            'role_ids.required' => 'Choose your role.',
        ]);

        DB::transaction(function () use ($request, $data, $audit) {
            $user = User::create([
                'name' => $data['name'],
                'email' => $data['email'],
                'Contact_number' => $data['contact_number'],
                'office_id' => $data['office_id'],
                'password' => Hash::make($data['password']),
                'is_active' => false,
                'approved_at' => null,
            ]);
            $user->roles()->sync($data['role_ids']);

            $audit->log($request, 'users.register', $user, [
                'payload' => [
                    'name' => $data['name'],
                    'email' => $data['email'],
                    'office_id' => $data['office_id'],
                    'role_ids' => $data['role_ids'],
                ],
            ]);
        });

        return response()->json([
            'message' => 'Account created. You can sign in once an administrator approves it.',
        ], 201);
    }
}
