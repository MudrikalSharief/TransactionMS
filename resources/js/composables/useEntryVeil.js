import { onBeforeUnmount, ref } from 'vue'

// How long the entry veil stays when the page already painted cached rows.
// Long enough to read as a deliberate "loading" beat, short enough that the
// page never feels stuck behind the network.
export const ENTRY_VEIL_WARM_MS = 300

// Entry loader shown on every visit to a page (kept by design), sized to what
// the page actually needs:
//   - cold (nothing cached): stays until the first fetch settles;
//   - warm (cached rows already painted): drops after ENTRY_VEIL_WARM_MS while
//     the fetch keeps refreshing the rows silently in the background.
// Previously the veil always waited for the network, even on warm visits.
export function useEntryVeil() {
    const entering = ref(true)
    let timer = null

    function done() {
        entering.value = false
        if (timer) {
            clearTimeout(timer)
            timer = null
        }
    }

    // `task` is the page's first fetch (a promise); `warm` is whether cached
    // data was painted synchronously when that fetch started.
    function settle(task, { warm = false } = {}) {
        Promise.resolve(task).catch(() => {}).finally(done)
        if (warm && entering.value) timer = setTimeout(done, ENTRY_VEIL_WARM_MS)
    }

    onBeforeUnmount(() => {
        if (timer) clearTimeout(timer)
    })

    return { entering, settle }
}
