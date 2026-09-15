<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\TransactionType;
use App\Models\User;
use App\Models\WorkflowDefinition;
use Illuminate\Support\Facades\DB;

class WorkflowSeeder extends Seeder
{
    public function run(): void
    {
        $publisherId = User::query()->orderBy('id')->value('id');

        DB::transaction(function () use ($publisherId): void {
            $payroll = TransactionType::where('code', 'payroll')->first();
            $procurement = TransactionType::where('code', 'procurement')->first();

            if ($payroll) {
                $this->seedPayroll((int) $payroll->id, $publisherId ? (int) $publisherId : null);
            }

            if ($procurement) {
                $this->seedProcurement((int) $procurement->id, $publisherId ? (int) $publisherId : null);
            }
        });
    }

    private function seedPayroll(int $typeId, ?int $publisherId): void
    {
        $definition = $this->upsertDefinition($typeId, 1, [
            'status' => 'draft',
            'name' => 'Payroll v1',
            'notes' => 'Seeded sample workflow (TO VERIFY actual process)',
        ]);

        $steps = [
            'collect_dtr' => [
                'order_number' => 1,
                'name' => 'Collect DTR',
                'stage' => 'HR',
                'sla_minutes' => 2 * 24 * 60,
                'is_start' => true,
                'is_end' => false,
            ],
            'validate_dtr' => [
                'order_number' => 2,
                'name' => 'Validate DTR',
                'stage' => 'HR',
                'sla_minutes' => 2 * 24 * 60,
                'is_start' => false,
                'is_end' => false,
            ],
            'finalize_payroll' => [
                'order_number' => 3,
                'name' => 'Finalize Payroll',
                'stage' => 'Accounting',
                'sla_minutes' => 3 * 24 * 60,
                'is_start' => false,
                'is_end' => true,
            ],
        ];

        $createdSteps = $this->upsertSteps($definition, $steps);

        $routes = [
            ['from' => 'collect_dtr', 'to' => 'validate_dtr', 'action_code' => 'submit', 'is_return_route' => false],
            ['from' => 'validate_dtr', 'to' => 'finalize_payroll', 'action_code' => 'approve', 'is_return_route' => false],
            ['from' => 'validate_dtr', 'to' => 'collect_dtr', 'action_code' => 'return', 'is_return_route' => true, 'condition_expression' => null],
        ];

        $this->syncRoutes($definition, $createdSteps, $routes);

        $definition->update([
            'status' => 'published',
            'published_at' => now(),
            'published_by' => $publisherId,
        ]);
    }

