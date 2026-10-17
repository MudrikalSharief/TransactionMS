<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Http;
use App\Http\Controllers\Api\AuthController;
use App\Http\Middleware\EnsurePermission;
use App\Http\Middleware\EnsureOfficeAdmin;
use App\Http\Middleware\EnsureRole;
use App\Http\Middleware\EnsureTransactionOffice;

use App\Http\Controllers\Api\Admin\UserController;
use App\Http\Controllers\Api\Admin\RoleController;
use App\Http\Controllers\Api\Admin\PermissionController;
use App\Http\Controllers\Api\Admin\OfficeController;
use App\Http\Controllers\Api\Admin\OfficeStepController;
use App\Http\Controllers\Api\Admin\TransactionTypeController;
use App\Http\Controllers\Api\Admin\GovernmentReferenceController;
use App\Http\Controllers\Api\Admin\WorkflowDefinitionController;
use App\Http\Controllers\Api\Admin\WorkflowStepController;
use App\Http\Controllers\Api\Admin\WorkflowRouteController;
use App\Http\Controllers\Api\Admin\DashboardSummaryController;

use App\Http\Controllers\Api\Admin\FieldDefinitionController;
use App\Http\Controllers\Api\Admin\StepFieldController;

use App\Http\Controllers\Api\Admin\RequirementDefinitionController;
use App\Http\Controllers\Api\Admin\StepRequirementController;
use App\Http\Controllers\Api\Admin\StepChecklistController;
use App\Http\Controllers\Api\Admin\StepDataController;

use App\Http\Controllers\Api\TransactionController;
use App\Http\Controllers\Api\TransactionRequirementController;
use App\Http\Controllers\Api\TransactionChecklistController;
use App\Http\Controllers\Api\TransactionAttachmentController;

use App\Http\Controllers\Api\TransactionGotoController;
use App\Http\Controllers\Api\TransactionFinalizeController;
use App\Http\Controllers\Api\TransactionReceiveController;
use App\Http\Controllers\Api\UserTransactionController;
use App\Http\Controllers\Api\ApprovalController;

Route::prefix('auth')->group(function () {
    Route::post('/login', [AuthController::class, 'login'])->middleware('guest');
    Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
    Route::get('/me', [AuthController::class, 'me'])->middleware('auth:sanctum');
});

// Public: current weather in Zamboanga City (proxied via Open-Meteo, no key needed)
// 30min server cache: previously every AppShell mount hit upstream with an 8s
// timeout — brutal on bad networks. Now one upstream call per 30min max.
Route::get('/weather', function () {
    $data = \Illuminate\Support\Facades\Cache::remember('weather:zamboanga', 1800, function () {
        try {
            $res = Http::timeout(4)->get('https://api.open-meteo.com/v1/forecast', [
                'latitude' => 6.9214,
                'longitude' => 122.0790,
                'current' => 'temperature_2m,weather_code,is_day',
                'timezone' => 'Asia/Manila',
            ]);

            if ($res->failed()) throw new \Exception('weather upstream failed');

            $current = $res->json('current', []);

            return [
                'temperature' => $current['temperature_2m'] ?? null,
                'code' => $current['weather_code'] ?? null,
                'is_day' => $current['is_day'] ?? 1,
                'time' => $current['time'] ?? null,
                'place' => 'Zamboanga City',
            ];
        } catch (\Throwable $e) {
            return [
                'temperature' => null,
                'code' => null,
                'is_day' => 1,
                'time' => null,
                'place' => 'Zamboanga City',
            ];
        }
    });

    return response()->json($data)
        ->header('Cache-Control', 'public, max-age=600');
});

