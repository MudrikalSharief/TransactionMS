<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class FieldDefinition extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'workflow_definition_id',
        'order_number',
        'code',
        'name',
        'type',
        'step_scope',
        'display_order',
        'group',
        'required',
        'unique',
        'sensitive',
        'min_length',
        'max_length',
        'min_value',
        'max_value',
        'options',
        'validation_rules',
    ];

    protected $casts = [
        'required' => 'boolean',
        'unique' => 'boolean',
        'sensitive' => 'boolean',
        'options' => 'array',
        'validation_rules' => 'array',
        'min_value' => 'decimal:2',
        'max_value' => 'decimal:2',
    ];

    public function workflowDefinition(): BelongsTo
    {
        return $this->belongsTo(WorkflowDefinition::class);
    }

    public function steps(): BelongsToMany
    {
        return $this->belongsToMany(WorkflowStep::class, 'field_definition_workflow_step')
            ->withPivot(['display_order', 'required_override'])
            ->withTimestamps();
    }

    public function values(): HasMany
    {
        return $this->hasMany(FieldValue::class);
    }
}
