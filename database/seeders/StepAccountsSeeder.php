<?php

namespace Database\Seeders;

use App\Models\StepRole;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

/**
 * One test account per station that nobody can work yet: for each active
 * process's live workflow, every step whose roles no user holds gets an
 * account with exactly that step's roles and office.
 *
 *   php artisan db:seed --class=StepAccountsSeeder
 *
 * Safe to re-run: accounts are matched by email ({process}.step{n}@lgu.test).
 * Not part of DatabaseSeeder; run it on purpose.
 */
class StepAccountsSeeder extends Seeder
{
    public function run(): void
    {
        // Roles somebody already holds, taken once up front so the result
        // doesn't depend on the order steps are processed in.
        $heldRoleIds = StepRole::query()
            ->join('role_user', 'role_user.role_id', '=', 'step_roles.role_id')
            ->distinct()
            ->pluck('step_roles.role_id')
            ->map(fn ($id) => (int) $id)
            ->all();

        foreach (TransactionType::query()->where('is_active', true)->orderBy('name')->get() as $type) {
            $workflow = WorkflowDefinition::query()
                ->where('transaction_type_id', $type->id)
                ->where('status', 'published')
                ->orderByDesc('is_live')
                ->orderByDesc('version')
                ->with(['steps' => fn ($q) => $q->orderBy('order_number'), 'steps.roles'])
                ->first();
            if (!$workflow) continue;

            $slug = Str::slug($type->code ?: $type->name, '');

            foreach ($workflow->steps as $step) {
                $roleIds = $step->roles->pluck('id')->map(fn ($id) => (int) $id)->all();
                if (empty($roleIds) || array_intersect($roleIds, $heldRoleIds)) continue;

                $email = "{$slug}.step{$step->order_number}@lgu.test";
                $user = User::updateOrCreate(['email' => $email], [
                    'name' => Str::limit("{$type->name} · Step {$step->order_number} · {$step->name}", 115, '…'),
                    'password' => Hash::make('admin123'),
                    'office_id' => $step->office_id,
                    'is_active' => true,
                    // Seeded accounts never wait for approval.
                    'approved_at' => now(),
                ]);
                $user->roles()->sync($roleIds);

                $this->command?->info(sprintf(
                    '%-34s %s step %d (%s) office=%s',
                    $email,
                    $type->name,
                    $step->order_number,
                    $step->roles->pluck('code')->join(', '),
                    $step->office?->code ?? '-'
                ));
            }
        }
    }
}
