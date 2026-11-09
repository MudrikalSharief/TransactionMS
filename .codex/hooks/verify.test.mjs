import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import test from 'node:test';

const verifier = fileURLToPath(new URL('./verify.mjs', import.meta.url));

function verifyFixture(t, mode, buildExit, testExit) {
  const tempRoot = path.resolve(os.tmpdir());
  const root = mkdtempSync(path.join(tempRoot, 'tms-verification-'));
  t.after(() => {
    assert.ok(path.resolve(root).startsWith(`${tempRoot}${path.sep}`));
    rmSync(root, { recursive: true, force: true });
  });
  assert.equal(spawnSync('git', ['init', '-q'], { cwd: root, windowsHide: true }).status, 0);
  mkdirSync(path.join(root, 'node_modules/vite/bin'), { recursive: true });
  mkdirSync(path.join(root, 'vendor/bin'), { recursive: true });
  // Only the external build/test processes are fixtures. The real verifier runs
  // Git, selects its policy, captures logs, and sets the safe test environment.
  writeFileSync(path.join(root, 'node_modules/vite/bin/vite.js'), `process.exit(${buildExit});`);
  writeFileSync(path.join(root, 'vendor/autoload.php'), '<?php');
  writeFileSync(path.join(root, 'phpunit.xml'), '<phpunit/>');
  writeFileSync(path.join(root, 'vendor/bin/phpunit'), `<?php
    if (getenv('APP_ENV') !== 'testing' || getenv('DB_CONNECTION') !== 'sqlite' || getenv('DB_DATABASE') !== ':memory:') exit(99);
    echo "Suite fixture completed\\n";
    exit(${testExit});
  `);
  const result = spawnSync(process.execPath, [verifier, mode], {
    cwd: root, encoding: 'utf8', windowsHide: true, timeout: 30000,
  });
  assert.ifError(result.error);
  return { ...result, root };
}

test('push permits test failures while reporting them and preserving their log', t => {
  const result = verifyFixture(t, 'push', 0, 1);
  assert.equal(result.status, 0, result.stdout + result.stderr);
  assert.match(result.stdout, /phpunit: FAIL/);
  assert.match(result.stdout + result.stderr, /advisory/i);
  assert.match(readFileSync(path.join(result.root, '.git/codex-checks/phpunit.log'), 'utf8'), /Suite fixture completed/);
});

test('manual full verification still fails for a failing test suite', t => {
  const result = verifyFixture(t, 'full', 0, 1);
  assert.equal(result.status, 1);
  assert.match(result.stdout, /frontend-build: PASS/);
  assert.match(result.stdout, /phpunit: FAIL/);
});

test('push still blocks a failed frontend build', t => {
  const result = verifyFixture(t, 'push', 1, 0);
  assert.equal(result.status, 1);
  assert.match(result.stdout, /frontend-build: FAIL/);
});
