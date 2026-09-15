# 4. User Flow

## Login (`pages/Login.vue`)
Centered card on pastel gradient, seal `/zamboanga-seal.png`, email + password (eye toggle, `variant=solo`), error from `message|errors.email[0]`. Success -> `push {name:'dashboard'}`.

## Dashboard (`pages/Dashboard.vue`)
- Greeting by Manila hour + `{stats.mine} in my queue` chip
- 3 stat cards: Transaction Types, Transactions (superadmin: all, else = mine), My Transactions
- 2 donut charts (`DonutChart.vue`): by type, by step
- Recent Activity (4 newest, click -> `/transactions/:id` if superadmin else `/my/transactions/:id`)
- Data via `useCache` (`transactionTypes/myTransactions/transactions`)

## Lists
- `my/MyTransactionList.vue` (all roles): role-filtered queue, Refresh, empty text `No transactions assigned to your role...`, click -> `/my/transactions/:id`
- `transactions/TransactionList.vue` (superadmin UI): all queue, `reference_number, title, type, workflow v+status, current_step`, search, 25/page, New Transaction

Table columns and search are the primary triage UX; global top-bar autocomplete searches pages + up to 7 recent tx.

## Detail (`MyTransactionDetail.vue` / `TransactionDetail.vue`, ~470-600 lines)
Header: `reference_number — title`, `type | workflow v+status`, `current_step name(code)`.
Sections:
1. Checklist table `current_step_requirements` with required-missing warning — gates actions
2. Step fields form (per-step required/optional)
3. Available actions (routes from current step passing role + JsonLogic): buttons `Submit/Approve/Return` with remarks
4. History timeline from `transaction_step_runs`

Back returns to originating list.
