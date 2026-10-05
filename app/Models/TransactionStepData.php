<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class TransactionStepData extends Model
{
    protected $table = 'transaction_step_data';

    protected $fillable = [
        'transaction_id',
        'workflow_step_data_id',
        'transaction_step_run_id',
        'workflow_step_id',
        'data_value',
        'entered_by',
        'entered_at',
    ];

    protected $casts = [
        'entered_at' => 'datetime',
    ];

    public function transaction(): BelongsTo
    {
        return $this->belongsTo(Transaction::class);
    }

    public function definition(): BelongsTo
    {
        return $this->belongsTo(WorkflowStepData::class, 'workflow_step_data_id');
    }

    public function step(): BelongsTo
    {
        return $this->belongsTo(WorkflowStep::class, 'workflow_step_id');
    }

    public function run(): BelongsTo
    {
        return $this->belongsTo(TransactionStepRun::class, 'transaction_step_run_id');
    }

    public function enterer(): BelongsTo
    {
        return $this->belongsTo(User::class, 'entered_by');
    }
}
