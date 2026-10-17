<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Role extends Model
{
    use SoftDeletes;

    public const HIERARCHY = [
        'superadmin',
        'admin',
        'clerk',
        'clerk_releasing',
        'approver',
        'viewer',
        'end_user',
        'gso',
        'city_admin',
        'cto',
        'city_treasurer',
        'cadmin',
        'cbo',
        'bac_paad',
        'clerk_receiving',
        'clerk_procurement',
        'staff_technical',
    ];

    protected $fillable = [
        'code',
        'name',
        'description',
    ];

    public function scopeOrdered(Builder $query): Builder
    {
        $whens = collect(self::HIERARCHY)
            ->map(fn (string $code, int $rank) => "WHEN ? THEN {$rank}")
            ->implode(' ');

        return $query
            ->orderByRaw("CASE code {$whens} ELSE " . count(self::HIERARCHY) . " END", self::HIERARCHY)
            ->orderBy('name');
    }

    public function users()
    {
        return $this->belongsToMany(User::class)->withTimestamps();
    }

    public function permissions()
    {
        return $this->belongsToMany(Permission::class)->withTimestamps();
    }
}
