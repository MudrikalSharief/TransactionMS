<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Http;
use App\Http\Controllers\Api\AuthController;
use App\Http\Middleware\EnsureRole;

use App\Http\Controllers\Api\Admin\UserController;
use App\Http\Controllers\Api\Admin\RoleController;
use App\Http\Controllers\Api\Admin\OfficeController;
use App\Http\Controllers\Api\Admin\OfficeStepController;
use App\Http\Controllers\Api\Admin\TransactionTypeController;
use App\Http\Controllers\Api\Admin\GovernmentReferenceController;
use App\Http\Controllers\Api\Admin\WorkflowDefinitionController;
use App\Http\Controllers\Api\Admin\WorkflowStepController;
use App\Http\Controllers\Api\Admin\WorkflowRouteController;

use App\Http\Controllers\Api\Admin\FieldDefinitionController;
use App\Http\Controllers\Api\Admin\StepFieldController;

use App\Http\Controllers\Api\Admin\RequirementDefinitionController;
use App\Http\Controllers\Api\Admin\StepRequirementController;

use App\Http\Controllers\Api\TransactionController;
use App\Http\Controllers\Api\TransactionRequirementController;

use App\Http\Controllers\Api\UserTransactionController;

Route::prefix('auth')->group(function () {
    Route::post('/login', [AuthController::class, 'login'])->middleware('guest');
    Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
    Route::get('/me', [AuthController::class, 'me'])->middleware('auth:sanctum');
});

// Public: current weather in Zamboanga City (proxied via Open-Meteo, no key needed)
Route::get('/weather', function () {
    try {
        $res = Http::timeout(8)->get('https://api.open-meteo.com/v1/forecast', [
            'latitude' => 6.9214,
            'longitude' => 122.0790,
            'current' => 'temperature_2m,weather_code,is_day',
            'timezone' => 'Asia/Manila',
        ]);

        if ($res->failed()) throw new \Exception('weather upstream failed');

        $current = $res->json('current', []);

        return response()->json([
            'temperature' => $current['temperature_2m'] ?? null,
            'code' => $current['weather_code'] ?? null,
            'is_day' => $current['is_day'] ?? 1,
            'time' => $current['time'] ?? null,
            'place' => 'Zamboanga City',
        ]);
    } catch (\Throwable $e) {
        return response()->json([
            'temperature' => null,
            'code' => null,
            'is_day' => 1,
            'time' => null,
            'place' => 'Zamboanga City',
        ], 200);
    }
});

Route::middleware(['auth:sanctum'])->group(function () {
    Route::get('/transactions', [UserTransactionController::class, 'index']);
    Route::get('/transactions/{transaction}', [UserTransactionController::class, 'show']);
    Route::post('/transactions/{transaction}/execute', [UserTransactionController::class, 'execute']);

    Route::post('/transactions/{transaction}/requirements/{requirementDefinition}/check', [TransactionRequirementController::class, 'check']);
    Route::delete('/transactions/{transaction}/requirements/{requirementDefinition}/check', [TransactionRequirementController::class, 'uncheck']);
});

Route::middleware(['auth:sanctum', EnsureRole::class . ':superadmin'])
    ->prefix('admin')
    ->group(function () {
        Route::apiResource('users', UserController::class)->only(['index', 'store', 'update', 'destroy']);
        Route::apiResource('roles', RoleController::class)->only(['index', 'store', 'update', 'destroy']);
        Route::apiResource('offices', OfficeController::class)->only(['index', 'store', 'update', 'destroy']);

        // Offices - Steps (hierarchy 1 - 2 - 3)
        Route::get('offices/{office}/steps', [OfficeStepController::class, 'index']);
        Route::post('offices/{office}/steps', [OfficeStepController::class, 'store']);
        Route::put('offices/{office}/steps/{officeStep}', [OfficeStepController::class, 'update']);
        Route::delete('offices/{office}/steps/{officeStep}', [OfficeStepController::class, 'destroy']);

        Route::apiResource('transaction-types', TransactionTypeController::class)->only(['index', 'store', 'update', 'destroy']);
        Route::apiResource('government-references', GovernmentReferenceController::class)->only(['index', 'store', 'update', 'destroy']);

        Route::get('workflow-definitions', [WorkflowDefinitionController::class, 'index']);
        Route::post('workflow-definitions', [WorkflowDefinitionController::class, 'store']);
        Route::get('workflow-definitions/{workflowDefinition}', [WorkflowDefinitionController::class, 'show']);
        Route::delete('workflow-definitions/{workflowDefinition}', [WorkflowDefinitionController::class, 'destroy']);
        Route::post('workflow-definitions/{workflowDefinition}/publish', [WorkflowDefinitionController::class, 'publish']);

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

        // Transactions
        Route::get('/transactions', [TransactionController::class, 'index']);
        Route::post('/transactions', [TransactionController::class, 'store']);
        Route::get('/transactions/{transaction}', [TransactionController::class, 'show']);
        Route::delete('/transactions/{transaction}', [TransactionController::class, 'destroy']);
        Route::put('/transactions/{transaction}/office', [TransactionController::class, 'updateOffice']);
        Route::post('/transactions/{transaction}/execute', [TransactionController::class, 'executeAction']);

    });
