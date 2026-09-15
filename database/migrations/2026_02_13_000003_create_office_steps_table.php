<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('office_steps', function (Blueprint $table) {
            $table->id();
            $table->foreignId('office_id')->constrained('offices')->cascadeOnDelete();
            $table->unsignedInteger('order_number')->default(1); // hierarchy: 1 - 2 - 3
            $table->string('code'); // snake_case, unique per office
            $table->string('name'); // Office Name of this step, e.g. "Received at CSD"
            $table->text('description')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();
            $table->softDeletes();

            $table->unique(['office_id', 'code']);
            $table->index(['office_id', 'order_number']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('office_steps');
    }
};
