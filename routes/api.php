<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Http;
use App\Http\Controllers\Api\AuthController;
use App\Http\Middleware\BlockViewer;
use App\Http\Middleware\EnsureOfficeAdmin;
use App\Http\Middleware\EnsureViewer;
use App\Http\Middleware\EnsureRole;
use App\Http\Middleware\EnsureTransactionOffice;

use App\Http\Controllers\Api\Admin\UserController;
use App\Http\Controllers\Api\Admin\RoleController;
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
use App\Http\Controllers\Api\PortalController;
use App\Http\Controllers\Api\ViewerTrackingController;

Route::prefix('auth')->group(function () {
    Route::post('/login', [AuthController::class, 'login'])->middleware('guest');
    Route::post('/guest', [AuthController::class, 'guest'])->middleware(['guest', 'throttle:20,1']);
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

// Viewer accounts: read-only tracking of the transactions they created.
// No files, no workflow actions (every other transaction route blocks them).
Route::middleware(['auth:sanctum', EnsureViewer::class])
    ->prefix('viewer')
    ->group(function () {
        Route::get('/transactions', [ViewerTrackingController::class, 'index']);
        Route::get('/transactions/{transaction}', [ViewerTrackingController::class, 'show']);
    });

// Static path must precede {transaction} or "version" binds as a model id.
// Aggregate stamps only (no rows), so viewers may poll it too.
Route::middleware(['auth:sanctum'])->get('/transactions/version', [UserTransactionController::class, 'version']);

Route::middleware(['auth:sanctum', BlockViewer::class])->group(function () {
    Route::get('/portal/summary', [PortalController::class, 'summary']);

    Route::get('/approvals', [ApprovalController::class, 'index']);
    Route::get('/approvals/count', [ApprovalController::class, 'count']);

    Route::get('/transactions', [UserTransactionController::class, 'index']);
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

Route::middleware(['auth:sanctum', BlockViewer::class])
    ->prefix('admin')
    ->group(function () {
        // Master data: superadmin only.
        Route::middleware(EnsureRole::class.':superadmin')->group(function () {
            Route::apiResource('users', UserController::class)->only(['index', 'store', 'update', 'destroy']);

            Route::apiResource('roles', RoleController::class)->only(['index', 'store', 'update', 'destroy']);

            Route::apiResource('offices', OfficeController::class)->only(['index', 'store', 'update', 'destroy']);

            // Offices - Steps (hierarchy 1 - 2 - 3)
            Route::get('offices/{office}/steps', [OfficeStepController::class, 'index']);
            Route::post('offices/{office}/steps', [OfficeStepController::class, 'store']);
            Route::put('offices/{office}/steps/{officeStep}', [OfficeStepController::class, 'update']);
            Route::delete('offices/{office}/steps/{officeStep}', [OfficeStepController::class, 'destroy']);

            Route::apiResource('government-references', GovernmentReferenceController::class)->only(['index', 'store', 'update', 'destroy']);

            Route::get('workflow-definitions', [WorkflowDefinitionController::class, 'index']);
            Route::get('workflow-definitions/{workflowDefinition}', [WorkflowDefinitionController::class, 'show']);
            Route::post('workflow-definitions', [WorkflowDefinitionController::class, 'store']);
            Route::delete('workflow-definitions/{workflowDefinition}', [WorkflowDefinitionController::class, 'destroy']);
            Route::post('workflow-definitions/{workflowDefinition}/publish', [WorkflowDefinitionController::class, 'publish']);
            Route::post('workflow-definitions/{workflowDefinition}/make-live', [WorkflowDefinitionController::class, 'makeLive']);
            Route::post('workflow-definitions/{workflowDefinition}/save-as', [WorkflowDefinitionController::class, 'saveAs']);
            // Staged save: one atomic apply of client-staged steps/routes/
            // requirements/checklists/field-assignments onto the open draft.
            Route::post('workflow-definitions/{workflowDefinition}/apply-staged', [WorkflowDefinitionController::class, 'applyStaged']);

            // Workflows - Routes
            Route::post('workflow-definitions/{workflowDefinition}/routes', [WorkflowRouteController::class, 'store']);
            Route::put('workflow-definitions/{workflowDefinition}/routes/{workflowRoute}', [WorkflowRouteController::class, 'update']);
            Route::delete('workflow-definitions/{workflowDefinition}/routes/{workflowRoute}', [WorkflowRouteController::class, 'destroy']);

            // Workflows - Steps
            Route::get('workflow-definitions/{workflowDefinition}/steps', [WorkflowStepController::class, 'index']);
            Route::post('workflow-definitions/{workflowDefinition}/steps', [WorkflowStepController::class, 'store']);
            Route::put('workflow-definitions/{workflowDefinition}/steps/{workflowStep}', [WorkflowStepController::class, 'update']);
            Route::delete('workflow-definitions/{workflowDefinition}/steps/{workflowStep}', [WorkflowStepController::class, 'destroy']);

            // Dynamic Fields - Definitions
            Route::apiResource('fields', FieldDefinitionController::class)->only(['index', 'store', 'update', 'destroy']);

            // Dynamic Fields - Assign to a step
            Route::get('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/fields', [StepFieldController::class, 'index']);
            Route::post('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/fields/sync', [StepFieldController::class, 'sync']);

            // Requirements - Definitions (versioned)
            Route::get('workflow-definitions/{workflowDefinition}/requirements', [RequirementDefinitionController::class, 'index']);
            Route::post('workflow-definitions/{workflowDefinition}/requirements', [RequirementDefinitionController::class, 'store']);
            Route::put('workflow-definitions/{workflowDefinition}/requirements/{requirementDefinition}', [RequirementDefinitionController::class, 'update']);
            Route::delete('workflow-definitions/{workflowDefinition}/requirements/{requirementDefinition}', [RequirementDefinitionController::class, 'destroy']);
            Route::post('workflow-definitions/{workflowDefinition}/requirements/{requirementDefinition}/steps/sync', [RequirementDefinitionController::class, 'syncSteps']);

            // Requirements - Assign to a step
            Route::get('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/requirements', [StepRequirementController::class, 'index']);
            Route::post('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/requirements/sync', [StepRequirementController::class, 'sync']);

            // Checklist - per-step overrides (seeded from requirements, then free-edited)
            Route::get('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/checklist', [StepChecklistController::class, 'index']);
            Route::post('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/checklist/sync', [StepChecklistController::class, 'sync']);
            Route::post('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/checklist/resync', [StepChecklistController::class, 'resync']);

            // Step data - per-step text data (receipt number, etc.), history per visit
            Route::get('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/step-data', [StepDataController::class, 'index']);
            Route::post('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/step-data', [StepDataController::class, 'store']);
            Route::put('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/step-data/{stepData}', [StepDataController::class, 'update']);
            Route::delete('workflow-definitions/{workflowDefinition}/steps/{workflowStep}/step-data/{stepData}', [StepDataController::class, 'destroy']);
        });

        // Open lookup (office-filtered in the controller); writes are
        // superadmin or office admins (admin role + office), enforced in
        // the controller per-record.
        Route::apiResource('transaction-types', TransactionTypeController::class)->only(['index']);
        Route::apiResource('transaction-types', TransactionTypeController::class)->only(['store', 'update', 'destroy'])
            ->middleware(EnsureOfficeAdmin::class);

        // Dashboard - Transaction Summary card (superadmin or office admin,
        // scoped to their office for the latter).
        Route::get('/dashboard/summary', DashboardSummaryController::class)
            ->middleware(EnsureOfficeAdmin::class);
        Route::get('/dashboard/summary/{category}', [DashboardSummaryController::class, 'details'])
            ->whereIn('category', ['completed', 'in_process', 'overdue', 'deleted', 'process'])
            ->middleware(EnsureOfficeAdmin::class);

        // Transactions: the list/detail/steps are open to everyone. Regular
        // users see their own office's rows plus rows waiting on one of
        // their roles at their office; office admins see rows parked at
        // their office; superadmin sees all. Creating is open to any user
        // with an office (non-superadmin creations are forced to their own
        // office); delete/reassign stay superadmin-only.
        Route::get('/transactions', [TransactionController::class, 'index']);
        Route::post('/transactions', [TransactionController::class, 'store']);
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
