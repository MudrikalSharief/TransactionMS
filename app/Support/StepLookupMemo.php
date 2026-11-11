<?php

namespace App\Support;

use Closure;

/**
 * Request-scoped memo for step-level, read-only lookups that
 * TransactionResource repeats for every row of a list (a step's fields,
 * requirements, checklist rows, step-data definitions, predecessors).
 * Many rows sit on the same step, so a list of N rows used to run the same
 * queries N times.
 *
 * Off by default: only read-only list endpoints switch it on (enable()), so
 * any request that writes workflow config and then renders a transaction
 * keeps reading fresh rows. Registered as `scoped`, so it never outlives the
 * request.
 */
class StepLookupMemo
{
    private bool $enabled = false;

    /** @var array<string, mixed> */
    private array $values = [];

    public function enable(): void
    {
        $this->enabled = true;
    }

    public function remember(string $key, Closure $resolve): mixed
    {
        if (!$this->enabled) {
            return $resolve();
        }

        if (!array_key_exists($key, $this->values)) {
            $this->values[$key] = $resolve();
        }

        return $this->values[$key];
    }
}
