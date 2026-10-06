<?php

namespace App\Console\Commands;

use App\Models\TransactionAttachment;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class OrganizeAttachmentsByDate extends Command
{
    protected $signature = 'attachments:organize-by-date
        {--execute : Actually move files and update stored_path. Without this flag only a dry-run report is shown.}';

    protected $description = 'Move existing transaction_attachments into attachments/YYYY/MM/{tx}/{step} folders (dated by created_at) and update stored_path.';

    public function handle(): int
    {
        $execute = (bool) $this->option('execute');

        $query = TransactionAttachment::orderBy('id');
        $total = (clone $query)->count();
        if ($total === 0) {
            $this->info('No attachments found.');
            return self::SUCCESS;
        }

        $toMove = 0;
        $already = 0;
        $missing = 0;
        $moved = 0;
        $rows = [];

        $query->chunk(200, function ($items) use ($execute, &$toMove, &$already, &$missing, &$moved, &$rows) {
            foreach ($items as $a) {
                $old = (string) $a->stored_path;
                $disk = $a->disk ?: 'local';

                if (preg_match('#^attachments/\d{4}/\d{2}/\d+/\d+/#', $old)) {
                    $already++;
                    continue;
                }

                $date = $a->created_at ?? $a->updated_at ?? now();
                $dir = 'attachments/'.$date->format('Y/m')."/{$a->transaction_id}/{$a->workflow_step_id}";
                $base = basename($old);
                if ($base === '' || $base === '.' || str_contains($base, '..')) {
                    $base = $a->id.'_file';
                }
                $new = $dir.'/'.$base;
                if (Storage::disk($disk)->exists($new)) {
                    $new = $dir.'/'.$a->id.'_'.$base;
                }

                if (!Storage::disk($disk)->exists($old)) {
                    $missing++;
                    $rows[] = [$a->id, $old, $new, 'missing source'];
                    continue;
                }

                $toMove++;
                $rows[] = [$a->id, $old, $new, $execute ? 'pending' : 'would move'];

                if ($execute) {
                    DB::transaction(function () use ($a, $disk, $old, $new) {
                        Storage::disk($disk)->move($old, $new);
                        $a->update(['stored_path' => $new]);
                    });
                    $moved++;
                    $rows[count($rows) - 1][3] = 'moved';
                }
            }
        });

        if (!empty($rows)) {
            $this->table(['ID', 'Old path', 'New path', 'Decision'], array_slice($rows, 0, 50));
            if (count($rows) > 50) {
                $this->info((count($rows) - 50).' more rows not shown.');
            }
        }

        $this->info("Total: {$total} | already organized: {$already} | missing source: {$missing} | ".
            ($execute ? "moved: {$moved}." : "to move: {$toMove}. Re-run with --execute to move."));

        return self::SUCCESS;
    }
}
