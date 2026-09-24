<?php
namespace Database\Seeders;

use App\Models\FieldDefinition;
use App\Models\RequirementDefinition;
use App\Models\Role;
use App\Models\TransactionType;
use App\Models\WorkflowDefinition;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class PurchaseRequestSetupSeeder extends Seeder
{
    public function run(): void
    {
        DB::transaction(function (): void {
            $workflows = $this->resolveWorkflows();
            $fieldIds = $this->seedFieldLibrary();

            foreach ($workflows as $workflow) {
                $steps = $workflow->steps()->get()->keyBy('code');

                $this->attachFieldsToSteps($steps, $fieldIds);

                $requirementIds = $this->seedRequirements($workflow->id);
                $this->attachRequirementsToSteps($steps, $requirementIds);

                $this->assignRolesToSteps($steps);
            }
        });
    }

    /**
     * @return \Illuminate\Support\Collection<int, WorkflowDefinition>
     */
    private function resolveWorkflows()
    {
        $transactionType = TransactionType::where('code', 'procurement')->first();

        if (!$transactionType) {
            throw new \RuntimeException('Transaction type "procurement" not found. Run TransactionTypeSeeder first.');
        }

        $workflows = WorkflowDefinition::where('transaction_type_id', $transactionType->id)->get();

        if ($workflows->isEmpty()) {
            throw new \RuntimeException('Purchase Request workflow not found. Run WorkflowSeeder first.');
        }

        return $workflows;
    }

    private function resolveWorkflow(): WorkflowDefinition
    {
        return $this->resolveWorkflows()->firstWhere('version', 1) ?? $this->resolveWorkflows()->first();
    }

    /**
     * @return array<string, int>
     */
    private function seedFieldLibrary(): array
    {
        $fields = [
            ['code' => 'pr_number', 'name' => 'PR Number', 'type' => 'text'],
            ['code' => 'request_title', 'name' => 'Request Title', 'type' => 'text'],
            ['code' => 'office_name', 'name' => 'Office / Dept', 'type' => 'text'],
            ['code' => 'request_amount', 'name' => 'Amount', 'type' => 'number'],
            ['code' => 'drive_link', 'name' => 'Google Drive Link', 'type' => 'text'],
            ['code' => 'dts_number', 'name' => 'DTS Number', 'type' => 'text'],
            ['code' => 'remarks', 'name' => 'Remarks', 'type' => 'textarea'],
        ];

        $fieldIds = [];

        foreach ($fields as $index => $field) {
            $record = FieldDefinition::withTrashed()->updateOrCreate(
                [
                    'workflow_definition_id' => null,
                    'code' => $field['code'],
                ],
                [
                    'name' => $field['name'],
                    'type' => $field['type'],
                    'order_number' => $index + 1,
                    'display_order' => $index + 1,
                    'required' => false,
                    'unique' => false,
                    'sensitive' => false,
                ]
            );

            if ($record->trashed()) {
                $record->restore();
            }

            $fieldIds[$field['code']] = $record->id;
        }

        return $fieldIds;
    }

    /**
     * @param  \Illuminate\Support\Collection<string, \App\Models\WorkflowStep>  $steps
     * @param  array<string, int>  $fieldIds
     */
    private function attachFieldsToSteps($steps, array $fieldIds): void
    {
        $stepFields = [
            // Procurement is files-only (requirements + auto-mirrored
            // checklist), matching payroll. Former station-info fields
            // (request_title, office_name, request_amount, remarks,
            // drive_link, dts_number, pr_number) were old-code remnants.
            'create_pr' => [],
            'upload_drive' => [],
            'create_dts' => [],
            'gso_input_pr_no' => [],
        ];

        foreach ($stepFields as $stepCode => $fields) {
            $step = $steps->get($stepCode);
            if (!$step) {
                continue;
            }

            $desiredFieldIds = [];

            foreach ($fields as [$fieldCode, $required, $order]) {
                if (!isset($fieldIds[$fieldCode])) {
                    continue;
                }

                $fieldId = $fieldIds[$fieldCode];
                $desiredFieldIds[] = $fieldId;

                DB::table('field_definition_workflow_step')->updateOrInsert(
                    [
                        'workflow_step_id' => $step->id,
                        'field_definition_id' => $fieldId,
                    ],
                    [
                        'display_order' => $order,
                        'required_override' => (bool) $required,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]
                );
            }

            DB::table('field_definition_workflow_step')
                ->where('workflow_step_id', $step->id)
                ->whereNotIn('field_definition_id', $desiredFieldIds ?: [0])
                ->delete();
        }
    }

    /**
     * @return array<string, int>
     */
    private function seedRequirements(int $workflowId): array
    {
        $requirements = [
            ['code' => 'signed_pr_pdf', 'name' => 'Signed PR PDF attached'],
            ['code' => 'drive_uploaded', 'name' => 'Uploaded to Google Drive'],
            ['code' => 'dts_created', 'name' => 'DTS created'],
            ['code' => 'pr_encoded', 'name' => 'PR Number encoded'],
            ['code' => 'city_admin_signed', 'name' => 'City Admin signed'],
            ['code' => 'treasurer_signed', 'name' => 'Treasurer signed'],
            ['code' => 'doc_validated', 'name' => 'Document validated (untampered)'],
            ['code' => 'earmark_completed', 'name' => 'Earmark completed'],
        ];

        $ids = [];

        foreach ($requirements as $index => $requirement) {
            $record = RequirementDefinition::withTrashed()->updateOrCreate(
                [
                    'workflow_definition_id' => $workflowId,
                    'code' => $requirement['code'],
                ],
                [
                    'name' => $requirement['name'],
                    'description' => null,
                    'order_number' => $index + 1,
                    'is_active' => true,
                ]
            );

            if ($record->trashed()) {
                $record->restore();
            }

            $ids[$requirement['code']] = $record->id;
        }

        return $ids;
    }

    /**
     * @param  \Illuminate\Support\Collection<string, \App\Models\WorkflowStep>  $steps
     * @param  array<string, int>  $requirementIds
     */
    private function attachRequirementsToSteps($steps, array $requirementIds): void
    {
        $stepRequirements = [
            'create_pr' => ['signed_pr_pdf'],
            'upload_drive' => ['drive_uploaded'],
            'create_dts' => ['dts_created'],
            'gso_input_pr_no' => ['pr_encoded'],
            'city_admin_sign' => ['city_admin_signed'],
            'treasurer_sign' => ['treasurer_signed'],
            'cbo_validate' => ['doc_validated'],
            'cbo_earmark' => ['earmark_completed'],
        ];

        foreach ($stepRequirements as $stepCode => $codes) {
            $step = $steps->get($stepCode);
            if (!$step) {
                continue;
            }

            $desiredRequirementIds = [];

            foreach ($codes as $index => $code) {
                if (!isset($requirementIds[$code])) {
                    continue;
                }

                $requirementId = $requirementIds[$code];
                $desiredRequirementIds[] = $requirementId;

                DB::table('step_requirements')->updateOrInsert(
                    [
                        'workflow_step_id' => $step->id,
                        'requirement_definition_id' => $requirementId,
                    ],
                    [
                        'display_order' => $index + 1,
                        'is_required' => true,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]
                );
            }

            DB::table('step_requirements')
                ->where('workflow_step_id', $step->id)
                ->whereNotIn('requirement_definition_id', $desiredRequirementIds ?: [0])
                ->delete();
        }
    }

    /**
     * @param  \Illuminate\Support\Collection<string, \App\Models\WorkflowStep>  $steps
     */
    private function assignRolesToSteps($steps): void
    {
        $stepRoles = [
            'create_pr' => ['end_user'],
            'upload_drive' => ['end_user'],
            'create_dts' => ['end_user'],
            'email_gso' => ['end_user'],
            'gso_input_pr_no' => ['gso'],
            'gso_return_esig' => ['gso'],
            'city_admin_sign' => ['city_admin'],
            'email_cto' => ['end_user'],
            'treasurer_sign' => ['city_treasurer'],
            'email_cadmin' => ['cto'],
            'email_cbo' => ['cadmin'],
            'cbo_validate' => ['cbo'],
            'cbo_earmark' => ['cbo'],
            'submit_bac_paad' => ['bac_paad'],
        ];

        foreach ($stepRoles as $stepCode => $roleCodes) {
            $step = $steps->get($stepCode);
            if (!$step) {
                continue;
            }

            $roleIds = Role::whereIn('code', $roleCodes)->pluck('id')->all();
            if (count($roleIds) !== count($roleCodes)) {
                throw new \RuntimeException('Missing role mapping for step: ' . $stepCode);
            }

            foreach ($roleIds as $roleId) {
                DB::table('step_roles')->updateOrInsert(
                    [
                        'workflow_step_id' => $step->id,
                        'role_id' => $roleId,
                    ],
                    [
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]
                );
            }

            DB::table('step_roles')
                ->where('workflow_step_id', $step->id)
                ->whereNotIn('role_id', $roleIds ?: [0])
                ->delete();
        }
    }
}