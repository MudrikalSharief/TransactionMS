<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('field_values', function (Blueprint $table) {
            if (!Schema::hasColumn('field_values', 'value_number')) {
                $table->decimal('value_number', 18, 2)->nullable()->after('value_text');
            }

            if (!Schema::hasColumn('field_values', 'updated_by')) {
                $table->foreignId('updated_by')
                    ->nullable()
                    ->constrained('users')
                    ->nullOnDelete()
                    ->after('field_definition_id');
            }
        });
    }

    public function down(): void
    {
        Schema::table('field_values', function (Blueprint $table) {
            if (Schema::hasColumn('field_values', 'updated_by')) {
                $table->dropConstrainedForeignId('updated_by');
            }

            if (Schema::hasColumn('field_values', 'value_number')) {
                $table->dropColumn('value_number');
            }
        });
    }
};
