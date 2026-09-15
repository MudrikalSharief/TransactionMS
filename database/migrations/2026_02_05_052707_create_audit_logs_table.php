<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('audit_logs', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('actor_user_id')->nullable()->index();

            $table->string('event'); // e.g. auth.login, users.create, roles.update
            $table->string('entity_type')->nullable(); // e.g. App\Models\User
            $table->unsignedBigInteger('entity_id')->nullable();

            $table->json('meta')->nullable(); // append-only details (diffs, payload, reason)

            $table->string('ip')->nullable();
            $table->string('user_agent', 512)->nullable();

            $table->timestamp('created_at')->useCurrent();

            $table->foreign('actor_user_id')->references('id')->on('users');
            $table->index(['entity_type', 'entity_id']);
            $table->index(['event', 'created_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('audit_logs');
    }
};
