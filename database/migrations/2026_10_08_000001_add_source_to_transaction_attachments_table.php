<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('transaction_attachments', function (Blueprint $table) {
            $table->unsignedBigInteger('source_attachment_id')->nullable()->after('requirement_definition_id');
            $table->index(['source_attachment_id'], 'ix_ta_source');
            $table->foreign('source_attachment_id', 'fk_ta_source')
                ->references('id')->on('transaction_attachments')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::table('transaction_attachments', function (Blueprint $table) {
            $table->dropForeign('fk_ta_source');
            $table->dropIndex('ix_ta_source');
            $table->dropColumn('source_attachment_id');
        });
    }
};
