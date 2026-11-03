// Export helpers for the Reports and Activity Log pages. A "section" is a
// titled table: { title, columns: [{ label, value: (row) => text }], rows }.
// Excel: a CSV file (UTF-8 with BOM so Excel keeps accents and ñ).
// PDF: a print-ready page in its own window (choose "Save as PDF").
// Everything happens in the browser; nothing is saved on the server.

const esc = (v) =>
    String(v ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c])

const csvCell = (v) => {
    const s = String(v ?? '')
    return /[",\r\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s
}

export function downloadCsv(filename, { title, subtitle, sections }) {
    const lines = [csvCell(title)]
    if (subtitle) lines.push(csvCell(subtitle))
    for (const sec of sections) {
        lines.push('', csvCell(sec.title))
        lines.push(sec.columns.map((c) => csvCell(c.label)).join(','))
        for (const row of sec.rows) lines.push(sec.columns.map((c) => csvCell(c.value(row))).join(','))
        if (!sec.rows.length) lines.push(csvCell('No data'))
    }
    const blob = new Blob(['﻿' + lines.join('\r\n')], { type: 'text/csv;charset=utf-8' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = filename
    document.body.appendChild(a)
    a.click()
    a.remove()
    setTimeout(() => URL.revokeObjectURL(url), 1000)
}

// Returns false when the browser blocked the print window.
export function printReport({ title, subtitle, sections, printedBy }) {
    const win = window.open('', '_blank', 'width=1000,height=900')
    if (!win) return false
    const origin = window.location.origin
    const printed = new Date().toLocaleString('en-PH', { timeZone: 'Asia/Manila', dateStyle: 'long', timeStyle: 'short' })
    const tables = sections
        .map(
            (sec) => `<h2>${esc(sec.title)}</h2>
<table><thead><tr>${sec.columns.map((c) => `<th>${esc(c.label)}</th>`).join('')}</tr></thead>
<tbody>${
                sec.rows.length
                    ? sec.rows.map((r) => `<tr>${sec.columns.map((c) => `<td>${esc(c.value(r))}</td>`).join('')}</tr>`).join('')
                    : `<tr><td colspan="${sec.columns.length}" class="none">No data</td></tr>`
            }</tbody></table>`,
        )
        .join('')

    win.document.write(`<!doctype html>
<html lang="en"><head><meta charset="utf-8"><title>${esc(title)}</title>
<style>
  @page { size: A4 landscape; margin: 12mm; }
  body { margin: 0; font-family: "Public Sans", system-ui, "Segoe UI", Roboto, sans-serif; color: #1d2433; font-size: 11px; }
  .head { display: flex; align-items: center; gap: 12px; border-bottom: 3px solid #002D70; padding-bottom: 8px; margin-bottom: 4px; }
  .head img { width: 44px; height: 44px; }
  .head small { display: block; color: #5b6475; letter-spacing: .06em; text-transform: uppercase; }
  .head b { font-size: 17px; color: #002D70; }
  .sub { color: #5b6475; margin: 6px 0 2px; }
  h2 { font-size: 13px; color: #002D70; margin: 16px 0 6px; }
  table { width: 100%; border-collapse: collapse; page-break-inside: auto; }
  tr { page-break-inside: avoid; }
  th { background: #1A1F2B; color: #fff; text-align: left; padding: 5px 6px; font-weight: 700; }
  td { border-bottom: 1px solid #d6e0f2; padding: 4px 6px; vertical-align: top; }
  .none { color: #5b6475; text-align: center; }
  .foot { margin-top: 14px; color: #5b6475; display: flex; justify-content: space-between; }
</style></head><body>
  <div class="head"><img src="${origin}/zamboanga-seal.png" alt="">
    <div><small>City Government of Zamboanga</small><b>${esc(title)}</b></div></div>
  ${subtitle ? `<div class="sub">${esc(subtitle)}</div>` : ''}
  ${tables}
  <div class="foot"><span>Printed ${esc(printed)}</span><span>${printedBy ? `by ${esc(printedBy)}` : ''}</span></div>
  <script>
    window.addEventListener('load', function () { window.focus(); window.print(); });
    window.addEventListener('afterprint', function () { window.close(); });
  <\/script>
</body></html>`)
    win.document.close()
    return true
}

// Working-time minutes as "2d 3h" / "45m" (a day = 24 h of a weekday).
export function fmtMinutes(min) {
    if (min == null) return '—'
    const m = Math.round(Number(min))
    if (m < 60) return `${m}m`
    if (m < 1440) {
        const h = Math.floor(m / 60)
        const r = m % 60
        return r ? `${h}h ${r}m` : `${h}h`
    }
    const d = Math.floor(m / 1440)
    const h = Math.round((m % 1440) / 60)
    return h ? `${d}d ${h}h` : `${d}d`
}
