import test from 'node:test';
import assert from 'node:assert/strict';
import { mergeAssignmentHistory } from '../../resources/js/utils/history.js';

test('assignment events interleave with receipts and routes without changing runs', () => {
    const runs = [
        { id: 2, received_at: '2026-11-17T04:00:00Z', action_code: 'forward', attachments: [{ id: 4 }] },
        { id: 1, received_at: '2026-11-17T01:00:00Z', action_code: 'create' },
    ];
    const history = [{ id: 2, step_run_id: 1, assigned_at: '2026-11-17T02:00:00Z', reason: 'Covering leave', from_officer: { name: 'Original Officer' }, to_officer: { name: 'New Officer' }, assigned_by: { name: 'Admin' } }];
    const before = JSON.stringify(runs);
    const rows = mergeAssignmentHistory(runs, history);
    assert.deepEqual(rows.map(row => row.history_key), ['run:2', 'assignment:2', 'run:1']);
    assert.equal(rows[1].event_type, 'assignment');
    assert.equal(rows[1].received_at, undefined);
    assert.equal(rows[1].attachments, undefined);
    assert.equal(rows[1].reason, 'Covering leave');
    assert.equal(JSON.stringify(runs), before);
});

test('history ordering is stable for simultaneous events and tolerates missing arrays', () => {
    assert.deepEqual(mergeAssignmentHistory(), []);
    const timestamp = '2026-11-17T02:00:00Z';
    const rows = mergeAssignmentHistory([{ id: 1, performed_at: timestamp }], [
        { id: 2, assigned_at: timestamp }, { id: 3, assigned_at: timestamp },
    ]);
    assert.deepEqual(rows.map(row => row.history_key), ['assignment:3', 'assignment:2', 'run:1']);
});
