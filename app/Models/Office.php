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
            'icon_url' => $office->icon_path
                ? Storage::disk('public')->url($office->icon_path)
                : null,
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
