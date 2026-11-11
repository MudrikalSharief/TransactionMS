import { onMounted, onUnmounted, reactive, ref } from 'vue'

// Dashboards fill the screen without a page scroll on desktop-sized windows
// (same breakpoint as the "fit the screen" block in resources/css/app.css);
// smaller windows stack the cards and scroll as usual.
const FIT_QUERY = '(min-width: 1100px) and (min-height: 560px)'

// `v-fit-body="'name'"` measures a card body; rows('name', rowHeight, fallback)
// then says how many whole rows fit, so a list is never cut through a row.
export function useFitScreen() {
    const mq = window.matchMedia(FIT_QUERY)
    const fit = ref(mq.matches)
    const sizes = reactive({})

    const observer = typeof ResizeObserver === 'undefined'
        ? null
        : new ResizeObserver((entries) => {
            for (const { target, contentRect } of entries) {
                sizes[target.dataset.fitBody] = { w: contentRect.width, h: contentRect.height }
            }
        })

    const vFitBody = {
        mounted(el, { value }) {
            el.dataset.fitBody = value
            observer?.observe(el)
        },
        beforeUnmount(el) {
            observer?.unobserve(el)
        },
    }

    function rows(name, rowHeight, fallback, reserved = 0) {
        const h = sizes[name]?.h
        if (!fit.value || !h) return fallback
        return Math.max(1, Math.floor((h - reserved) / rowHeight))
    }

    const onChange = () => { fit.value = mq.matches }
    onMounted(() => mq.addEventListener('change', onChange))
    onUnmounted(() => {
        mq.removeEventListener('change', onChange)
        observer?.disconnect()
    })

    return { fit, sizes, vFitBody, rows }
}
