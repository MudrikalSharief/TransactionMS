<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('workflow_step_data', function (Blueprint $table) {
            $table->id();
            $table->foreignId('workflow_step_id')->constrained('workflow_steps')->cascadeOnDelete();
            $table->string('code', 100);
            $table->string('display_name');
            $table->string('type', 50)->default('text');
            $table->boolean('is_required')->default(false);
            $table->unsignedInteger('display_order')->default(0);
            $table->unsignedInteger('min_length')->nullable();
            $table->unsignedInteger('max_length')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->unique(['workflow_step_id', 'code']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('workflow_step_data');
    }
};
