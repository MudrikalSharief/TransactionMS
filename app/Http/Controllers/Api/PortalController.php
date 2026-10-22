<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use Illuminate\Http\Request;

/** Office-level numbers for the staff portal home page. */
class PortalController extends Controller
{
    public function summary(Request $request)
    {
        $user = $request->user();
        $user->loadMissing(['roles', 'office:id,code,name']);

        $office = Transaction::query()
            ->when(
                $user->office_id !== null,
                fn ($q) => $q->where('office_id', $user->office_id),
                fn ($q) => $q->whereRaw('1 = 0')
            );

        return response()->json([
            'office' => $user->office?->only(['id', 'code', 'name']),
            'office_total' => (clone $office)->count(),
            'in_process' => (clone $office)->where('is_done', false)->count(),
            'completed' => (clone $office)->where('is_done', true)->count(),
            'created_by_me' => Transaction::where('created_by', $user->id)->count(),
        ]);
    }
}
