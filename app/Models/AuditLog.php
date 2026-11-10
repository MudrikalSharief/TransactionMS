<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AuditLog extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'actor_user_id',
        'actor_name',
        'actor_email',
        'actor_roles',
        'actor_office_id',
        'actor_office_code',
        'actor_is_superadmin',
        'event',
        'module',
        'action',
        'description',
        'entity_type',
        'entity_id',
        'entity_label',
        'office_id',
        'transaction_id',
        'step_run_id',
        'old_values',
        'new_values',
        'changed_fields',
        'meta',
        'ip',
        'user_agent',
        'request_method',
        'request_path',
        'request_id',
        'created_at',
    ];

    protected $casts = [
        'actor_roles' => 'array',
        'actor_is_superadmin' => 'boolean',
        'old_values' => 'array',
        'new_values' => 'array',
        'changed_fields' => 'array',
        'meta' => 'array',
        'created_at' => 'datetime',
    ];

    protected static function booted(): void
    {
        static::updating(function (): void {
            throw new \RuntimeException('Audit logs are append-only and cannot be updated.');
        });

        static::deleting(function (): void {
            throw new \RuntimeException('Audit logs are append-only and cannot be deleted.');
        });
    }

    public function actor(): BelongsTo
    {
        return $this->belongsTo(User::class, 'actor_user_id');
    }

    public function office(): BelongsTo
    {
        return $this->belongsTo(Office::class, 'office_id')->withTrashed();
    }

    public function transaction(): BelongsTo
    {
        return $this->belongsTo(Transaction::class, 'transaction_id')->withTrashed();
    }
}
