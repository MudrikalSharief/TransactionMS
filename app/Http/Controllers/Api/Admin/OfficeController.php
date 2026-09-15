<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\StoreOfficeRequest;
use App\Http\Requests\Admin\UpdateOfficeRequest;
use App\Http\Resources\OfficeResource;
use App\Models\Office;
use App\Services\AuditService;
use Illuminate\Http\Request;

class OfficeController extends Controller
{
    public function index()
    {
        return OfficeResource::collection(
            Office::query()->withCount('steps')->orderBy('name')->get()
        );
    }

    public function store(StoreOfficeRequest $request, AuditService $audit)
    {
        $office = Office::create($request->validated());

        $audit->log($request, 'offices.create', $office, [
            'payload' => $request->validated(),
        ]);

        return (new OfficeResource($office))->response()->setStatusCode(201);
    }

    public function update(UpdateOfficeRequest $request, Office $office, AuditService $audit)
    {
        $before = $office->only(['code', 'name', 'description', 'is_active']);

        $office->update($request->validated());

        $audit->log($request, 'offices.update', $office, [
            'before' => $before,
            'after' => $office->only(['code', 'name', 'description', 'is_active']),
        ]);

        return new OfficeResource($office);
    }

    public function destroy(Request $request, Office $office, AuditService $audit)
    {
        $office->users()->update(['office_id' => null]);
        $office->delete();

        $audit->log($request, 'offices.delete', $office, [
            'note' => 'Soft deleted office; members unassigned',
        ]);

        return response()->json(['message' => 'Deleted.']);
    }
}
