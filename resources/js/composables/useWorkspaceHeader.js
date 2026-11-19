import { computed, ref } from 'vue'

// The shell header outlives page components, so the last data refresh is
// kept outside them. Navigating between sidebar destinations must not reset
// the timestamp; only a real page refresh (Dashboard/PortalHome) moves it.
const STORAGE_KEY = 'workspace:refreshed-at'

function initialRefreshedAt() {
    if (typeof window === 'undefined') return new Date()
    try {
        const stored = Number(window.sessionStorage.getItem(STORAGE_KEY))
        if (Number.isFinite(stored) && stored > 0) return new Date(stored)
    } catch { /* ignore */ }
    return new Date()
}

const refreshedAt = ref(initialRefreshedAt())

export function markWorkspaceRefreshed(at = new Date()) {
    const when = at instanceof Date ? at : new Date(at)
    if (Number.isNaN(when.getTime())) return
    refreshedAt.value = when
    try {
        window.sessionStorage.setItem(STORAGE_KEY, String(when.getTime()))
    } catch { /* ignore */ }
}

const now = ref(new Date())
if (typeof window !== 'undefined') {
    window.setInterval(() => {
        now.value = new Date()
    }, 60 * 1000)
}

export function useWorkspaceHeader() {
    const greeting = computed(() => {
        const hour = Number(new Intl.DateTimeFormat('en-GB', {
            timeZone: 'Asia/Manila',
            hour: 'numeric',
            hourCycle: 'h23',
        }).format(now.value))
        return hour < 12 ? 'Good morning' : hour < 18 ? 'Good afternoon' : 'Good evening'
    })

    const refreshedLabel = computed(() => refreshedAt.value
        ? refreshedAt.value.toLocaleString('en-PH', {
            timeZone: 'Asia/Manila',
            month: 'short',
            day: 'numeric',
            year: 'numeric',
            hour: 'numeric',
            minute: '2-digit',
        }) + ' PHT'
        : '')

    return { greeting, refreshedLabel }
}
