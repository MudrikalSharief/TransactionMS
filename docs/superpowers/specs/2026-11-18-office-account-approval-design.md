# Account approval by selected office

The user confirmed that the administrator of the office selected during public registration manages that account's approval/rejection, while superadmins retain oversight across all offices. They also requested automatic refresh of account requests on the dashboard and Office Users page.

Registration already persists office_id, creates an inactive pending account, and blocks sign-in until approval. Office endpoints already scope the user list and approve/reject operations to the administrator's office. Preserve these server permissions and verify the actual registration-to-approval-to-login flow, including denial of other offices' requests. No database change or approval of development accounts is required.

Account requests must refresh independently of transaction activity. Reuse the existing visible/online-aware polling lifecycle with an explicit unversioned mode, preserving its default transaction-version behavior. Refresh the dashboard's pending accounts and the Users list silently, preserving filters, pagination, edits and dialogs. Skip refresh during account mutations and reject stale in-flight responses after a newer fetch or successful mutation.

Use usernames to identify requests in the dashboard and confirmation text. Registration confirmation should tell applicants that their selected office's administrator reviews access. Admins manage their queue from Dashboard > Needs My Action or Office Users. Superadmins use their existing all-office Accounts view.

Verify new signup requests appear with an unchanged transaction version, office scoping, approval/rejection endpoints, successful login after approval, and preservation of table search state. Use mocked browser data and the SQLite :memory: test guard, retaining all earlier working-tree edits.