Route::middleware(['auth:sanctum'])->group(function () {
    Route::get('/approvals', [ApprovalController::class, 'index']);
    Route::get('/approvals/count', [ApprovalController::class, 'count']);

    Route::get('/transactions', [UserTransactionController::class, 'index']);
    // Static path must precede {transaction} or "version" binds as a model id.
    Route::get('/transactions/version', [UserTransactionController::class, 'version']);
    Route::get('/transactions/{transaction}', [UserTransactionController::class, 'show']);
    Route::post('/transactions/{transaction}/execute', [UserTransactionController::class, 'execute']);
    Route::post('/transactions/{transaction}/receive', [TransactionReceiveController::class, 'receive']);
    Route::post('/transactions/{transaction}/goto', [TransactionGotoController::class, 'goto']);
    Route::post('/transactions/{transaction}/finalize', [TransactionFinalizeController::class, 'finalize']);

    Route::post('/transactions/{transaction}/requirements/{requirementDefinition}/check', [TransactionRequirementController::class, 'check']);
    Route::delete('/transactions/{transaction}/requirements/{requirementDefinition}/check', [TransactionRequirementController::class, 'uncheck']);

    Route::post('/transactions/{transaction}/checklist/{checklistOverride}/check', [TransactionChecklistController::class, 'check']);
    Route::delete('/transactions/{transaction}/checklist/{checklistOverride}/check', [TransactionChecklistController::class, 'uncheck']);

    Route::get('/transactions/{transaction}/attachments', [TransactionAttachmentController::class, 'index']);
    Route::post('/transactions/{transaction}/attachments', [TransactionAttachmentController::class, 'store']);
    Route::post('/transactions/{transaction}/attachments/reuse', [TransactionAttachmentController::class, 'reuse']);
    Route::delete('/transactions/{transaction}/attachments/{attachment}/unlink', [TransactionAttachmentController::class, 'unlink']);
    Route::get('/transactions/{transaction}/attachments/{attachment}/download', [TransactionAttachmentController::class, 'download']);
    Route::get('/transactions/{transaction}/attachments/{attachment}/view', [TransactionAttachmentController::class, 'view']);
    Route::delete('/transactions/{transaction}/attachments/{attachment}', [TransactionAttachmentController::class, 'destroy']);
});

