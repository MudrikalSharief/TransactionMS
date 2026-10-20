<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasOne;
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
     * Published workflow this type follows — same precedence the create
     * engine uses: live-flagged version first, then highest version. Used by
     * the New Transaction dialog to preview the steps before creating.
     */
    public function liveWorkflow(): HasOne
    {
        return $this->hasOne(WorkflowDefinition::class, 'transaction_type_id')
            ->where('status', 'published')
            ->orderByDesc('is_live')
            ->orderByDesc('version');
    }
}
