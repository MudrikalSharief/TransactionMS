import { computed, ref, watch } from 'vue'

// Dashboard card order, remembered per user in this browser.
// Reads/writes are guarded so private-mode or quota errors never break the
// page: the order then just lasts until the next reload.

const PREFIX = 'lgu-tx:dashboard-order:v2:'

function readOrder(key) {
    try {
        const parsed = JSON.parse(localStorage.getItem(key))
        return Array.isArray(parsed) ? parsed.filter((id) => typeof id === 'string') : []
    } catch {
        return []
    }
}

// `userId` and `cards` are refs; `cards` lists the card ids this user can
// see, in their default order.
export function useDashboardLayout(userId, cards) {
    const key = computed(() => PREFIX + (userId.value ?? 'guest'))
    const saved = ref([])
    watch(key, (k) => (saved.value = readOrder(k)), { immediate: true })

    // Saved order first. Cards it doesn't mention (new, or newly visible
    // to this user) follow in their default order; unknown ids are dropped.
    const order = computed(() => {
        const known = [...new Set(saved.value)].filter((id) => cards.value.includes(id))
        return [...known, ...cards.value.filter((id) => !known.includes(id))]
    })

    const changed = computed(() => order.value.join() !== cards.value.join())

    function save(list) {
        saved.value = list
        try {
            localStorage.setItem(key.value, JSON.stringify(list))
        } catch { /* quota / private mode: order still applies until reload */ }
    }

    // Put `id` into the slot `targetId` holds now; the cards between shift over.
    function move(id, targetId) {
        const list = [...order.value]
        const from = list.indexOf(id)
        const to = list.indexOf(targetId)
        if (from < 0 || to < 0 || from === to) return
        list.splice(from, 1)
        list.splice(to, 0, id)
        save(list)
    }

    // Move `id` one slot earlier (-1) or later (+1).
    function shift(id, delta) {
        const target = order.value[order.value.indexOf(id) + delta]
        if (target) move(id, target)
    }

    function reset() {
        saved.value = []
        try {
            localStorage.removeItem(key.value)
        } catch { /* ignore */ }
    }

    return { order, changed, move, shift, reset }
}
