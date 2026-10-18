import { chromium } from 'playwright-core'

const EXE = 'C:/Program Files/Google/Chrome/Application/chrome.exe'
const BASE = 'http://127.0.0.1:8000'

const browser = await chromium.launch({ executablePath: EXE, headless: true })
const ctx = await browser.newContext()
const page = await ctx.newPage()

const errors = []
page.on('pageerror', (e) => errors.push('pageerror: ' + e.message))
page.on('console', (m) => { if (m.type() === 'error') errors.push('console: ' + m.text()) })
page.on('response', (r) => { if (r.url().includes('/api/')) console.log('API', r.status(), r.request().method(), r.url()) })

await page.goto(BASE + '/login', { waitUntil: 'commit', timeout: 60000 })
await page.waitForSelector('#login-email', { timeout: 180000 })
await page.fill('#login-email', 'navdebug@test.local')
await page.fill('#login-password', 'navdebug123')
await page.waitForTimeout(500)
await page.click('.login-btn')
await page.waitForTimeout(6000)

const state = await page.evaluate(() => ({
  url: location.href,
  loginError: document.querySelector('.login-error')?.textContent?.trim() || null,
  buttonDisabled: document.querySelector('.login-btn')?.classList?.contains('v-btn--disabled') ?? null,
  cached: (() => { try { return JSON.parse(localStorage.getItem('lgu-tx:cache:v5:authUser') || 'null') } catch { return 'parse-error' } })(),
}))
console.log(JSON.stringify(state, null, 2))
console.log('ERRORS:', JSON.stringify(errors.slice(0, 12), null, 2))
await browser.close()
