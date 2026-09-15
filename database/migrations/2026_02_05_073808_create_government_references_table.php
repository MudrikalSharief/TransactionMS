<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('government_references', function (Blueprint $table) {
            $table->id();
            $table->string('code'); // e.g. RA-9184, IRR-9184, COA-XXXX
            $table->string('title');
            $table->string('source')->nullable(); // RA, IRR, COA, DBM, CSC, etc
            $table->string('url')->nullable();
            $table->text('notes')->nullable();
            $table->boolean('is_verified')->default(false); // “TO VERIFY”
            $table->timestamps();
            $table->softDeletes();

            $table->index(['code', 'source']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('government_references');
    }
};
