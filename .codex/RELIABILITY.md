# Coding tools and verification

The user-level Codex setup includes GitHub and Superpowers plugins, plus curated
skills for Playwright, GitHub CI/review comments, security review, threat modeling,
and Graphify. Start a new Codex chat after installation to load them.

## Local Git hooks

Install with `pre-commit install --hook-type pre-commit --hook-type pre-push`.
Existing Graphify and cleanup hooks are preserved.

- Pre-commit checks staged files for conflict markers, private keys, oversized
  additions, JSON/YAML/TOML syntax, and PHP syntax. Checks do not autoformat files.
  Private-key detection is not a comprehensive secret scanner.
- Pre-push builds the frontend and runs the complete PHPUnit suite with SQLite
  in memory. Failures block the push and save details under `.git/codex-checks/`.
  These local checks do not configure remote branch protection or CI.

Run the full checks manually with `node .codex/hooks/verify.mjs full`.
Run commit checks with `pre-commit run --all-files --hook-stage pre-commit`.
The full repository may have historical violations; normal commits check staged files.

The baseline after building the frontend has 49 PHPUnit errors (many duplicate
`roles.code` fixtures) and 2 failures. These currently block the pre-push check.
Use the latest verification log for current counts. Application fixes are separate
from this tooling setup.

The project has ESLint dependencies but no ESLint config or lint script, so no
frontend lint check is claimed. There is no TypeScript check configured.

User-level Codex lifecycle hooks provide Git/Graphify context at session start
and report whitespace errors when a turn ends. They do not modify source or
automatically approve tools. Codex requires their exact definitions to be trusted.

## Removal

Run `pre-commit uninstall --hook-type pre-commit --hook-type pre-push` to remove
these two Git hooks. Remove the `reliability.mjs` handlers from
`~/.codex/hooks.json` to remove the Codex lifecycle hooks.
User configuration backups are in `~/.codex/backups/reliability-20261109/`.
