<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Storage;

class Office extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'code',
        'name',
        'description',
        'icon_path',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    /** @var array<string, int|null> Per-request mtime cache (one stat per icon). */
    private static array $iconVersions = [];

    /**
     * Public URL for the uploaded icon, versioned with the file's mtime.
     *
     * The query string lets the browser/service worker keep an icon forever
     * (see public/sw.js) while a freshly uploaded replacement gets a new URL
     * and is picked up immediately. Returns null when there is no icon.
     */
    public function iconUrl(): ?string
    {
        if (!$this->icon_path) {
            return null;
        }

        $disk = Storage::disk('public');
        $url = $disk->url($this->icon_path);
        $version = $this->iconVersion($this->icon_path);

        return $version ? $url . '?v=' . $version : $url;
    }

    private function iconVersion(string $path): ?int
    {
        if (array_key_exists($path, self::$iconVersions)) {
            return self::$iconVersions[$path];
        }

        try {
            $version = Storage::disk('public')->lastModified($path);
        } catch (\Throwable) {
            // Missing/unreadable file: still expose the URL so the frontend
            // can fall back to its static icon map.
            $version = null;
        }

        return self::$iconVersions[$path] = $version;
    }

    /**
     * Slim {id, code, name, icon_url} projection for tables, chips and step
     * payloads. Including icon_url means every page that renders an office
     * icon via the frontend officeIcon() helper shows icons uploaded in the
     * admin Offices page automatically — no need to touch the code-keyed
     * static fallback map. Use for any office projection, it is null-safe.
     */
    public static function mini(?self $office): ?array
    {
        if (!$office) return null;

        return [
            'id' => $office->id,
            'code' => $office->code,
            'name' => $office->name,
            'icon_url' => $office->iconUrl(),
        ];
    }

    public function users()
    {
        return $this->hasMany(User::class);
    }

    public function steps()
    {
        return $this->hasMany(OfficeStep::class)->orderBy('order_number');
    }

    public function transactionTypes()
    {
        return $this->belongsToMany(TransactionType::class, 'office_transaction_type')
            ->withTimestamps();
    }
}
