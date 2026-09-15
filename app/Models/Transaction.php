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
        'created_by',
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

    public function attachments(): HasMany
    {
        return $this->hasMany(TransactionAttachment::class)->orderByDesc('created_at');
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
}
