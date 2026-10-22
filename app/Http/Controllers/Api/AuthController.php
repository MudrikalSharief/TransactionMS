<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use App\Models\Role;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    public function login(LoginRequest $request): JsonResponse
    {
        $data = $request->validated();

        $credentials = [
            'email' => $data['email'],
            'password' => $data['password'],
        ];

        $remember = (bool) ($data['remember'] ?? false);

        if (!Auth::guard('web')->validate($credentials)) {
            return response()->json([
                'message' => 'Invalid credentials.',
            ], 422);
        }

        // Only a correct password reveals that the account is still waiting.
        $user = User::where('email', $credentials['email'])->first();
        if ($user?->isPendingApproval()) {
            return response()->json([
                'message' => 'Your account is waiting for approval. You can sign in once an administrator approves it.',
            ], 403);
        }

        Auth::guard('web')->login($user, $remember);

        $request->session()->regenerate();

        return response()->json([
            'message' => 'Logged in.',
            'user' => [
                'id' => $request->user()->id,
                'name' => $request->user()->name,
                'email' => $request->user()->email,
            ],
        ]);
    }

    /**
     * "Log in as Guest": passwordless sign-in to the configured guest
     * account, which must be a viewer-only (read-only) account. The account
     * is created on first use, so a fresh database needs no seeding.
     */
    public function guest(Request $request): JsonResponse
    {
        $guest = User::where('email', config('auth.guest_email'))->first() ?? $this->createGuestAccount();

        // An existing account that was deactivated or given more roles is
        // refused as is, never repaired here.
        if (!$guest->is_active || !$guest->isViewerOnly()) {
            return response()->json([
                'message' => 'Document tracking is not available right now.',
            ], 503);
        }

        Auth::guard('web')->login($guest);

        $request->session()->regenerate();

        return response()->json([
            'message' => 'Logged in as guest.',
            'user' => [
                'id' => $guest->id,
                'name' => $guest->name,
                'email' => $guest->email,
            ],
        ]);
    }

    private function createGuestAccount(): User
    {
        $viewerRole = Role::firstOrCreate(
            ['code' => 'viewer'],
            ['name' => 'Viewer', 'description' => 'Read-only access.']
        );

        // Guests sign in without a password, so this one is random and never shown.
        $guest = User::firstOrCreate(
            ['email' => config('auth.guest_email')],
            [
                'name' => 'Guest Viewer',
                'password' => Hash::make(Str::random(40)),
                'is_active' => true,
                'approved_at' => now(),
            ]
        );

        if ($guest->wasRecentlyCreated) {
            $guest->roles()->attach($viewerRole->id);
        }

        return $guest->load('roles');
    }

    public function me(\Illuminate\Http\Request $request): \Illuminate\Http\JsonResponse
    {
        $user = $request->user();

        if (!$user) {
            return response()->json(['user' => null], 200);
        }

        $user->load(['roles', 'office']);

            return response()->json([
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'office' => $user->office ? [
                        'id' => $user->office->id,
                        'code' => $user->office->code,
                        'name' => $user->office->name,
                    ] : null,
                    'roles' => $user->roles->map(fn($r) => [
                        'id' => $r->id,
                        'code' => $r->code,
                        'name' => $r->name,
                    ])->values(),
                ],
            ]);
    }

    public function logout(Request $request): JsonResponse
    {
        Auth::guard('web')->logout();

        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return response()->json([
            'message' => 'Logged out.',
        ]);
    }
}
