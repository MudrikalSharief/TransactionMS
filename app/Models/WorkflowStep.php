<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class WorkflowStep extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'workflow_definition_id',
        'parent_id',
        'order_number',
        'code',
        'name',
        'stage',
        'sla_minutes',
        'is_start',
        'is_end',
    ];

    protected $casts = [
        'is_start' => 'boolean',
        'is_end' => 'boolean',
    ];

    public function workflowDefinition(): BelongsTo
    {
        return $this->belongsTo(WorkflowDefinition::class);
    }

    public function definition()
    {
        return $this->belongsTo(WorkflowDefinition::class, 'workflow_definition_id');
    }

    public function parent(): BelongsTo
    {
        return $this->belongsTo(WorkflowStep::class, 'parent_id');
    }

    public function children(): HasMany
    {
        return $this->hasMany(WorkflowStep::class, 'parent_id')->orderBy('order_number');
    }

    public function outgoingRoutes(): HasMany
    {
        return $this->hasMany(WorkflowRoute::class, 'from_step_id');
    }

    public function incomingRoutes(): HasMany
    {
        return $this->hasMany(WorkflowRoute::class, 'to_step_id');
    }

    public function fieldDefinitions(): BelongsToMany
    {
        return $this->belongsToMany(FieldDefinition::class, 'field_definition_workflow_step')
            ->withPivot(['display_order', 'required_override'])
            ->withTimestamps()
            ->orderBy('field_definition_workflow_step.display_order')
            ->orderBy('field_definitions.order_number');
    }

    public function fields(): BelongsToMany
    {
        return $this->fieldDefinitions();
    }

    public function roles()
    {
        return $this->belongsToMany(Role::class, 'step_roles', 'workflow_step_id', 'role_id')
            ->withTimestamps();
    }
    public function requirementDefinitions(): BelongsToMany
    {
        return $this->belongsToMany(
            RequirementDefinition::class,
            'step_requirements',
            'workflow_step_id',
            'requirement_definition_id'
        )->withPivot(['display_order', 'is_required'])
            ->withTimestamps()
            ->orderBy('step_requirements.display_order')
            ->orderBy('requirement_definitions.order_number');
    }


    public function requirements(): BelongsToMany
    {
        return $this->requirementDefinitions();
    }
}
