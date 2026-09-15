<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();

            $table->foreignId('transaction_type_id')->constrained()->cascadeOnDelete();

            $table->foreignId('workflow_definition_id')->constrained('workflow_definitions')->cascadeOnDelete();

            $table->string('reference_number')->unique();
            $table->string('title')->nullable();

            $table->foreignId('created_by')->constrained('users')->cascadeOnDelete();

            $table->timestamps();
            $table->softDeletes();

            $table->index(['transaction_type_id', 'workflow_definition_id']);
        });
    }
};