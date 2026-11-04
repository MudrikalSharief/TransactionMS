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

// The QR opens /scan/:id, which the router sends to the read-only tracking
// page (signing in as the guest viewer when needed).
export function trackingUrl(tx) {
    const ref = tx?.reference_number ? `?ref=${encodeURIComponent(tx.reference_number)}` : ''
    return `${window.location.origin}/scan/${tx.id}${ref}`
}

// Small icons for the footer contacts (Material Design Icons paths).
const ICON = {
    mail: 'M22 6C22 4.9 21.1 4 20 4H4C2.9 4 2 4.9 2 6V18C2 19.1 2.9 20 4 20H20C21.1 20 22 19.1 22 18V6M20 6L12 11L4 6H20M20 18H4V8L12 13L20 8V18Z',
    pin: 'M12,11.5A2.5,2.5 0 0,1 9.5,9A2.5,2.5 0 0,1 12,6.5A2.5,2.5 0 0,1 14.5,9A2.5,2.5 0 0,1 12,11.5M12,2A7,7 0 0,0 5,9C5,14.25 12,22 12,22C12,22 19,14.25 19,9A7,7 0 0,0 12,2Z',
    phone: 'M6.62,10.79C8.06,13.62 10.38,15.94 13.21,17.38L15.41,15.18C15.69,14.9 16.08,14.82 16.43,14.93C17.55,15.3 18.75,15.5 20,15.5A1,1 0 0,1 21,16.5V20A1,1 0 0,1 20,21A17,17 0 0,1 3,4A1,1 0 0,1 4,3H7.5A1,1 0 0,1 8.5,4C8.5,5.25 8.7,6.45 9.07,7.57C9.18,7.92 9.1,8.31 8.82,8.59L6.62,10.79Z',
}
const icon = (d) => `<svg viewBox="0 0 24 24" aria-hidden="true"><path d="${d}"/></svg>`

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
  .slip { border: 2px solid #002D70; max-width: 560px; margin: 0 auto; overflow: hidden;
          -webkit-print-color-adjust: exact; print-color-adjust: exact; }
  /* Header: the city seal and the system logo mirror each other (same
     white disc with a gold ring) around a centred title; navy from the
     logo, gold from the seal. */
  .head { display: grid; grid-template-columns: 56px 1fr 56px; align-items: center; gap: 12px; padding: 14px 16px;
          background: linear-gradient(180deg, #0a3f94 0%, #002D70 55%, #002056 100%); color: #fff; text-align: center;
          border-bottom: 3px solid #F2B33D; box-shadow: inset 0 3px 0 rgba(242, 179, 61, .55); }
  .head .mark { width: 54px; height: 54px; border-radius: 50%; background: #fff; object-fit: contain; padding: 2px;
                box-shadow: 0 0 0 2px #F2B33D, 0 0 10px rgba(242, 179, 61, .45); }
  .head .title { min-width: 0; }
  .head small { display: block; color: #F8D98A; font-size: 10.5px; font-weight: 700; letter-spacing: .14em; text-transform: uppercase; }
  .head b { display: block; font-size: 19px; letter-spacing: .02em; margin: 2px 0 3px; }
  .head .sys { display: inline-block; font-size: 9.5px; letter-spacing: .12em; text-transform: uppercase; color: rgba(255, 255, 255, .78);
               border-top: 1px solid rgba(248, 217, 138, .55); padding-top: 3px; }
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
  .url { padding: 0 16px 8px; font-size: 10.5px; color: #5b6475; word-break: break-all; }
  .note { padding: 0 16px 6px; font-size: 11.5px; line-height: 1.45; }
  .meta { display: flex; justify-content: space-between; gap: 8px; padding: 0 16px 4px; font-size: 10.5px; color: #5b6475; }
  /* Footer: same design as the site footer (City Hall over a navy band
     with gold and blue swooshes, contacts and the CSD credit). */
  .tf-sky { position: relative; height: 84px; }
  .tf-sky svg { position: absolute; left: 0; right: 0; bottom: -1px; width: 100%; height: 44px; }
  .tf-sky img { position: absolute; left: 50%; bottom: 0; transform: translateX(-50%); width: 270px; height: auto;
                -webkit-mask-image: linear-gradient(to right, transparent 0, #000 14%, #000 86%, transparent 100%);
                mask-image: linear-gradient(to right, transparent 0, #000 14%, #000 86%, transparent 100%); }
  .tf-band { background: linear-gradient(180deg, #002D70 0%, #002056 100%); color: #fff; text-align: center; padding: 8px 14px 12px; }
  .tf-contacts { display: flex; flex-wrap: wrap; justify-content: center; gap: 4px 14px; font-size: 10.5px; }
  .tf-contacts span { display: inline-flex; align-items: center; gap: 4px; }
  .tf-contacts svg { width: 11px; height: 11px; fill: #fff; }
  .tf-rule { width: 60%; height: 1px; margin: 7px auto 6px; background: linear-gradient(90deg, transparent, rgba(147, 197, 253, .8), transparent); }
  .tf-credit { font-size: 10.5px; color: rgba(255, 255, 255, .9); }
  .tf-credit b { color: #fff; font-weight: 800; }
</style></head>
<body>
  <div class="slip">
    <div class="head">
      <img class="mark" src="${origin}/zamboanga-seal.png" alt="City of Zamboanga official seal">
      <div class="title">
        <small>City Government of Zamboanga</small>
        <b>Transaction Tracking Slip</b>
        <span class="sys">TransactionMS · Document Tracking</span>
      </div>
      <img class="mark" src="${origin}/tms-logo-128.png" alt="TransactionMS logo">
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
    <div class="note">
      Keep this slip. Scan the QR code to see where your document is and what step it is on
      (view only), or give the reference number when you follow up.
    </div>
    <div class="meta"><span>Printed ${esc(fmt(new Date().toISOString()))}</span><span>${printedBy ? `by ${esc(printedBy)}` : ''}</span></div>
    <div class="tf-sky" aria-hidden="true">
      <svg viewBox="0 0 1600 120" preserveAspectRatio="none">
        <defs>
          <linearGradient id="sg" x1="0" x2="1" y1="0" y2="0">
            <stop offset="0" stop-color="#F2B33D"/><stop offset=".32" stop-color="#F2B33D" stop-opacity="0"/>
            <stop offset=".68" stop-color="#F2B33D" stop-opacity="0"/><stop offset="1" stop-color="#F2B33D"/>
          </linearGradient>
          <linearGradient id="sb" x1="0" x2="1" y1="0" y2="0">
            <stop offset="0" stop-color="#2563EB"/><stop offset=".32" stop-color="#2563EB" stop-opacity="0"/>
            <stop offset=".68" stop-color="#2563EB" stop-opacity="0"/><stop offset="1" stop-color="#2563EB"/>
          </linearGradient>
        </defs>
        <path d="M0 10 C520 78 1080 78 1600 10" fill="none" stroke="url(#sg)" stroke-width="2" vector-effect="non-scaling-stroke"/>
        <path d="M0 20 C520 88 1080 88 1600 20" fill="none" stroke="url(#sb)" stroke-width="6" vector-effect="non-scaling-stroke"/>
        <path d="M0 30 C520 98 1080 98 1600 30 L1600 120 L0 120 Z" fill="#002D70"/>
      </svg>
      <img src="${origin}/footer-hall.webp" alt="">
    </div>
    <div class="tf-band">
      <div class="tf-contacts">
        <span>${icon(ICON.mail)}info@zamboangacity.gov.ph</span>
        <span>${icon(ICON.pin)}City Hall, Zamboanga City, Philippines</span>
        <span>${icon(ICON.phone)}(062) 991-3371</span>
      </div>
      <div class="tf-rule"></div>
      <div class="tf-credit">Developed by <b>City Hall Computer Service Division</b> - Mayor's Office</div>
    </div>
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
