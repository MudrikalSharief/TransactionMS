<?php

namespace App\Models;

use Closure;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Rules\Exists;

class Role extends Model
{
    use SoftDeletes;

    /**
     * Role codes that grant office-admin powers: they manage their own
     * office only. The frontend mirrors this list in useAuth.js.
     */
    public const OFFICE_ADMIN_ROLE_CODES = ['admin'];

    public const HIERARCHY = [
        'superadmin',
        'admin',
        'office_head',
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
        'office_id',
    ];

    public function office()
    {
        return $this->belongsTo(Office::class);
    }

    public function scopeAvailableToOffice(Builder $query, ?int $officeId): Builder
    {
        return $query->where(self::officeConstraint($officeId));
    }

    public static function assignmentRule(?int $officeId): Exists
    {
        return Rule::exists('roles', 'id')->whereNull('deleted_at')->where(self::officeConstraint($officeId));
    }

    private static function officeConstraint(?int $officeId): Closure
    {
        return static function ($query) use ($officeId) {
            $query->whereNull('office_id');
            if ($officeId > 0) {
                $query->orWhere('office_id', $officeId);
            }
        };
    }

    public function canBeManagedBy(User $actor): bool
    {
        return $actor->isSuperadmin() || (
            $actor->isOfficeAdmin()
            && $this->office_id !== null
            && (int) $this->office_id === (int) $actor->office_id
            && !in_array($this->code, self::HIERARCHY, true)
        );
    }

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
}
