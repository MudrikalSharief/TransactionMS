<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Transaction extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'transaction_type_id',
        'workflow_definition_id',
        'office_id',
        'reference_number',
        'title',
        'is_done',
        'created_by',
    ];

    protected $casts = [
        'is_done' => 'boolean',
    ];

    public function type()
    {
        return $this->belongsTo(TransactionType::class, 'transaction_type_id');
    }

    public function workflow()
    {
        return $this->belongsTo(WorkflowDefinition::class, 'workflow_definition_id');
    }

    public function runs()
    {
        return $this->hasMany(TransactionStepRun::class)->orderByDesc('performed_at');
    }

    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    public function transactionType(): BelongsTo
    {
        return $this->belongsTo(TransactionType::class);
    }

    public function workflowDefinition(): BelongsTo
    {
        return $this->belongsTo(WorkflowDefinition::class);
    }

    public function office(): BelongsTo
    {
        return $this->belongsTo(Office::class);
    }

    public function state()
    {
        return $this->hasOne(TransactionState::class);
    }

    public function stepRuns(): HasMany
    {
        return $this->hasMany(TransactionStepRun::class);
    }

    public function fieldValues(): HasMany
    {
        return $this->hasMany(FieldValue::class);
    }

    public function requirementChecks(): HasMany
    {
        return $this->hasMany(TransactionRequirementCheck::class);
    }

    public function checklistChecks(): HasMany
    {
        return $this->hasMany(TransactionChecklistCheck::class);
    }

    public function attachments(): HasMany
    {
        return $this->hasMany(TransactionAttachment::class)->orderByDesc('created_at');
    }

    public function stepData(): HasMany
    {
        return $this->hasMany(TransactionStepData::class)->orderByDesc('entered_at');
    }

    public function fieldValuesByCode(): array
    {
        $this->loadMissing(['fieldValues.fieldDefinition']);

        $out = [];
        foreach ($this->fieldValues as $fv) {
            $code = $fv->fieldDefinition?->code;
            if (!$code) continue;
            $out[$code] = $fv->typedValue();
        }
        return $out;
    }

    /**
     * End-user stations (step roles include end_user) follow this
     * transaction's office instead of the workflow template's step office.
     */
    public function stepIsEndUser(WorkflowStep $step): bool
    {
        if ($step->relationLoaded('roles')) {
            return $step->roles->contains(fn ($role) => $role->code === 'end_user');
        }

        $this->loadMissing('workflow.stepRoles.role');

        return (bool) $this->workflow?->stepRoles
            ?->where('workflow_step_id', (int) $step->id)
            ->contains(fn ($stepRole) => ($stepRole->role?->code ?? null) === 'end_user');
    }

    /**
     * Effective office of a step for this transaction.
     *
     * End-user stations and blank assignments both follow the transaction's
     * Originating Office (the office that created it). A fixed office keeps
     * that office. Legacy transactions without an originating office resolve
     * to null, which keeps their blank stations role-only at runtime.
     */
    public function effectiveStepOffice(WorkflowStep $step): ?Office
    {
        if ($this->stepIsEndUser($step) || $step->office_id === null) {
            return $this->office;
        }

        return $step->office;
    }

    public function effectiveStepOfficeId(WorkflowStep $step): ?int
    {
        return $this->effectiveStepOffice($step)?->id;
    }

    /**
     * Assigned office of a step: the office that works the station.
     *
     * End-user stations and blank assignments are dynamic and follow the
     * transaction's Originating Office. Every other station uses the office
     * assigned to it in the workflow.
     */
    public function displayStepOffice(WorkflowStep $step): ?Office
    {
        return $this->effectiveStepOffice($step);
    }
}
