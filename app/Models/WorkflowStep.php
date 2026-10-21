<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
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
        'office_id',
        'sla_minutes',
        'is_start',
        'is_end',
        'is_end_user',
    ];

    protected $casts = [
        'is_start' => 'boolean',
        'is_end' => 'boolean',
        'is_end_user' => 'boolean',
    ];

    /**
     * SQL prefilter for the current station's effective office.
     *
     * A fixed office applies unless the station is marked end-user; blank
     * assignments and end-user stations follow the transaction's Originating
     * Office. Used inside whereHas('state.currentStep') queries so the list
     * pages match RoutingEngine::userCanWorkOnStep without loading everything.
     */
    public function scopeWhereEffectiveOffice(Builder $query, ?int $officeId): Builder
    {
        if ($officeId === null) {
            return $query->whereRaw('1 = 0');
        }

        return $query->where(function (Builder $x) use ($officeId) {
            $x->where(function (Builder $y) use ($officeId) {
                $y->where('workflow_steps.office_id', $officeId)
                    ->where('workflow_steps.is_end_user', false);
            })->orWhere(function (Builder $y) use ($officeId) {
                $y->where('transactions.office_id', $officeId)
                    ->where(function (Builder $z) {
                        $z->whereNull('workflow_steps.office_id')
                            ->orWhere('workflow_steps.is_end_user', true);
                    });
            });
        });
    }

    /**
     * Legacy transactions with no Originating Office keep role-only access to
     * blank and end-user stations. Callers must add the role match separately;
     * this scope only identifies the eligible stations.
     */
    public function scopeWhereLegacyNoOriginFallback(Builder $query): Builder
    {
        return $query->whereNull('transactions.office_id')
            ->where(function (Builder $x) {
                $x->whereNull('workflow_steps.office_id')
                    ->orWhere('workflow_steps.is_end_user', true);
            });
    }

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

    public function office(): BelongsTo
    {
        return $this->belongsTo(Office::class);
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
        )->withPivot(['display_order', 'is_required', 'is_upload_required'])
            ->withTimestamps()
            ->orderBy('step_requirements.display_order')
            ->orderBy('requirement_definitions.order_number');
    }


    public function requirements(): BelongsToMany
    {
        return $this->requirementDefinitions();
    }

    public function checklistOverrides(): HasMany
    {
        return $this->hasMany(ChecklistOverride::class, 'workflow_step_id');
    }

    public function stepDataDefinitions(): HasMany
    {
        return $this->hasMany(WorkflowStepData::class, 'workflow_step_id')->orderBy('display_order');
    }
}
