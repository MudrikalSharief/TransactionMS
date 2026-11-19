import { onScopeDispose, watch } from 'vue';

// Keep workspace popups within the viewport when the connected strategy
// applies offsets twice to headers or dialogs.
export function workspaceMenuLocation(data, props, contentStyles) {
    let frame = null;
    const updateLocation = () => {
        const target = data.target.value;
        const content = data.contentEl.value;
        if (!target?.getBoundingClientRect || !content) return;
        const anchor = target.getBoundingClientRect();
        const box = content.getBoundingClientRect();
        const margin = 12;
        const offset = Number(props.offset) || 10;
        const minWidth = Math.min(anchor.width, window.innerWidth - margin * 2);
        const width = Math.max(box.width, minWidth);
        const left = Math.max(margin, Math.min(anchor.right - width, window.innerWidth - width - margin));
        const top = Math.max(margin, Math.min(anchor.bottom + offset, window.innerHeight - box.height - margin));
        Object.assign(contentStyles.value, {
            position: 'fixed', left: `${left}px`, top: `${top}px`,
            minWidth: `${minWidth}px`,
            maxWidth: `${window.innerWidth - margin * 2}px`,
            maxHeight: `${window.innerHeight - margin * 2}px`,
            transformOrigin: 'right top',
        });
    };
    const observer = new ResizeObserver(updateLocation);
    watch([data.target, data.contentEl], ([target, content], previous) => {
        previous?.filter(value => value instanceof Element).forEach(value => observer.unobserve(value));
        [target, content].filter(value => value instanceof Element).forEach(value => observer.observe(value));
        if (frame) cancelAnimationFrame(frame);
        frame = requestAnimationFrame(updateLocation);
    }, { immediate: true, flush: 'post' });
    onScopeDispose(() => {
        observer.disconnect();
        if (frame) cancelAnimationFrame(frame);
    });
    return { updateLocation };
}
