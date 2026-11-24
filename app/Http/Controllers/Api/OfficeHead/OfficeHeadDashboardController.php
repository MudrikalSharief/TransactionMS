<?php

namespace App\Http\Controllers\Api\OfficeHead;

use App\Http\Controllers\Controller;
use App\Models\Office;
use App\Models\User;
use Illuminate\Http\JsonResponse;

/**
 * Read-only data used by the office-head dashboard. The office head can
 * view account requests across every office, but cannot approve or manage
 * them (there is deliberately no write endpoint here).
 */
class OfficeHeadDashboardController extends Controller
{
    public function pendingAccounts(): JsonResponse
    {
        $users = User::query()
            ->whereNull('approved_at')
            ->with(['roles', 'office'])
            ->orderBy('created_at')
            ->get();

        return response()->json([
            'data' => $users->map(fn (User $user) => [
                'id' => $user->id,
                'name' => $user->name,
                'username' => $user->username,
                'office_id' => $user->office_id,
                'office' => Office::mini($user->office),
                'roles' => $user->roles->map(fn ($role) => [
                    'id' => $role->id,
                    'code' => $role->code,
                    'name' => $role->name,
                ])->values(),
                'created_at' => $user->created_at?->toISOString(),
                'pending_approval' => true,
            ])->values(),
        ]);
    }
}
