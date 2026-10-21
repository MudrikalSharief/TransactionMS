<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * transaction_types.createdby_office -> offices.id (the office that
     * created the type). The column was first added by hand as a NOT NULL
     * varchar, which can't reference the bigint offices.id; it becomes a
     * nullable unsigned bigint, blank/unknown values become NULL, and the
     * foreign key is added. Databases without the column get it created.
     */
    public function up(): void
    {
        if (Schema::hasColumn('transaction_types', 'createdby_office')) {
            // Nullable first, so blanks can be cleared before the type change.
            Schema::table('transaction_types', function (Blueprint $table) {
                $table->string('createdby_office')->nullable()->change();
            });
            DB::table('transaction_types')
                ->where(fn ($q) => $q->where('createdby_office', '')
                    ->orWhereRaw("createdby_office NOT REGEXP '^[0-9]+$'")
                    ->orWhereNotIn('createdby_office', DB::table('offices')->select(DB::raw('CAST(id AS CHAR)'))))
                ->update(['createdby_office' => null]);
            Schema::table('transaction_types', function (Blueprint $table) {
                $table->unsignedBigInteger('createdby_office')->nullable()->change();
            });
        } else {
            Schema::table('transaction_types', function (Blueprint $table) {
                $table->unsignedBigInteger('createdby_office')->nullable();
            });
        }

        Schema::table('transaction_types', function (Blueprint $table) {
            $table->foreign('createdby_office', 'foreign_key_office_created_by')
                ->references('id')->on('offices')
                ->restrictOnDelete()->restrictOnUpdate();
        });
    }

    public function down(): void
    {
        Schema::table('transaction_types', function (Blueprint $table) {
            $table->dropForeign('foreign_key_office_created_by');
        });
        Schema::table('transaction_types', function (Blueprint $table) {
            $table->string('createdby_office')->nullable()->change();
        });
    }
};
