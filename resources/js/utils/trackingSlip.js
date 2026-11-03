// Printable tracking slip: handed over with the paper, its QR code opens the
// transaction's tracking page. Built in a separate print window so the app
// layout never prints; nothing is saved or sent anywhere.
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

// Opens the slip and the print dialog. Returns false when the browser
// blocked the window (the caller can tell the user to allow pop-ups).
export async function printTrackingSlip(tx, { printedBy } = {}) {
    const win = window.open('', '_blank', 'width=760,height=960')
    if (!win) return false

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

    win.document.write(`<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<title>Tracking slip ${esc(tx.reference_number)}</title>
<style>
  @page { size: A5 portrait; margin: 12mm; }
  * { box-sizing: border-box; }
  body { margin: 0; font-family: "Public Sans", system-ui, "Segoe UI", Roboto, sans-serif; color: #1d2433; }
  .slip { border: 2px solid #002D70; max-width: 560px; margin: 0 auto; }
  .head { display: flex; align-items: center; gap: 12px; padding: 12px 16px; background: #002D70; color: #fff; }
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
  <script>
    window.addEventListener('load', function () { window.focus(); window.print(); });
    window.addEventListener('afterprint', function () { window.close(); });
  <\/script>
</body></html>`)
    win.document.close()
    return true
}
