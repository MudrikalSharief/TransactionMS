<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('workflow_steps', function (Blueprint $table) {
            $table->id();
            $table->foreignId('workflow_definition_id')->constrained()->cascadeOnDelete();

            $table->unsignedInteger('order_number')->default(1);
            $table->string('code'); // snake_case unique per workflow version
            $table->string('name');
            $table->string('stage')->nullable(); // Budget, Accounting, Treasury
            $table->unsignedInteger('sla_minutes')->default(0);

            $table->boolean('is_start')->default(false);
            $table->boolean('is_end')->default(false);

            $table->timestamps();
            $table->softDeletes();

            $table->unique(['workflow_definition_id', 'code']);
            $table->index(['workflow_definition_id', 'order_number']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('workflow_steps');
    }
};
