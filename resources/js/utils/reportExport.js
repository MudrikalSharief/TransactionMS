// Export helpers for the Dashboard Reports and the Activity Log. A
// "section" is a titled table: { title, columns: [{ label, value: (row) => cell }], rows }.
// Both buttons build the file in the browser and download it straight away
// (no print window, no pop-up): Excel as a real .xlsx (one sheet per
// section), PDF as a real .pdf. Nothing is saved on the server.
// The Excel and PDF libraries are large, so they load only on first export.

const NAVY = [0, 45, 112]
const HEAD = [26, 31, 43]
const MUTED = [91, 100, 117]

const printedAt = () =>
    new Date().toLocaleString('en-PH', { timeZone: 'Asia/Manila', dateStyle: 'long', timeStyle: 'short' })

function saveBlob(blob, filename) {
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = filename
    document.body.appendChild(a)
    a.click()
    a.remove()
    setTimeout(() => URL.revokeObjectURL(url), 2000)
}

// Excel sheet names: at most 31 characters, none of : \ / ? * [ ], unique.
function sheetNames(sections) {
    const used = new Set()
    return sections.map((s, i) => {
        let name = String(s.title || `Sheet ${i + 1}`).replace(/[:\\/?*[\]]/g, ' ').trim().slice(0, 31) || `Sheet ${i + 1}`
        let n = 2
        while (used.has(name.toLowerCase())) name = `${name.slice(0, 28)} ${n++}`
        used.add(name.toLowerCase())
        return name
    })
}

const cellValue = (v) => (typeof v === 'number' && Number.isFinite(v) ? v : v == null ? '' : String(v))

// The PDF's built-in font only covers Western European characters: arrows
// become "->", anything else it can't draw becomes "?" instead of garbage.
const pdfText = (v) => {
    const s = cellValue(v)
    if (typeof s === 'number') return String(s)
    return s.replace(/[→⟶➔]/g, '->').replace(/[←⟵]/g, '<-').replace(/[^\x20-\x7E\xA0-\xFF–—‘’“”•…€]/g, '?')
}

export async function downloadXlsx(filename, { title, subtitle, sections }) {
    const { default: writeExcelFile } = await import('write-excel-file/browser')
    const names = sheetNames(sections)
    const sheets = sections.map((sec, i) => {
        const header = sec.columns.map((c) => ({ value: c.label, fontWeight: 'bold', backgroundColor: '#1A1F2B', color: '#FFFFFF' }))
        const body = sec.rows.length
            ? sec.rows.map((r) => sec.columns.map((c) => cellValue(c.value(r))))
            : [[{ value: 'No data', color: '#5B6475' }]]
        const widths = sec.columns.map((c, ci) => {
            const longest = Math.max(String(c.label).length, ...sec.rows.slice(0, 200).map((r) => String(cellValue(sec.columns[ci].value(r))).length))
            return { width: Math.min(48, Math.max(10, longest + 2)) }
        })
        return {
            sheet: names[i],
            columns: widths,
            stickyRowsCount: 4,
            data: [
                [{ value: `${title} — ${sec.title}`, fontWeight: 'bold', fontSize: 13, color: '#002D70' }],
                [{ value: subtitle || '', color: '#5B6475' }],
                [{ value: `Printed ${printedAt()}`, color: '#5B6475' }],
                header,
                ...body,
            ],
        }
    })
    const blob = await writeExcelFile(sheets, { fontFamily: 'Calibri', fontSize: 11 }).toBlob()
    saveBlob(blob, filename)
}

// The city seal for the PDF header; skipped quietly if it can't load.
async function sealDataUrl() {
    try {
        const blob = await (await fetch('/zamboanga-seal.png')).blob()
        return await new Promise((resolve, reject) => {
            const fr = new FileReader()
            fr.onload = () => resolve(fr.result)
            fr.onerror = reject
            fr.readAsDataURL(blob)
        })
    } catch {
        return null
    }
}

export async function downloadPdf(filename, { title, subtitle, sections, printedBy }) {
    const [{ jsPDF }, { autoTable }] = await Promise.all([import('jspdf'), import('jspdf-autotable')])
    const doc = new jsPDF({ orientation: 'landscape', unit: 'pt', format: 'a4' })
    const pageW = doc.internal.pageSize.getWidth()
    const pageH = doc.internal.pageSize.getHeight()
    const M = 36
    const seal = await sealDataUrl()

    // Header (first page): seal, city, report title, scope.
    if (seal) doc.addImage(seal, 'PNG', M, M - 6, 40, 40)
    const tx = seal ? M + 50 : M
    doc.setFont('helvetica', 'bold').setFontSize(9).setTextColor(...MUTED)
    doc.text('CITY GOVERNMENT OF ZAMBOANGA', tx, M + 6)
    doc.setFontSize(17).setTextColor(...NAVY)
    doc.text(pdfText(title), tx, M + 24)
    doc.setFont('helvetica', 'normal').setFontSize(9).setTextColor(...MUTED)
    if (subtitle) doc.text(doc.splitTextToSize(pdfText(subtitle), pageW - tx - M), tx, M + 38)
    doc.setDrawColor(...NAVY).setLineWidth(2).line(M, M + 48, pageW - M, M + 48)

    let y = M + 66
    for (const sec of sections) {
        if (y > pageH - 90) {
            doc.addPage()
            y = M + 10
        }
        doc.setFont('helvetica', 'bold').setFontSize(11).setTextColor(...NAVY)
        doc.text(pdfText(sec.title), M, y)
        autoTable(doc, {
            startY: y + 6,
            margin: { left: M, right: M, bottom: 40 },
            head: [sec.columns.map((c) => pdfText(c.label))],
            body: sec.rows.length
                ? sec.rows.map((r) => sec.columns.map((c) => pdfText(c.value(r))))
                : [[{ content: 'No data', colSpan: sec.columns.length, styles: { halign: 'center', textColor: MUTED } }]],
            styles: { font: 'helvetica', fontSize: 8, cellPadding: 4, overflow: 'linebreak', textColor: [29, 36, 51] },
            headStyles: { fillColor: HEAD, textColor: 255, fontStyle: 'bold' },
            alternateRowStyles: { fillColor: [244, 247, 252] },
            columnStyles: Object.fromEntries(sec.columns.map((c, i) => [i, c.num ? { halign: 'right' } : {}])),
        })
        y = doc.lastAutoTable.finalY + 24
    }

    // Footer on every page: printed date / by, page x of y.
    const pages = doc.getNumberOfPages()
    for (let p = 1; p <= pages; p++) {
        doc.setPage(p)
        doc.setFont('helvetica', 'normal').setFontSize(8).setTextColor(...MUTED)
        doc.text(pdfText(`Printed ${printedAt()}${printedBy ? ` by ${printedBy}` : ''}`), M, pageH - 18)
        doc.text(`Page ${p} of ${pages}`, pageW - M, pageH - 18, { align: 'right' })
    }
    doc.save(filename)
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
