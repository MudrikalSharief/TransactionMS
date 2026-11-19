// Office working time, mirrored from config/working_time.php.
// Monday-Friday, 08:00-12:00 and 13:00-17:00 Asia/Manila (no DST).
// Client-side countdowns use this so the browser's own timezone does not
// change the answer.

export const WORKDAY_MINUTES = 480

const DAY_MS = 86400000
const MANILA_OFFSET_MS = 8 * 60 * 60 * 1000
const WINDOWS = [
    [8, 12],
    [13, 17],
]

/** Working milliseconds between two instants, Manila office hours. */
export function workingMs(from, to = Date.now()) {
    const startWall = new Date(from).getTime()
    const endWall = new Date(to).getTime()
    if (!Number.isFinite(startWall) || !Number.isFinite(endWall) || endWall <= startWall) return 0

    // Shift into Manila wall-clock time, then use UTC day boundaries.
    const start = startWall + MANILA_OFFSET_MS
    const end = endWall + MANILA_OFFSET_MS
    let dayStart = Math.floor(start / DAY_MS) * DAY_MS
    let ms = 0

    while (dayStart < end) {
        const day = new Date(dayStart).getUTCDay()
        if (day !== 0 && day !== 6) {
            for (const [openHour, closeHour] of WINDOWS) {
                const open = dayStart + openHour * 3600000
                const close = dayStart + closeHour * 3600000
                const segStart = Math.max(start, open)
                const segEnd = Math.min(end, close)
                if (segEnd > segStart) ms += segEnd - segStart
            }
        }
        dayStart += DAY_MS
    }

    return ms
}
