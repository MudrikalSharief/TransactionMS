<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'office_id',
        'Contact_number',
        'password',
        'is_active',
        'approved_at',
        'approved_by',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'is_active' => 'boolean',
        'approved_at' => 'datetime',
    ];

    /** Signed up on the login page and not yet approved by an admin. */
    public function isPendingApproval(): bool
    {
        return $this->approved_at === null;
    }

    public function roles()
    {
        return $this->belongsToMany(Role::class)->withTimestamps()->ordered();
    }

    public function office()
    {
        return $this->belongsTo(Office::class);
    }

    public function hasRole(string $code): bool
    {
        return $this->roles()->where('code', $code)->exists();
    }

    /**
     * Viewer-only accounts track their own transactions read-only: no files,
     * no workflow actions. Anyone holding another role (superadmin, admin,
     * staff roles) is not viewer-only.
     */
    public function isViewerOnly(): bool
    {
        $this->loadMissing('roles');

        return $this->roles->isNotEmpty()
            && $this->roles->every(fn (Role $role) => $role->code === 'viewer');
    }

    public function isSuperadmin(): bool
    {
        $this->loadMissing('roles');

        return $this->roles->contains(fn ($r) => $r->code === 'superadmin');
    }

    /**
     * Office admin: holds the admin role and belongs to an office. Oversees
     * that office's transactions and users; superadmin outranks it.
     */
    public function isOfficeAdmin(): bool
    {
        $this->loadMissing('roles');

        return !$this->isSuperadmin()
            && (int) $this->office_id > 0
            && $this->roles->contains(fn ($r) => $r->code === 'admin');
    }
}
