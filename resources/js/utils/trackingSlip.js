// Printable tracking slip: handed over with the paper, its QR code opens the
// transaction's tracking page. The slip is one self-contained HTML page:
// shown in the preview dialog (iframe) and printed from a hidden iframe on
// this page, so no pop-up window is needed. Nothing is saved or sent.
import QRCode from 'qrcode'

const esc = (v) =>
    String(v ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c])

const fmt = (iso) =>
    iso
        ? new Date(iso).toLocaleString('en-PH', {
              timeZone: 'Asia/Manila',
              month: 'long',
              day: 'numeric',
              year: 'numeric',
              hour: 'numeric',
              minute: '2-digit',
          })
        : '—'

export function trackingUrl(tx) {
    const ref = tx?.reference_number ? `?ref=${encodeURIComponent(tx.reference_number)}` : ''
    return `${window.location.origin}/track/${tx.id}${ref}`
}

// The slip page (A5). Images are absolute or data URLs so it renders the
// same inside an iframe's srcdoc.
export async function buildSlipHtml(tx, { printedBy } = {}) {
    const url = trackingUrl(tx)
    const qr = await QRCode.toDataURL(url, { errorCorrectionLevel: 'M', margin: 1, width: 360 })
    const origin = window.location.origin
    const office = tx.office?.name ? `${tx.office.name}${tx.office.code ? ` (${tx.office.code})` : ''}` : '—'
    const rows = [
        ['Title', tx.title || '—'],
        ['Transaction type', tx.transaction_type?.name || tx.transaction_type_name || '—'],
        ['Filed by', office],
        ['Date filed', fmt(tx.created_at)],
        ['Current step', tx.current_step?.name || tx.current_step?.code || '—'],
    ]

    return `<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<title>Tracking slip ${esc(tx.reference_number)}</title>
<style>
  @page { size: A5 portrait; margin: 12mm; }
  * { box-sizing: border-box; }
  html, body { margin: 0; background: #fff; }
  body { font-family: "Public Sans", system-ui, "Segoe UI", Roboto, sans-serif; color: #1d2433; padding: 16px; }
  @media print { body { padding: 0; } }
  .slip { border: 2px solid #002D70; max-width: 560px; margin: 0 auto; }
  .head { display: flex; align-items: center; gap: 12px; padding: 12px 16px; background: #002D70; color: #fff;
          -webkit-print-color-adjust: exact; print-color-adjust: exact; }
  .head img { width: 46px; height: 46px; border-radius: 50%; background: #fff; }
  .head small { display: block; opacity: .85; font-size: 11px; letter-spacing: .06em; text-transform: uppercase; }
  .head b { font-size: 17px; }
  .body { display: flex; gap: 16px; padding: 16px; }
  .info { flex: 1 1 auto; min-width: 0; }
  .ref-label { font-size: 11px; font-weight: 700; letter-spacing: .08em; text-transform: uppercase; color: #5b6475; }
  .ref { font-size: 24px; font-weight: 800; letter-spacing: .06em; margin: 2px 0 12px; font-variant-numeric: tabular-nums; }
  table { width: 100%; border-collapse: collapse; font-size: 13px; }
  th { text-align: left; color: #5b6475; font-weight: 600; padding: 4px 8px 4px 0; width: 38%; vertical-align: top; }
  td { padding: 4px 0; font-weight: 600; word-break: break-word; }
  .qr { flex: 0 0 150px; text-align: center; }
  .qr img { width: 150px; height: 150px; }
  .qr div { font-size: 11px; font-weight: 700; color: #002D70; }
  .url { padding: 0 16px 10px; font-size: 10.5px; color: #5b6475; word-break: break-all; }
  .foot { border-top: 2px solid #F2B33D; padding: 10px 16px; font-size: 11.5px; line-height: 1.45; }
  .meta { display: flex; justify-content: space-between; gap: 8px; padding: 0 16px 12px; font-size: 10.5px; color: #5b6475; }
</style></head>
<body>
  <div class="slip">
    <div class="head">
      <img src="${origin}/zamboanga-seal.png" alt="">
      <div><small>City Government of Zamboanga</small><b>Transaction Tracking Slip</b></div>
    </div>
    <div class="body">
      <div class="info">
        <div class="ref-label">Reference number</div>
        <div class="ref">${esc(tx.reference_number || `#${tx.id}`)}</div>
        <table>${rows.map(([k, v]) => `<tr><th>${esc(k)}</th><td>${esc(v)}</td></tr>`).join('')}</table>
      </div>
      <div class="qr"><img src="${qr}" alt="QR code to track this transaction"><div>Scan to track</div></div>
    </div>
    <div class="url">${esc(url)}</div>
    <div class="foot">
      Keep this slip. Scan the QR code or give the reference number to follow up on
      where your document is and what step it is on.
    </div>
    <div class="meta"><span>Printed ${esc(fmt(new Date().toISOString()))}</span><span>${printedBy ? `by ${esc(printedBy)}` : ''}</span></div>
  </div>
</body></html>`
}

// Prints an HTML page from a hidden iframe on this page (no pop-up), once
// its images have loaded. Resolves when the print dialog has been opened.
export function printHtml(html) {
    return new Promise((resolve, reject) => {
        const frame = document.createElement('iframe')
        frame.setAttribute('aria-hidden', 'true')
        frame.style.cssText = 'position:fixed;right:0;bottom:0;width:0;height:0;border:0;visibility:hidden'
        const cleanup = () => setTimeout(() => frame.remove(), 1000)
        frame.onload = async () => {
            try {
                const doc = frame.contentDocument
                // Wait for the seal and QR images (a broken image never blocks).
                await Promise.all(
                    [...doc.images]
                        .filter((img) => !img.complete)
                        .map(
                            (img) =>
                                new Promise((done) => {
                                    img.addEventListener('load', done, { once: true })
                                    img.addEventListener('error', done, { once: true })
                                }),
                        ),
                )
                const win = frame.contentWindow
                win.addEventListener('afterprint', cleanup, { once: true })
                win.focus()
                win.print()
                // Some browsers never fire afterprint; remove the frame later anyway.
                setTimeout(() => frame.isConnected && frame.remove(), 60000)
                resolve()
            } catch (e) {
                frame.remove()
                reject(e)
            }
        }
        frame.srcdoc = html
        document.body.appendChild(frame)
    })
}
