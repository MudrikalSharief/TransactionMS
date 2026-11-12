<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Office;
use App\Models\User;
use App\Services\AuditService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

/**
 * "My Profile" for every signed-in account: edit your own name, username
 * (the sign-in name), contact number and password. Office and roles are not edited here (they
 * are set on the Users page). The shared guest viewer account ("Track your
 * Document Process") cannot be edited, since every guest uses it.
 */
class ProfileController extends Controller
{
    private const NOT_SELF_SERVICE = ['viewer'];

    public function show(Request $request): JsonResponse
    {
        $user = $this->profileUser($request);

        return response()->json(['profile' => $this->payload($user)]);
    }

    public function update(Request $request, AuditService $audit): JsonResponse
    {
        $user = $this->profileUser($request);

        // Usernames are stored lowercase and trimmed (same as sign-up).
        $request->merge(['username' => User::normalizeUsername($request->input('username'))]);

        $data = $request->validate([
            'name' => ['required', 'string', 'max:120'],
            'username' => User::usernameRules(true, $user->id),
            'contact_number' => ['nullable', 'string', 'max:20', 'regex:/^\+?[0-9][0-9\s\-()]{6,18}$/'],
        ], User::USERNAME_MESSAGES + [
            'contact_number.regex' => 'Enter a valid contact number, for example 09171234567.',
        ]);

        // Saved and logged together. The username is the sign-in name, so a
        // change to it shows in the before/after record. Email isn't edited
        // here and stays as it is.
        DB::transaction(function () use ($request, $user, $data, $audit) {
            $before = [
                'name' => $user->name,
                'username' => $user->username,
                'Contact_number' => $user->Contact_number,
            ];

            $user->forceFill([
                'name' => $data['name'],
                'username' => $data['username'],
                'Contact_number' => $data['contact_number'] ?? null,
            ])->save();

            $audit->log($request, 'profile.update', $user, [
                'before' => $before,
                'after' => [
                    'name' => $user->name,
                    'username' => $user->username,
                    'Contact_number' => $user->Contact_number,
                ],
            ]);
        });

        return response()->json(['message' => 'Profile saved.', 'profile' => $this->payload($user)]);
    }

    public function updatePassword(Request $request, AuditService $audit): JsonResponse
    {
        $user = $this->profileUser($request);

        $data = $request->validate([
            'current_password' => ['required', 'string'],
            'password' => ['required', 'string', 'min:8', 'confirmed'],
        ], [
            'password.confirmed' => 'The new passwords do not match.',
            'password.min' => 'Use at least 8 characters.',
        ]);

        if (!Hash::check($data['current_password'], $user->password)) {
            return response()->json([
                'message' => 'Your current password is not correct.',
                'errors' => ['current_password' => ['Your current password is not correct.']],
            ], 422);
        }

        DB::transaction(function () use ($request, $user, $data, $audit) {
            $user->forceFill(['password' => Hash::make($data['password'])])->save();
            $audit->log($request, 'profile.password', $user);
        });

        return response()->json(['message' => 'Password changed.']);
    }

    private function profileUser(Request $request): User
    {
        $user = $request->user();
        $user->loadMissing(['roles', 'office']);
        if ($user->roles->contains(fn ($r) => in_array($r->code, self::NOT_SELF_SERVICE, true))) {
            abort(403, 'The guest account cannot be edited.');
        }

        return $user;
    }

    private function payload(User $user): array
    {
        $user->loadMissing(['roles', 'office']);

        return [
            'id' => $user->id,
            'name' => $user->name,
            'username' => $user->username,
            'email' => $user->email,
            'contact_number' => $user->Contact_number,
            'office' => Office::mini($user->office),
            'roles' => $user->roles->map(fn ($r) => $r->only(['id', 'code', 'name']))->values(),
        ];
    }
}
