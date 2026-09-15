<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('workflow_definitions', function (Blueprint $table) {
            $table->id();

            $table->foreignId('transaction_type_id')
                ->constrained()
                ->cascadeOnDelete();

            $table->unsignedInteger('version')->default(1);
            // v1, v2, v3 — pinned by transactions

            $table->string('status')->default('draft');
            // draft | published | archived

            $table->string('name')->nullable();
            // optional display name per version

            $table->text('notes')->nullable();
            // admin-only notes, not used in logic

            $table->timestamp('published_at')->nullable();
            $table->foreignId('published_by')
                ->nullable()
                ->constrained('users')
                ->nullOnDelete();

            $table->timestamps();
            $table->softDeletes();

            $table->unique(['transaction_type_id', 'version']);
            $table->index(['transaction_type_id', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('workflow_definitions');
    }
};
