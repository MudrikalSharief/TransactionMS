<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'username',
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
    /**
     * Username format, shared by sign-up and the admin user forms:
     * 3-30 lowercase letters, numbers, dots or underscores, starting and
     * ending with a letter or number. No "@", so sign-in can tell a
     * username from an email.
     */
    public static function usernameRules(bool $required, ?int $ignoreId = null): array
    {
        return [
            $required ? 'required' : 'nullable',
            'string',
            'min:3',
            'max:30',
            'regex:/^[a-z0-9](?:[a-z0-9._]*[a-z0-9])?$/',
            \Illuminate\Validation\Rule::unique('users', 'username')->ignore($ignoreId),
        ];
    }

    public const USERNAME_MESSAGES = [
        'username.required' => 'Choose a username.',
        'username.min' => 'Use at least 3 characters for the username.',
        'username.max' => 'Use at most 30 characters for the username.',
        'username.regex' => 'Use lowercase letters, numbers, dots or underscores (start and end with a letter or number).',
        'username.unique' => 'That username is already taken.',
    ];

    /** Usernames are stored lowercase and trimmed; blank means none. */
    public static function normalizeUsername(?string $value): ?string
    {
        $v = strtolower(trim((string) $value));
        return $v === '' ? null : $v;
    }

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
