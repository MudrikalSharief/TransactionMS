<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class TransactionType extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'code',
        'name',
        'description',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    public function offices()
    {
        return $this->belongsToMany(Office::class, 'office_transaction_type')
            ->withTimestamps();
    }

    /**
     * Processes an office may start: active, with a published workflow, and
     * either linked to that office or linked to no office (open to all).
     */
    public function scopeFileableBy(Builder $query, int $officeId): Builder
    {
        return $query
            ->where('is_active', true)
            ->whereHas('workflows', fn ($w) => $w->where('status', 'published'))
            ->where(fn ($q) => $q
                ->whereHas('offices', fn ($o) => $o->where('offices.id', $officeId))
                ->orDoesntHave('offices'));
    }

    public function workflows()
    {
        return $this->hasMany(WorkflowDefinition::class);
    }
}
