<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TransactionChecklistCheck extends Model
{
    protected $fillable = [
        'transaction_id',
        'workflow_step_id',
        'checklist_override_id',
        'checked_by',
        'checked_at',
    ];

    protected $casts = [
        'checked_at' => 'datetime',
    ];

    public function transaction()
    {
        return $this->belongsTo(Transaction::class);
    }

    public function step()
    {
        return $this->belongsTo(WorkflowStep::class, 'workflow_step_id');
    }

    public function item()
    {
        return $this->belongsTo(ChecklistOverride::class, 'checklist_override_id');
    }

    public function checker()
    {
        return $this->belongsTo(User::class, 'checked_by');
    }
}
