<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        // Both tables are dead (audited 2026-09-16, see dead_tables_audit.csv):
        // - requirement_checks was superseded by transaction_requirement_checks
        // - requirement_definition_workflow_step was superseded by step_requirements
        // Both were verified empty with zero code references before dropping.
        Schema::dropIfExists('requirement_checks');
        Schema::dropIfExists('requirement_definition_workflow_step');
    }

    public function down(): void
    {
        // Not restorable (dead schema); recreating is intentionally unsupported.
    }
};
