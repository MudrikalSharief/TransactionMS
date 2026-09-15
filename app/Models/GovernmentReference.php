<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class GovernmentReference extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'code',
        'title',
        'source',
        'url',
        'notes',
        'is_verified',
    ];

    protected $casts = [
        'is_verified' => 'boolean',
    ];
}
