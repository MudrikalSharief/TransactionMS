<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\StoreRoleRequest;
use App\Http\Requests\Admin\SyncRolePermissionsRequest;
use App\Http\Requests\Admin\UpdateRoleRequest;
use App\Http\Resources\RoleResource;
use App\Models\Permission;
use App\Models\Role;
use App\Services\AuditService;
use Illuminate\Http\Request;

class RoleController extends Controller
{
    public function index()
    {
        return RoleResource::collection(
            Role::query()->ordered()->with('permissions')->get()
        );
    }

    public function store(StoreRoleRequest $request, AuditService $audit)
    {
        $role = Role::create($request->validated());

        $audit->log($request, 'roles.create', $role, [
            'payload' => $request->validated(),
        ]);

        return (new RoleResource($role))->response()->setStatusCode(201);
    }

    public function update(UpdateRoleRequest $request, Role $role, AuditService $audit)
    {
        $before = $role->only(['code', 'name', 'description']);

        $role->update($request->validated());

        $audit->log($request, 'roles.update', $role, [
            'before' => $before,
            'after' => $role->only(['code', 'name', 'description']),
        ]);

        return new RoleResource($role);
    }

    public function syncPermissions(SyncRolePermissionsRequest $request, Role $role, AuditService $audit)
    {
        if ($role->code === 'superadmin') {
            return response()->json(['message' => 'Superadmin permissions cannot be changed.'], 422);
        }

        $codes = collect($request->validated()['permission_codes'])
            ->flatMap(fn (string $code) => str_ends_with($code, '.manage')
                ? [$code, substr($code, 0, -7).'.view']
                : [$code])
            ->unique()
            ->values();

        $before = $role->permissions()->pluck('permissions.code')->values()->all();

        $ids = Permission::query()->whereIn('code', $codes)->pluck('id');
        $role->permissions()->sync($ids);

        $audit->log($request, 'roles.permissions', $role, [
            'before' => $before,
            'after' => $codes->all(),
        ]);

        return new RoleResource($role->load('permissions'));
    }

    public function destroy(Request $request, Role $role, AuditService $audit)
    {
        if ($role->code === 'superadmin') {
            return response()->json(['message' => 'Cannot delete superadmin role.'], 422);
        }

        $role->delete();

        $audit->log($request, 'roles.delete', $role, [
            'note' => 'Soft deleted role',
        ]);

        return response()->json(['message' => 'Deleted.']);
    }
}
