import test from 'node:test';
import assert from 'node:assert/strict';
import { latestReceivedRunsByStep } from '../../resources/js/utils/receivingOfficers.js';

test('unlocks the received destination, never the departure step', () => {
    assert.deepEqual([...latestReceivedRunsByStep([
        { from_step: { id: 1 }, to_step: { id: 2 }, received_at: '2026-11-17T01:00:00Z', received_by: { id: 8 } },
    ]).keys()], ['2']);
});

test('pending, missing receiver and missing destination stay locked', () => {
    assert.equal(latestReceivedRunsByStep([
        { to_step: { id: 1 }, received_at: null, received_by: { id: 8 } },
        { to_step: { id: 2 }, received_at: '2026-11-17', received_by: null },
        { received_at: '2026-11-17', received_by: { id: 8 } },
    ]).size, 0);
});

test('keeps a completed receipt available during a pending repeat visit', () => {
    assert.deepEqual([...latestReceivedRunsByStep([
        { to_step: { id: 2 }, received_at: '2026-11-17', received_by: { id: 8 } },
        { to_step: { id: 2 }, received_at: null, received_by: null },
    ]).keys()], ['2']);
});

test('pairs the officer and receive time from the latest completed receipt per destination', () => {
    const runs = latestReceivedRunsByStep([
        { id: 4, to_step: { id: 2 }, received_at: '2026-11-17T02:00:00Z', received_by: { name: 'Latest officer' } },
        { id: 5, to_step: { id: 2 }, received_at: '2026-11-17T01:00:00Z', received_by: { name: 'Earlier officer' } },
        { id: 6, to_step: { id: 2 }, received_at: null, received_by: null },
        { id: 7, to_step: { id: 3 }, received_at: '2026-11-17T03:00:00Z', received_by: { name: 'Other officer' } },
    ]);
    assert.equal(runs.get('2').received_by.name, 'Latest officer');
    assert.equal(runs.get('2').received_at, '2026-11-17T02:00:00Z');
    assert.equal(runs.get('3').received_by.name, 'Other officer');
});

test('uses the higher receipt ID when receive times match, regardless of input order', () => {
    const runs = latestReceivedRunsByStep([
        { id: 9, to_step: { id: 2 }, received_at: '2026-11-17T02:00:00Z', received_by: { name: 'Latest officer' } },
        { id: 8, to_step: { id: 2 }, received_at: '2026-11-17T02:00:00Z', received_by: { name: 'Earlier officer' } },
    ]);
    assert.equal(runs.get('2').received_by.name, 'Latest officer');
});
