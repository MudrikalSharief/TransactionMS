<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Role extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'code',
        'name',
        'description',
    ];

    public function users()
    {
        return $this->belongsToMany(User::class)->withTimestamps();
    }

    public function permissions()
    {
        return $this->belongsToMany(Permission::class)->withTimestamps();
    }
}
