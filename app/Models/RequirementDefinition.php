<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class RequirementDefinition extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'workflow_definition_id',
        'order_number',
        'code',
        'name',
        'description',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    public function workflowDefinition()
    {
        return $this->belongsTo(WorkflowDefinition::class);
    }

    public function steps()
    {
        return $this->belongsToMany(
            WorkflowStep::class,
            'step_requirements',
            'requirement_definition_id',
            'workflow_step_id'
        )->withPivot(['display_order', 'is_required'])
         ->withTimestamps()
         ->orderBy('step_requirements.display_order');
    }
}
