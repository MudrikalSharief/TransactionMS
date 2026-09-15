<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TransactionRequirementCheck extends Model
{
    protected $fillable = [
        'transaction_id',
        'workflow_step_id',
        'requirement_definition_id',
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

    public function requirement()
    {
        return $this->belongsTo(RequirementDefinition::class, 'requirement_definition_id');
    }

    public function checker()
    {
        return $this->belongsTo(User::class, 'checked_by');
    }
}
