<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TransactionState extends Model
{
    protected $fillable = [
        'transaction_id',
        'current_step_id',
        'entered_at',
    ];

    protected $casts = [
        'entered_at' => 'datetime',
    ];

    public function transaction()
    {
        return $this->belongsTo(Transaction::class);
    }

    public function currentStep()
    {
        return $this->belongsTo(WorkflowStep::class, 'current_step_id');
    }
}
