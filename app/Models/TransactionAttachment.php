<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TransactionAttachment extends Model
{
    protected $fillable = [
        'transaction_id',
        'workflow_step_id',
        'requirement_definition_id',
        'step_run_id',
        'original_name',
        'stored_path',
        'disk',
        'mime',
        'size_bytes',
        'uploaded_by',
    ];

    protected $casts = [
        'size_bytes' => 'integer',
    ];

    public function transaction()
    {
        return $this->belongsTo(Transaction::class);
    }

    public function step()
    {
        return $this->belongsTo(WorkflowStep::class, 'workflow_step_id');
    }

    public function requirement()
    {
        return $this->belongsTo(RequirementDefinition::class, 'requirement_definition_id');
    }

    public function stepRun()
    {
        return $this->belongsTo(TransactionStepRun::class, 'step_run_id');
    }

    public function uploader()
    {
        return $this->belongsTo(User::class, 'uploaded_by');
    }
}