Route::middleware(['auth:sanctum'])
    ->prefix('admin')
    ->group(function () {
        Route::apiResource('users', UserController::class)->only(['index'])
            ->middleware(EnsurePermission::class.':users.view');
        Route::apiResource('users', UserController::class)->only(['store', 'update', 'destroy'])
            ->middleware(EnsurePermission::class.':users.manage');

        Route::get('permissions', [PermissionController::class, 'index'])
            ->middleware(EnsurePermission::class.':roles.view');
        Route::apiResource('roles', RoleController::class)->only(['index'])
            ->middleware(EnsurePermission::class.':roles.view');
        Route::apiResource('roles', RoleController::class)->only(['store', 'update', 'destroy'])
            ->middleware(EnsurePermission::class.':roles.manage');
        Route::put('roles/{role}/permissions', [RoleController::class, 'syncPermissions'])
            ->middleware(EnsurePermission::class.':roles.manage');

        Route::apiResource('offices', OfficeController::class)->only(['index'])
            ->middleware(EnsurePermission::class.':offices.view');
        Route::apiResource('offices', OfficeController::class)->only(['store', 'update', 'destroy'])
            ->middleware(EnsurePermission::class.':offices.manage');

        // Offices - Steps (hierarchy 1 - 2 - 3)
        Route::get('offices/{office}/steps', [OfficeStepController::class, 'index'])
            ->middleware(EnsurePermission::class.':offices.view');
        Route::post('offices/{office}/steps', [OfficeStepController::class, 'store'])
            ->middleware(EnsurePermission::class.':offices.manage');
        Route::put('offices/{office}/steps/{officeStep}', [OfficeStepController::class, 'update'])
            ->middleware(EnsurePermission::class.':offices.manage');
        Route::delete('offices/{office}/steps/{officeStep}', [OfficeStepController::class, 'destroy'])
            ->middleware(EnsurePermission::class.':offices.manage');

        // Open lookup (office-filtered in the controller); writes are
        // superadmin or office admins (admin role + office), enforced in
        // the controller per-record.
        Route::apiResource('transaction-types', TransactionTypeController::class)->only(['index']);
        Route::apiResource('transaction-types', TransactionTypeController::class)->only(['store', 'update', 'destroy'])
            ->middleware(EnsureOfficeAdmin::class);

        Route::apiResource('government-references', GovernmentReferenceController::class)->only(['index'])
            ->middleware(EnsurePermission::class.':government_references.view');
        Route::apiResource('government-references', GovernmentReferenceController::class)->only(['store', 'update', 'destroy'])
            ->middleware(EnsurePermission::class.':government_references.manage');

        Route::get('workflow-definitions', [WorkflowDefinitionController::class, 'index'])
            ->middleware(EnsurePermission::class.':workflows.view');
        Route::get('workflow-definitions/{workflowDefinition}', [WorkflowDefinitionController::class, 'show'])
            ->middleware(EnsurePermission::class.':workflows.view');
        Route::post('workflow-definitions', [WorkflowDefinitionController::class, 'store'])
            ->middleware(EnsurePermission::class.':workflows.manage');
        Route::delete('workflow-definitions/{workflowDefinition}', [WorkflowDefinitionController::class, 'destroy'])
            ->middleware(EnsurePermission::class.':workflows.manage');
        Route::post('workflow-definitions/{workflowDefinition}/publish', [WorkflowDefinitionController::class, 'publish'])
            ->middleware(EnsurePermission::class.':workflows.manage');
        Route::post('workflow-definitions/{workflowDefinition}/make-live', [WorkflowDefinitionController::class, 'makeLive'])
            ->middleware(EnsurePermission::class.':workflows.manage');
        Route::post('workflow-definitions/{workflowDefinition}/save-as', [WorkflowDefinitionController::class, 'saveAs'])
            ->middleware(EnsurePermission::class.':workflows.manage');
        // Staged save: one atomic apply of client-staged steps/routes/
        // requirements/checklists/field-assignments onto the open draft.
        Route::post('workflow-definitions/{workflowDefinition}/apply-staged', [WorkflowDefinitionController::class, 'applyStaged'])
            ->middleware(EnsurePermission::class.':workflows.manage');

        // Workflows - Routes
        Route::post('workflow-definitions/{workflowDefinition}/routes', [WorkflowRouteController::class, 'store'])
            ->middleware(EnsurePermission::class.':workflows.manage');
        Route::put('workflow-definitions/{workflowDefinition}/routes/{workflowRoute}', [WorkflowRouteController::class, 'update'])
            ->middleware(EnsurePermission::class.':workflows.manage');
        Route::delete('workflow-definitions/{workflowDefinition}/routes/{workflowRoute}', [WorkflowRouteController::class, 'destroy'])
            ->middleware(EnsurePermission::class.':workflows.manage');

        // Workflows - Steps
        Route::get('workflow-definitions/{workflowDefinition}/steps', [WorkflowStepController::class, 'index'])
            ->middleware(EnsurePermission::class.':workflows.view');
        Route::post('workflow-definitions/{workflowDefinition}/steps', [WorkflowStepController::class, 'store'])
            ->middleware(EnsurePermission::class.':workflows.manage');
        Route::put('workflow-definitions/{workflowDefinition}/steps/{workflowStep}', [WorkflowStepController::class, 'update'])
            ->middleware(EnsurePermission::class.':workflows.manage');
        Route::delete('workflow-definitions/{workflowDefinition}/steps/{workflowStep}', [WorkflowStepController::class, 'destroy'])
            ->middleware(EnsurePermission::class.':workflows.manage');

        // Dynamic Fields - Definitions
        Route::apiResource('fields', FieldDefinitionController::class)->only(['index'])
            ->middleware(EnsurePermission::class.':fields.view');
        Route::apiResource('fields', FieldDefinitionController::class)->only(['store', 'update', 'destroy'])
            ->middleware(EnsurePermission::class.':fields.manage');

        // Dynamic Fields - Assign to a step
        Route::get('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/fields', [StepFieldController::class, 'index'])
            ->middleware(EnsurePermission::class.':fields.view');
        Route::post('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/fields/sync', [StepFieldController::class, 'sync'])
            ->middleware(EnsurePermission::class.':fields.manage');

        // Requirements - Definitions (versioned)
        Route::get('workflow-definitions/{workflowDefinition}/requirements', [RequirementDefinitionController::class, 'index'])
            ->middleware(EnsurePermission::class.':requirements.view');
        Route::post('workflow-definitions/{workflowDefinition}/requirements', [RequirementDefinitionController::class, 'store'])
            ->middleware(EnsurePermission::class.':requirements.manage');
        Route::put('workflow-definitions/{workflowDefinition}/requirements/{requirementDefinition}', [RequirementDefinitionController::class, 'update'])
            ->middleware(EnsurePermission::class.':requirements.manage');
        Route::delete('workflow-definitions/{workflowDefinition}/requirements/{requirementDefinition}', [RequirementDefinitionController::class, 'destroy'])
            ->middleware(EnsurePermission::class.':requirements.manage');
        Route::post('workflow-definitions/{workflowDefinition}/requirements/{requirementDefinition}/steps/sync', [RequirementDefinitionController::class, 'syncSteps'])
            ->middleware(EnsurePermission::class.':requirements.manage');

        // Requirements - Assign to a step
        Route::get('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/requirements', [StepRequirementController::class, 'index'])
            ->middleware(EnsurePermission::class.':requirements.view');
        Route::post('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/requirements/sync', [StepRequirementController::class, 'sync'])
            ->middleware(EnsurePermission::class.':requirements.manage');

        // Checklist - per-step overrides (seeded from requirements, then free-edited)
        Route::get('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/checklist', [StepChecklistController::class, 'index'])
            ->middleware(EnsurePermission::class.':requirements.view');
        Route::post('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/checklist/sync', [StepChecklistController::class, 'sync'])
            ->middleware(EnsurePermission::class.':requirements.manage');
        Route::post('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/checklist/resync', [StepChecklistController::class, 'resync'])
            ->middleware(EnsurePermission::class.':requirements.manage');

        // Step data - per-step text data (receipt number, etc.), history per visit
        Route::get('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/step-data', [StepDataController::class, 'index'])
            ->middleware(EnsurePermission::class.':requirements.view');
        Route::post('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/step-data', [StepDataController::class, 'store'])
            ->middleware(EnsurePermission::class.':requirements.manage');
        Route::put('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/step-data/{stepData}', [StepDataController::class, 'update'])
            ->middleware(EnsurePermission::class.':requirements.manage');
        Route::delete('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/step-data/{stepData}', [StepDataController::class, 'destroy'])
            ->middleware(EnsurePermission::class.':requirements.manage');

        // Dashboard - Transaction Summary card
        Route::get('/dashboard/summary', DashboardSummaryController::class)
            ->middleware(EnsurePermission::class.':dashboard.view');
        Route::get('/dashboard/summary/{category}', [DashboardSummaryController::class, 'details'])
            ->whereIn('category', ['completed', 'in_process', 'overdue', 'deleted', 'process'])
            ->middleware(EnsurePermission::class.':dashboard.view');

        // Transactions: the list/detail/steps are open to everyone. Rows are
        // office + role scoped (office admins see their whole office,
        // superadmin sees all). Creating stays behind the Create Transactions
        // toggle; delete/reassign stay superadmin-only.
        Route::get('/transactions', [TransactionController::class, 'index']);
        Route::post('/transactions', [TransactionController::class, 'store'])
            ->middleware(EnsurePermission::class.':transactions.manage');
        Route::get('/transactions/{transaction}', [TransactionController::class, 'show'])
            ->middleware(EnsureTransactionOffice::class);
        Route::delete('/transactions/{transaction}', [TransactionController::class, 'destroy'])
            ->middleware(EnsureRole::class.':superadmin');
        Route::put('/transactions/{transaction}/office', [TransactionController::class, 'updateOffice'])
            ->middleware(EnsureRole::class.':superadmin');
        Route::post('/transactions/{transaction}/execute', [TransactionController::class, 'executeAction'])
            ->middleware(EnsureTransactionOffice::class);
        Route::post('/transactions/{transaction}/receive', [TransactionReceiveController::class, 'receive'])
            ->middleware(EnsureTransactionOffice::class);
        Route::post('/transactions/{transaction}/goto', [TransactionGotoController::class, 'goto'])
            ->middleware(EnsureTransactionOffice::class);
        Route::post('/transactions/{transaction}/finalize', [TransactionFinalizeController::class, 'finalize'])
            ->middleware(EnsureTransactionOffice::class);

        Route::get('/transactions/{transaction}/attachments', [TransactionAttachmentController::class, 'index'])
            ->middleware(EnsureTransactionOffice::class);
        Route::post('/transactions/{transaction}/attachments', [TransactionAttachmentController::class, 'store'])
            ->middleware(EnsureTransactionOffice::class);
        Route::post('/transactions/{transaction}/attachments/reuse', [TransactionAttachmentController::class, 'reuse'])
            ->middleware(EnsureTransactionOffice::class);
        Route::delete('/transactions/{transaction}/attachments/{attachment}/unlink', [TransactionAttachmentController::class, 'unlink'])
            ->middleware(EnsureTransactionOffice::class);
        Route::get('/transactions/{transaction}/attachments/{attachment}/download', [TransactionAttachmentController::class, 'download'])
            ->middleware(EnsureTransactionOffice::class);
        Route::get('/transactions/{transaction}/attachments/{attachment}/view', [TransactionAttachmentController::class, 'view'])
            ->middleware(EnsureTransactionOffice::class);
        Route::delete('/transactions/{transaction}/attachments/{attachment}', [TransactionAttachmentController::class, 'destroy'])
            ->middleware(EnsureTransactionOffice::class);

    });
