<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\StoreRoleRequest;
use App\Http\Requests\Admin\UpdateRoleRequest;
use App\Http\Resources\RoleResource;
use App\Models\Role;
use App\Services\AuditService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class RoleController extends Controller
{
    public function index(Request $request)
    {
        $query = Role::query()->with('office')->ordered();
        if ($request->user()->isOfficeAdmin()) {
            $query->availableToOffice((int) $request->user()->office_id)->where('code', '!=', 'superadmin');
        }

        return RoleResource::collection(
            $query->get()
        );
    }

    public function store(StoreRoleRequest $request, AuditService $audit)
    {
        $data = $request->validated();

        // Re-adding a deleted role's code restores that role (with the new
        // name and description), so its users and workflow steps come back
        // with it instead of the code being reported as taken.
        $trashed = Role::onlyTrashed()->where('code', $data['code'])->first();
        if ($trashed) {
            $this->assertManageable($request, $trashed);
            return DB::transaction(function () use ($request, $trashed, $data, $audit) {
                $trashed->restore();
                $trashed->update($data);

                $audit->log($request, 'roles.restore', $trashed, [
                    'payload' => $data,
                ]);

                return (new RoleResource($trashed->load('office')))->response()->setStatusCode(201);
            });
        }

        return DB::transaction(function () use ($request, $data, $audit) {
            $role = Role::create([
                ...$data,
                'office_id' => $request->user()->isOfficeAdmin() ? $request->user()->office_id : null,
            ]);

            $audit->log($request, 'roles.create', $role, [
                'payload' => $data,
            ]);

            return (new RoleResource($role->load('office')))->response()->setStatusCode(201);
        });
    }

    public function update(UpdateRoleRequest $request, Role $role, AuditService $audit)
    {
        $this->assertManageable($request, $role);
        return DB::transaction(function () use ($request, $role, $audit) {
            $before = $role->only(['code', 'name', 'description']);

            $role->update($request->validated());

            $audit->log($request, 'roles.update', $role, [
                'before' => $before,
                'after' => $role->only(['code', 'name', 'description']),
            ]);

            return new RoleResource($role->load('office'));
        });
    }

    public function destroy(Request $request, Role $role, AuditService $audit)
    {
        $this->assertManageable($request, $role);
        if ($role->code === 'superadmin') {
            return response()->json(['message' => 'Cannot delete superadmin role.'], 422);
        }

        return DB::transaction(function () use ($request, $role, $audit) {
            $old = $role->only(['code', 'name', 'description']);
            $old['user_ids'] = $role->users()->pluck('users.id')->all();

            $role->delete();

            $audit->log($request, 'roles.delete', $role, [
                'old' => $old,
                'note' => 'Soft deleted role',
            ]);

            return response()->json(['message' => 'Deleted.']);
        });
    }

    private function assertManageable(Request $request, Role $role): void
    {
        abort_unless($role->canBeManagedBy($request->user()), 404);
    }
}
