<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Office extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'code',
        'name',
        'description',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    public function users()
    {
        return $this->hasMany(User::class);
    }

    public function steps()
    {
        return $this->hasMany(OfficeStep::class)->orderBy('order_number');
    }

    public function transactionTypes()
    {
        return $this->belongsToMany(TransactionType::class, 'office_transaction_type')
            ->withTimestamps();
    }
}
