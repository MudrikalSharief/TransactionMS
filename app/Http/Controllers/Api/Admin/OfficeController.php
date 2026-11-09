<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\StoreOfficeRequest;
use App\Http\Requests\Admin\UpdateOfficeRequest;
use App\Http\Resources\OfficeResource;
use App\Models\Office;
use App\Services\AuditService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class OfficeController extends Controller
{
    private const ICON_DISK = 'public';

    private const ICON_DIRECTORY = 'offices/icons';

    public function index()
    {
        $items = Cache::remember(
            'lookup:offices',
            600,
            fn () => Office::query()->withCount('steps')->orderBy('name')->get()
        );

        return OfficeResource::collection($items);
    }

    public function store(StoreOfficeRequest $request, AuditService $audit)
    {
        $data = $request->safe()->except(['icon', 'remove_icon']);
        $newIconPath = $this->storeIcon($request);

        if ($newIconPath) {
            $data['icon_path'] = $newIconPath;
        }

        try {
            $office = DB::transaction(function () use ($request, $data, $audit) {
                $office = Office::create($data);

                $audit->log($request, 'offices.create', $office, [
                    'payload' => $data,
                ]);

                return $office;
            });
        } catch (\Throwable $e) {
            $this->deleteIcon($newIconPath);
            throw $e;
        }

        $this->forgetCaches();

        return (new OfficeResource($office))->response()->setStatusCode(201);
    }

    public function update(UpdateOfficeRequest $request, Office $office, AuditService $audit)
    {
        $before = $office->only(['code', 'name', 'description', 'icon_path', 'is_active']);
        $data = $request->safe()->except(['icon', 'remove_icon']);
        $oldIconPath = $office->icon_path;
        $newIconPath = $this->storeIcon($request);

        if ($newIconPath) {
            $data['icon_path'] = $newIconPath;
        } elseif ($request->boolean('remove_icon')) {
            $data['icon_path'] = null;
        }

        try {
            DB::transaction(function () use ($request, $office, $data, $before, $audit) {
                $office->update($data);

                $audit->log($request, 'offices.update', $office, [
                    'before' => $before,
                    'after' => $office->only(['code', 'name', 'description', 'icon_path', 'is_active']),
                ]);
            });
        } catch (\Throwable $e) {
            $this->deleteIcon($newIconPath);
            throw $e;
        }

        // Only remove the old file after the row has committed and points elsewhere.
        if ($oldIconPath && $oldIconPath !== $office->icon_path) {
            $this->deleteIcon($oldIconPath);
        }

        $this->forgetCaches();

        return new OfficeResource($office);
    }

    public function destroy(Request $request, Office $office, AuditService $audit)
    {
        $iconPath = $office->icon_path;
        $old = $office->only(['code', 'name', 'description', 'icon_path', 'is_active']);
        $old['user_ids'] = $office->users()->pluck('users.id')->all();

        DB::transaction(function () use ($request, $office, $old, $audit) {
            $office->users()->update(['office_id' => null]);
            $office->delete();

            $audit->log($request, 'offices.delete', $office, [
                'old' => $old,
                'note' => 'Soft deleted office; members unassigned',
            ]);
        });

        $this->deleteIcon($iconPath);
        $this->forgetCaches();

        return response()->json(['message' => 'Deleted.']);
    }

    private function storeIcon(Request $request): ?string
    {
        $file = $request->file('icon');
        if (!$file) {
            return null;
        }

        $path = $file->store(self::ICON_DIRECTORY, self::ICON_DISK);
        if (!$path) {
            abort(422, 'Unable to store the office icon.');
        }

        return $path;
    }

    private function deleteIcon(?string $path): void
    {
        if ($path) {
            Storage::disk(self::ICON_DISK)->delete($path);
        }
    }

    /**
     * Office rows are cached on their own, and the transaction-type lookup
     * embeds office data for its icon column. Clearing both keeps icons in
     * sync everywhere they are listed.
     */
    private function forgetCaches(): void
    {
        Cache::forget('lookup:offices');
        Cache::forget('lookup:transaction-types:v3');
    }
}
