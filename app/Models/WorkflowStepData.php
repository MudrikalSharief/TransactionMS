<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class WorkflowStepData extends Model
{
    protected $table = 'workflow_step_data';

    protected $fillable = [
        'workflow_step_id',
        'code',
        'display_name',
        'type',
        'is_required',
        'display_order',
        'min_length',
        'max_length',
    ];

    protected $casts = [
        'is_required' => 'boolean',
    ];

    use SoftDeletes;

    public function step(): BelongsTo
    {
        return $this->belongsTo(WorkflowStep::class, 'workflow_step_id');
    }

    public function values(): HasMany
    {
        return $this->hasMany(TransactionStepData::class, 'workflow_step_data_id');
    }
}
