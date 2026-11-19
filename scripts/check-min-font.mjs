#!/usr/bin/env node
import { readdirSync, readFileSync, writeFileSync } from 'node:fs'
import { join, relative } from 'node:path'

// Design rule: no readable text may render below 12px.
const ROOT = process.cwd()
const TARGETS = ['resources/css', 'resources/js']
const PATTERN = /font-size\s*:\s*([0-9]*\.?[0-9]+)(px|rem)\b/gi
const MIN_PX = 12
const fix = process.argv.includes('--fix')

function walk(dir, out = []) {
    for (const entry of readdirSync(dir, { withFileTypes: true })) {
        const full = join(dir, entry.name)
        if (entry.isDirectory()) walk(full, out)
        else if (/\.(css|vue)$/i.test(entry.name)) out.push(full)
    }
    return out
}

const files = TARGETS.flatMap((dir) => walk(join(ROOT, dir)))
let offenders = 0

for (const file of files) {
    const before = readFileSync(file, 'utf8')
    let changed = false
    const after = before.replace(PATTERN, (match, rawValue, unit) => {
        const value = Number(rawValue)
        if (!Number.isFinite(value)) return match
        const px = unit.toLowerCase() === 'rem' ? value * 16 : value
        if (px >= MIN_PX) return match
        changed = true
        offenders += 1
        console.error(`  ${relative(ROOT, file)}: ${match}`)
        return 'font-size: var(--tms-text-xs)'
    })
    if (fix && changed) writeFileSync(file, after)
}

if (offenders === 0) {
    console.log(`OK: no font-size below ${MIN_PX}px.`)
} else if (fix) {
    console.log(`Replaced ${offenders} font-size value(s) below ${MIN_PX}px with var(--tms-text-xs).`)
} else {
    console.error(`Found ${offenders} font-size value(s) below ${MIN_PX}px.`)
    console.error('Run `npm run check:fonts -- --fix` to replace them, or fix manually.')
    process.exitCode = 1
}
