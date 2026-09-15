<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('workflow_routes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('workflow_definition_id')->constrained()->cascadeOnDelete();

            $table->foreignId('from_step_id')->constrained('workflow_steps')->cascadeOnDelete();
            $table->foreignId('to_step_id')->constrained('workflow_steps')->cascadeOnDelete();

            $table->string('action_code'); // submit, approve, return, reject
            $table->boolean('is_return_route')->default(false);

            // SAFE evaluator input: JSON logic-ish object stored as JSON.
            // Example: {"and":[{">=":[{"var":"amount"},50000]},{"==":[{"var":"fund_source"},"GF"]}]}
            $table->json('condition_expression')->nullable();

            $table->string('route_group')->nullable(); // lane/group for parallel approvals
            $table->unsignedInteger('required_approvals_count')->nullable(); // for merge gates

            $table->timestamps();
            $table->softDeletes();

            $table->index(['workflow_definition_id', 'action_code']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('workflow_routes');
    }
};
