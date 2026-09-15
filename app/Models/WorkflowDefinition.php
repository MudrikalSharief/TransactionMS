<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasManyThrough;

class WorkflowDefinition extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'transaction_type_id',
        'version',
        'status',
        'name',
        'notes',
        'published_at',
        'published_by',
    ];

    protected $casts = [
        'published_at' => 'datetime',
    ];

    public function transactionType()
    {
        return $this->belongsTo(TransactionType::class);
    }

    public function steps(): HasMany
    {
        return $this->hasMany(WorkflowStep::class);
    }

    public function routes(): HasMany
    {
        return $this->hasMany(WorkflowRoute::class);
    }

    public function stepRoles(): HasManyThrough
    {
        return $this->hasManyThrough(
            StepRole::class,
            WorkflowStep::class,
            'workflow_definition_id',
            'workflow_step_id',
            'id',
            'id'
        );
    }

    public function fieldDefinitions(): HasMany
    {
        return $this->hasMany(FieldDefinition::class);
    }

    public function requirementDefinitions(): HasMany
    {
        return $this->hasMany(RequirementDefinition::class, 'workflow_definition_id');
    }

    public function isDraft(): bool
    {
        return $this->status === 'draft';
    }

    public function isPublished(): bool
    {
        return $this->status === 'published';
    }

    public function isArchived(): bool
    {
        return $this->status === 'archived';
    }
}
