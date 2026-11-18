<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TransactionState extends Model
{
    protected $fillable = [
        'transaction_id',
        'current_step_id',
        'current_run_id',
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

    /** The run that brought the paper into the current step. */
    public function currentRun()
    {
        return $this->belongsTo(TransactionStepRun::class, 'current_run_id');
    }

    /**
     * Current visit, falling back to the newest run that entered the current
     * step for legacy rows that predate transaction_states.current_run_id.
     */
    public function currentVisit(): ?TransactionStepRun
    {
        $run = $this->currentRun;
        if ($run && (int) $run->to_step_id === (int) $this->current_step_id) return $run;
        if (!$this->current_step_id) return null;

        if ($this->transaction?->relationLoaded('runs')) {
            return $this->transaction->runs
                ->where('to_step_id', $this->current_step_id)
                ->sortByDesc(fn ($r) => [$r->performed_at?->timestamp ?? 0, $r->id])
                ->first();
        }

        return TransactionStepRun::where('transaction_id', $this->transaction_id)
            ->where('to_step_id', $this->current_step_id)
            ->orderByDesc('performed_at')
            ->orderByDesc('id')
            ->first();
    }
}
