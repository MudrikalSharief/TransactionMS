// Shared helper: every filename click opens a preview in a new tab.
// Native types (pdf / images / text / video / audio) use the backend
// `view` endpoint (Content-Disposition: inline). Office docs that browsers
// can't render go through the Google Docs viewer as a fallback.
const OFFICE_EXTS = ['doc', 'docx', 'odt', 'rtf', 'xls', 'xlsx', 'ods', 'ppt', 'pptx', 'odp']

export function isOfficeDoc(a) {
    const mime = String(a?.mime || '').toLowerCase()
    if (
        mime.includes('officedocument') ||
        mime.includes('msword') ||
        mime.includes('ms-excel') ||
        mime.includes('ms-powerpoint') ||
        mime.includes('opendocument')
    ) return true
    const name = String(a?.original_name || '').toLowerCase()
    const ext = (name.split('.').pop() || '').split('?')[0]
    return OFFICE_EXTS.includes(ext)
}

export function fileViewUrl(a) {
    const direct = a?.view_url || a?.download_url
    if (!direct) return ''
    if (isOfficeDoc(a)) {
        return `https://docs.google.com/gview?embedded=1&url=${encodeURIComponent(direct)}`
    }
    return direct
}
