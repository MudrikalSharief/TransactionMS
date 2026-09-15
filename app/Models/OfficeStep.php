<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class OfficeStep extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'office_id',
        'parent_id',
        'order_number',
        'code',
        'name',
        'description',
        'is_active',
    ];

    protected $casts = [
        'order_number' => 'integer',
        'is_active' => 'boolean',
    ];

    public function office()
    {
        return $this->belongsTo(Office::class);
    }

    public function parent()
    {
        return $this->belongsTo(OfficeStep::class, 'parent_id');
    }

    public function children()
    {
        return $this->hasMany(OfficeStep::class, 'parent_id')->orderBy('order_number');
    }
}
