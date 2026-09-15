<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('office_steps', function (Blueprint $table) {
            // Hierarchy lives on transaction (workflow) steps instead —
            // office steps stay a flat 1-2-3 list.
            $table->dropIndex(['office_id', 'parent_id', 'order_number']);
            $table->dropConstrainedForeignId('parent_id');
        });
    }

    public function down(): void
    {
        Schema::table('office_steps', function (Blueprint $table) {
            $table->foreignId('parent_id')->nullable()->after('office_id')->constrained('office_steps')->nullOnDelete();
            $table->index(['office_id', 'parent_id', 'order_number']);
        });
    }
};
