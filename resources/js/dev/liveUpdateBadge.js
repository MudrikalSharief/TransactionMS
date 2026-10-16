// Dev only (npm run dev): a small corner badge that says when Vite is
// applying a code change and when it is done, so live updates are visible
// at a glance. Never shipped in a build (app.js only loads it under HMR).

const RELOAD_FLAG = 'lgu-tx:dev-reloading'

export function installLiveUpdateBadge(hot) {
    const el = document.createElement('div')
    el.setAttribute('role', 'status')
    el.setAttribute('aria-live', 'polite')
    Object.assign(el.style, {
        position: 'fixed',
        left: '12px',
        bottom: '12px',
        zIndex: '99999',
        padding: '6px 12px',
        borderRadius: '6px',
        color: '#fff',
        font: '600 12px/1.4 system-ui, sans-serif',
        boxShadow: '0 4px 14px rgba(0, 0, 0, 0.25)',
        pointerEvents: 'none',
        opacity: '0',
        transform: 'translateY(8px)',
        transition: 'opacity 0.2s, transform 0.2s',
    })
    document.body.appendChild(el)

    let hideTimer = null
    function show(text, background, { stay = false } = {}) {
        clearTimeout(hideTimer)
        el.textContent = text
        el.style.background = background
        el.style.opacity = '1'
        el.style.transform = 'none'
        if (!stay) {
            hideTimer = setTimeout(() => {
                el.style.opacity = '0'
                el.style.transform = 'translateY(8px)'
            }, 2500)
        }
    }

    const time = () => new Date().toLocaleTimeString()
    const BUSY = '#1e293b'
    const DONE = '#166534'
    const FAIL = '#991b1b'

    // A backend change reloads the whole page; say so once it is back.
    let reloaded = false
    try {
        reloaded = sessionStorage.getItem(RELOAD_FLAG) === '1'
        sessionStorage.removeItem(RELOAD_FLAG)
    } catch { /* private mode: just skip the message */ }
    show(reloaded ? `Updated ${time()} (page reloaded)` : 'Live updates on', reloaded ? DONE : BUSY)

    hot.on('vite:beforeUpdate', () => show('Updating…', BUSY, { stay: true }))
    hot.on('vite:afterUpdate', () => show(`Updated ${time()}`, DONE))
    hot.on('vite:beforeFullReload', () => {
        try {
            sessionStorage.setItem(RELOAD_FLAG, '1')
        } catch { /* ignore */ }
        show('Reloading…', BUSY, { stay: true })
    })
    hot.on('vite:error', () => show('Update failed: see the terminal running npm run dev', FAIL, { stay: true }))
    hot.on('vite:ws:disconnect', () => show('Dev server stopped: the page will not update', FAIL, { stay: true }))
}
