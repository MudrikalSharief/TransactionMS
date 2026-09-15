<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class StepRole extends Model
{
    protected $table = 'step_roles';

    protected $fillable = [
        'workflow_step_id',
        'role_id',
    ];

    public function step(): BelongsTo
    {
        return $this->belongsTo(WorkflowStep::class, 'workflow_step_id');
    }

    public function role(): BelongsTo
    {
        return $this->belongsTo(Role::class, 'role_id');
    }
}
