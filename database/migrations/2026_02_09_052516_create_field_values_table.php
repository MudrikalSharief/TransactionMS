<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('field_values', function (Blueprint $table) {
            $table->id();

            $table->foreignId('transaction_id')->constrained()->cascadeOnDelete();
            $table->foreignId('field_definition_id')->constrained('field_definitions')->cascadeOnDelete();

            $table->json('value_json')->nullable();

            $table->text('value_text')->nullable();

            $table->timestamps();

            $table->unique(['transaction_id', 'field_definition_id'], 'uniq_tx_field');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('field_values');
    }
};
