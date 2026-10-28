<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ChecklistOverride extends Model
{
    protected $fillable = [
        'workflow_step_id',
        'requirement_definition_id',
        'name',
        'code',
        'description',
        'is_required',
        'display_order',
    ];

    protected $casts = [
        'is_required' => 'boolean',
        'display_order' => 'integer',
    ];

    public function workflowStep(): BelongsTo
    {
        return $this->belongsTo(WorkflowStep::class, 'workflow_step_id');
    }

    public function requirementDefinition(): BelongsTo
    {
        return $this->belongsTo(RequirementDefinition::class, 'requirement_definition_id');
    }
}
