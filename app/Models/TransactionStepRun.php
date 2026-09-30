<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TransactionStepRun extends Model
{
    protected $fillable = [
        'transaction_id',
        'from_step_id',
        'to_step_id',
        'action_code',
        'remarks',
        'performed_by',
        'performed_at',
        'received_at',
        'received_by',
        'received_office_id',
        'sla_minutes_snapshot',
    ];

    protected $casts = [
        'performed_at' => 'datetime',
        'received_at' => 'datetime',
        'sla_minutes_snapshot' => 'integer',
    ];

    public function transaction()
    {
        return $this->belongsTo(Transaction::class);
    }

    public function fromStep()
    {
        return $this->belongsTo(WorkflowStep::class, 'from_step_id');
    }

    public function toStep()
    {
        return $this->belongsTo(WorkflowStep::class, 'to_step_id');
    }

    public function performer()
    {
        return $this->belongsTo(User::class, 'performed_by')->with('roles');
    }

    public function receiver()
    {
        return $this->belongsTo(User::class, 'received_by')->with('roles');
    }

    public function receivedOffice()
    {
        return $this->belongsTo(Office::class, 'received_office_id');
    }

    public function attachments()
    {
        return $this->hasMany(\App\Models\TransactionAttachment::class, 'step_run_id');
    }

    public function getIsPendingAttribute(): bool
    {
        return $this->received_at === null;
    }

    public function getActualMinutesAttribute(): ?int
    {
        if (!$this->performed_at || !$this->received_at) return null;
        return (int) max(0, $this->performed_at->diffInMinutes($this->received_at, true));
    }

    public function getIsBreachedAttribute(): bool
    {
        $actual = $this->actual_minutes;
        if ($actual === null) return false;
        return $actual > (int) ($this->sla_minutes_snapshot ?? 0);
    }
}
