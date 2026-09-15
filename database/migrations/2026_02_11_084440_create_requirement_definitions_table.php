<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('requirement_definitions', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('workflow_definition_id');
            $table->unsignedInteger('order_number')->default(0);

            $table->string('code', 64);
            $table->string('name', 255);
            $table->text('description')->nullable();

            $table->boolean('is_active')->default(true);

            $table->timestamps();
            $table->softDeletes();

            $table->unique(['workflow_definition_id', 'code'], 'uq_reqdef_wf_code');

            $table->foreign('workflow_definition_id', 'fk_reqdef_wf')
                ->references('id')->on('workflow_definitions')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('requirement_definitions');
    }
};