    private function seedProcurement(int $typeId, ?int $publisherId): void
    {
        $definition = $this->upsertDefinition($typeId, 1, [
            'status' => 'draft',
            'name' => 'Purchase Request v1',
            'notes' => 'Seeded full PR workflow based on executive summary flow image',
        ]);

        $steps = [
            'create_pr' => [
                'order_number' => 1,
                'name' => 'Create Purchase Request + Attach E-Signature',
                'stage' => 'end_user',
                'sla_minutes' => 2 * 24 * 60,
                'is_start' => true,
                'is_end' => false,
            ],
            'upload_drive' => [
                'order_number' => 2,
                'name' => 'Upload to Google Drive (Get File Link)',
                'stage' => 'end_user',
                'sla_minutes' => 2 * 24 * 60,
                'is_start' => false,
                'is_end' => false,
            ],
            'create_dts' => [
                'order_number' => 3,
                'name' => 'Create DTS Transaction + Attach Drive Link',
                'stage' => 'end_user',
                'sla_minutes' => 2 * 24 * 60,
                'is_start' => false,
                'is_end' => false,
            ],
            'email_gso' => [
                'order_number' => 4,
                'name' => 'Email Document to GSO',
                'stage' => 'end_user',
                'sla_minutes' => 2 * 24 * 60,
                'is_start' => false,
                'is_end' => false,
            ],
            'gso_input_pr_no' => [
                'order_number' => 5,
                'name' => 'Input PR Number',
                'stage' => 'gso',
                'sla_minutes' => 2 * 24 * 60,
                'is_start' => false,
                'is_end' => false,
            ],
            'gso_return_esig' => [
                'order_number' => 6,
                'name' => 'Return to End User to Re-attach E-Sig',
                'stage' => 'gso',
                'sla_minutes' => 2 * 24 * 60,
                'is_start' => false,
                'is_end' => false,
            ],
            'city_admin_sign' => [
                'order_number' => 7,
                'name' => 'City Administrator Attaches E-Signature',
                'stage' => 'city_admin',
                'sla_minutes' => 2 * 24 * 60,
                'is_start' => false,
                'is_end' => false,
            ],
            'email_cto' => [
                'order_number' => 8,
                'name' => 'Email Document to CTO',
                'stage' => 'end_user',
                'sla_minutes' => 2 * 24 * 60,
                'is_start' => false,
                'is_end' => false,
            ],
            'treasurer_sign' => [
                'order_number' => 9,
                'name' => 'City Treasurer Attaches E-Signature',
                'stage' => 'city_treasurer',
                'sla_minutes' => 2 * 24 * 60,
                'is_start' => false,
                'is_end' => false,
            ],
            'email_cadmin' => [
                'order_number' => 10,
                'name' => 'CTO Emails Document to CAdmin',
                'stage' => 'cto',
                'sla_minutes' => 2 * 24 * 60,
                'is_start' => false,
                'is_end' => false,
            ],
            'email_cbo' => [
                'order_number' => 11,
                'name' => 'CAdmin Emails Document to CBO',
                'stage' => 'cadmin',
                'sla_minutes' => 2 * 24 * 60,
                'is_start' => false,
                'is_end' => false,
            ],
            'cbo_validate' => [
                'order_number' => 12,
                'name' => 'CBO Downloads Valid & Untampered Document',
                'stage' => 'cbo',
                'sla_minutes' => 2 * 24 * 60,
                'is_start' => false,
                'is_end' => false,
            ],
            'cbo_earmark' => [
                'order_number' => 13,
                'name' => 'CBO Prints & Fills Earmark Details',
                'stage' => 'cbo',
                'sla_minutes' => 2 * 24 * 60,
                'is_start' => false,
                'is_end' => false,
            ],
            'submit_bac_paad' => [
                'order_number' => 14,
                'name' => 'CBO Submits Documents to BAC-PAAD',
                'stage' => 'bac_paad',
                'sla_minutes' => 2 * 24 * 60,
                'is_start' => false,
                'is_end' => true,
            ],
        ];

        $createdSteps = $this->upsertSteps($definition, $steps);

        $routes = [
            ['from' => 'create_pr', 'to' => 'upload_drive', 'action_code' => 'submit', 'is_return_route' => false],
            ['from' => 'upload_drive', 'to' => 'create_dts', 'action_code' => 'submit', 'is_return_route' => false],
            ['from' => 'create_dts', 'to' => 'email_gso', 'action_code' => 'submit', 'is_return_route' => false],
            ['from' => 'email_gso', 'to' => 'gso_input_pr_no', 'action_code' => 'submit', 'is_return_route' => false],
            ['from' => 'gso_input_pr_no', 'to' => 'gso_return_esig', 'action_code' => 'submit', 'is_return_route' => false],
            ['from' => 'gso_return_esig', 'to' => 'city_admin_sign', 'action_code' => 'submit', 'is_return_route' => false],
            ['from' => 'city_admin_sign', 'to' => 'email_cto', 'action_code' => 'submit', 'is_return_route' => false],
            ['from' => 'email_cto', 'to' => 'treasurer_sign', 'action_code' => 'submit', 'is_return_route' => false],
            ['from' => 'treasurer_sign', 'to' => 'email_cadmin', 'action_code' => 'submit', 'is_return_route' => false],
            ['from' => 'email_cadmin', 'to' => 'email_cbo', 'action_code' => 'submit', 'is_return_route' => false],
            ['from' => 'email_cbo', 'to' => 'cbo_validate', 'action_code' => 'submit', 'is_return_route' => false],
            ['from' => 'cbo_validate', 'to' => 'cbo_earmark', 'action_code' => 'submit', 'is_return_route' => false],
            ['from' => 'cbo_earmark', 'to' => 'submit_bac_paad', 'action_code' => 'submit', 'is_return_route' => false],
            ['from' => 'gso_return_esig', 'to' => 'create_pr', 'action_code' => 'return', 'is_return_route' => true],
        ];

        $this->syncRoutes($definition, $createdSteps, $routes);

        $definition->update([
            'status' => 'published',
            'published_at' => now(),
            'published_by' => $publisherId,
        ]);
    }

    private function upsertDefinition(int $transactionTypeId, int $version, array $attributes): WorkflowDefinition
    {
        $definition = WorkflowDefinition::withTrashed()->firstOrNew([
            'transaction_type_id' => $transactionTypeId,
            'version' => $version,
        ]);

        $definition->fill($attributes);
        $definition->save();

        if ($definition->trashed()) {
            $definition->restore();
        }

        return $definition;
    }

    /**
     * @param  array<string, array<string, mixed>>  $steps
     * @return array<string, \App\Models\WorkflowStep>
     */
    private function upsertSteps(WorkflowDefinition $definition, array $steps): array
    {
        $created = [];

        foreach ($steps as $code => $payload) {
            $created[$code] = $definition->steps()->updateOrCreate(
                ['code' => $code],
                [
                    'order_number' => $payload['order_number'],
                    'name' => $payload['name'],
                    'stage' => $payload['stage'],
                    'sla_minutes' => $payload['sla_minutes'],
                    'is_start' => $payload['is_start'],
                    'is_end' => $payload['is_end'],
                ]
            );
        }

        $definition->steps()->whereNotIn('code', array_keys($steps))->delete();

        return $created;
    }

    /**
     * @param  array<string, \App\Models\WorkflowStep>  $steps
     * @param  array<int, array<string, mixed>>  $routes
     */
    private function syncRoutes(WorkflowDefinition $definition, array $steps, array $routes): void
    {
        $desired = [];

        foreach ($routes as $route) {
            if (!isset($steps[$route['from']], $steps[$route['to']])) {
                continue;
            }

            $fromStepId = $steps[$route['from']]->id;
            $toStepId = $steps[$route['to']]->id;
            $actionCode = $route['action_code'];
            $isReturnRoute = (bool) $route['is_return_route'];

            $record = $definition->routes()->updateOrCreate(
                [
                    'from_step_id' => $fromStepId,
                    'to_step_id' => $toStepId,
                    'action_code' => $actionCode,
                    'is_return_route' => $isReturnRoute,
                ],
                [
                    'condition_expression' => $route['condition_expression'] ?? null,
                    'route_group' => $route['route_group'] ?? null,
                    'required_approvals_count' => $route['required_approvals_count'] ?? null,
                ]
            );

            $desired[$record->id] = true;
        }

        $definition->routes()
            ->whereNotIn('id', array_keys($desired))
            ->delete();
    }
}
