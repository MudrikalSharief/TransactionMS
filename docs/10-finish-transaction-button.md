# Finish Transaction Button (future work)

> Handoff note: implement a FINISH TRANSACTION button for transactions on their final step.

## Rule

- IF a transaction is at its FINAL step (`current_step.is_end === true`), show a
  **FINISH TRANSACTION** button beside the **PROCEED** button.
- Applies to both detail views: `resources/js/pages/transactions/TransactionDetail.vue`
  (superadmin) and `resources/js/pages/my/MyTransactionDetail.vue` (regular users).
- Clicking it flags the transaction as finished. Only while unfinished, only for
  actors allowed to execute the current step.

## Data model

- Add one column to `transactions`, e.g. `finished_at` nullable timestamp
  (preferred over a plain boolean: `null` = open, set = finished + exactly when).
  - Migration: `database/migrations/20xx_xx_xx_xxxxxx_add_finished_at_to_transactions_table.php`
  - `$table->timestamp('finished_at')->nullable()`
  - Add to `Transaction::$fillable` + `datetime` cast.

## Backend

Mirror the existing execute flow (same guards, same response shape):

- Reference: `POST /transactions/{transaction}/execute`
  → `UserTransactionController@execute` (user side, `routes/api.php:67`) and the
  admin-side `.../transactions/{transaction}/execute`
  → `TransactionController@executeAction` (`routes/api.php:122`), both driven by
  `TransactionEngine` + `RoutingEngine::assertUserCanExecute()`
  (`app/Services/RoutingEngine.php:71`).
- New action, e.g. `POST /transactions/{transaction}/finish` (user) +
  admin-side equivalent, via `TransactionEngine::finish()`:
  - Guard: current step `is_end`, actor passes `RoutingEngine::assertUserCanExecute`,
    `finished_at` still null (repeat calls 422 / no-op).
  - Sets `finished_at = now()`, writes a step run (`action_code: 'finish'`) +
    audit log (`transactions.finish`).
- Expose in `TransactionResource`: `is_finished` (bool) + `finished_at` (ISO string).
- List endpoints stay light: both are plain row columns, no extra eager loads.

## Frontend

- Detail pages: the "PROCEED" control is the forward-action button rendered from
  `availableActions` (`res.meta?.available_actions`, forward vs return split —
  see `MyTransactionDetail.vue:765-766`, same pattern in `TransactionDetail.vue`).
  `v-if="tx.current_step?.is_end && !tx.is_finished"` → render the
  FINISH TRANSACTION button next to it, with confirm dialog, POST, refresh.
- Transaction tab (`TransactionList.vue` / `MyTransactionList.vue`): add a Finished
  status chip/column sourced from `is_finished`.
- Dashboard (`Dashboard.vue` on this branch): currently tracks NO finished state
  (stat cards were removed). Add finished tracking straight from `is_finished` /
  `finished_at` when the API exposes them (turnover = `finished_at - created_at`).

## Acceptance

- Button visible only on final step, only for authorized actors, only while unfinished.
- Double-click / repeat finish calls are safe.
- Dashboard + transaction tab agree on finished state.
