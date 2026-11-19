<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/** Append-only responsibility history; identity snapshots survive account deletion. */
class TransactionOfficerAssignment extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'transaction_id', 'transaction_step_run_id', 'from_user_id', 'to_user_id',
        'assigned_by', 'from_user_name', 'to_user_name', 'assigned_by_name', 'assigned_at', 'reason',
        'is_automatic',
    ];

    protected $casts = ['assigned_at' => 'datetime', 'is_automatic' => 'boolean'];

    public function stepRun()
    {
        return $this->belongsTo(TransactionStepRun::class, 'transaction_step_run_id');
    }

    public function toEvent(): array
    {
        return [
            'id' => $this->id,
            'step_run_id' => $this->transaction_step_run_id,
            'is_automatic' => (bool) $this->is_automatic,
            'from_officer' => ['id' => $this->from_user_id, 'name' => $this->from_user_name],
            'to_officer' => ['id' => $this->to_user_id, 'name' => $this->to_user_name],
            'assigned_by' => ['id' => $this->assigned_by, 'name' => $this->assigned_by_name],
            'assigned_at' => $this->assigned_at?->toISOString(),
            'reason' => $this->reason,
        ];
    }
}
