<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('field_definitions', function (Blueprint $table) {
            $table->id();

            $table->foreignId('workflow_definition_id')->constrained()->cascadeOnDelete();

            $table->unsignedInteger('order_number')->default(0);
            $table->string('code'); 
            $table->string('name');
            $table->string('type'); 

            $table->string('group')->nullable();
            $table->unsignedInteger('display_order')->default(0);

            $table->boolean('required')->default(false);
            $table->boolean('unique')->default(false);
            $table->boolean('sensitive')->default(false);

            $table->unsignedInteger('min_length')->nullable();
            $table->unsignedInteger('max_length')->nullable();
            $table->decimal('min_value', 18, 4)->nullable();
            $table->decimal('max_value', 18, 4)->nullable();

            $table->json('options')->nullable(); 
            $table->json('validation_rules')->nullable(); 

            $table->timestamps();
            $table->softDeletes();

            $table->unique(['workflow_definition_id', 'code']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('field_definitions');
    }
};
