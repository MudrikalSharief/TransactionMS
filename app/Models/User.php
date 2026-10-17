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
        'password',
        'is_active',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'is_active' => 'boolean',
    ];

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

    public function isOfficeAdmin(): bool
    {
        $this->loadMissing('roles');

        return $this->office_id !== null
            && $this->roles->contains(fn (Role $role) => $role->code === 'admin');
    }

    public function hasPermission(string $code): bool
    {
        $this->loadMissing('roles.permissions');

        if ($this->roles->contains(fn (Role $role) => $role->code === 'superadmin')) {
            return true;
        }

        $codes = $this->roles->flatMap(fn (Role $role) => $role->permissions->pluck('code'));

        if ($codes->contains($code)) {
            return true;
        }

        return str_ends_with($code, '.view')
            && $codes->contains(substr($code, 0, -5).'.manage');
    }

    public function permissionCodes(): array
    {
        $this->loadMissing('roles.permissions');

        if ($this->roles->contains(fn (Role $role) => $role->code === 'superadmin')) {
            return Permission::query()->orderBy('code')->pluck('code')->all();
        }

        return $this->roles
            ->flatMap(fn (Role $role) => $role->permissions->pluck('code'))
            ->unique()
            ->sort()
            ->values()
            ->all();
    }
}
