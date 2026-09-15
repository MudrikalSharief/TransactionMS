<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\StoreGovernmentReferenceRequest;
use App\Http\Requests\Admin\UpdateGovernmentReferenceRequest;
use App\Http\Resources\GovernmentReferenceResource;
use App\Models\GovernmentReference;
use App\Services\AuditService;
use Illuminate\Http\Request;

class GovernmentReferenceController extends Controller
{
    public function index()
    {
        return GovernmentReferenceResource::collection(
            GovernmentReference::query()->orderBy('source')->orderBy('code')->get()
        );
    }

    public function store(StoreGovernmentReferenceRequest $request, AuditService $audit)
    {
        $ref = GovernmentReference::create($request->validated());

        $audit->log($request, 'government_references.create', $ref, [
            'payload' => $request->validated(),
        ]);

        return (new GovernmentReferenceResource($ref))->response()->setStatusCode(201);
    }

    public function update(UpdateGovernmentReferenceRequest $request, GovernmentReference $governmentReference, AuditService $audit)
    {
        $before = $governmentReference->only(['code', 'title', 'source', 'url', 'notes', 'is_verified']);

        $governmentReference->update($request->validated());

        $audit->log($request, 'government_references.update', $governmentReference, [
            'before' => $before,
            'after' => $governmentReference->only(['code', 'title', 'source', 'url', 'notes', 'is_verified']),
        ]);

        return new GovernmentReferenceResource($governmentReference);
    }

    public function destroy(Request $request, GovernmentReference $governmentReference, AuditService $audit)
    {
        $governmentReference->delete();

        $audit->log($request, 'government_references.delete', $governmentReference, [
            'note' => 'Soft deleted government reference',
        ]);

        return response()->json(['message' => 'Deleted.']);
    }
}
