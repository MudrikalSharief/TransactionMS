<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class WorkflowRoute extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'workflow_definition_id',
        'from_step_id',
        'to_step_id',
        'action_code',
        'is_return_route',
        'condition_expression',
        'route_group',
        'required_approvals_count',
    ];

protected $casts = [
    'is_return_route' => 'boolean',
    'required_approvals_count' => 'integer',
    'condition_expression' => 'array', 
];

    public function definition()
    {
        return $this->belongsTo(WorkflowDefinition::class, 'workflow_definition_id');
    }

    public function fromStep()
    {
        return $this->belongsTo(WorkflowStep::class, 'from_step_id');
    }

    public function toStep()
    {
        return $this->belongsTo(WorkflowStep::class, 'to_step_id');
    }
}
