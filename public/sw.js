/* TRMF service worker: instant repeat loads on bad networks / weak devices.
 *
 * Strategy:
 * - /build/assets/* (Vite content-hashed: immutable) -> cache-first.
 *   Zero network on Ctrl+R; deploys are safe because new builds get new URLs
 *   and index HTML is ALWAYS fetched fresh (never cached here).
 * - Static images (/zamboanga-seal.png, /loginpage.jpg, /favicon.ico) and
 *   Google Fonts (CSS + woff2) -> cache-first, so the shell paints offline-fast.
 * - Everything else (navigations, /api/*, /sanctum/*) -> passthrough to the
 *   network. API freshness is owned by the app's localStorage SWR layer.
 *
 * Bump CACHE below when this file's logic changes, when a same-URL
 * asset changes, or when the build's chunk graph changes (old hashed URLs
 * never re-request, so a fresh cache keeps storage tidy).
 */
const CACHE = 'trmf-static-v3';
const FONT_CACHE = 'trmf-fonts-v1';

const STATIC_ASSETS = [
  '/zamboanga-seal.png',
  '/loginpage.jpg',
  '/favicon.ico',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches
      .open(CACHE)
      .then((cache) => cache.addAll(STATIC_ASSETS).catch(() => {}))
      .then(() => self.skipWaiting()),
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches
      .keys()
      .then((keys) =>
        Promise.all(
          keys
            .filter((k) => k !== CACHE && k !== FONT_CACHE)
            .map((k) => caches.delete(k)),
        ),
      )
      .then(() => self.clients.claim()),
  );
});

function cacheFirst(request, cacheName) {
  return caches.open(cacheName).then((cache) =>
    cache.match(request).then(
      (hit) =>
        hit ||
        fetch(request).then((res) => {
          // Only cache successful, non-opaque-ok responses.
          if (res && (res.status === 200 || res.type === 'opaque')) {
            cache.put(request, res.clone()).catch(() => {});
          }
          return res;
        }),
    ),
  );
}

self.addEventListener('fetch', (event) => {
  const { request } = event;
  if (request.method !== 'GET') return;

  let url;
  try {
    url = new URL(request.url);
  } catch {
    return;
  }

  // Cross-origin: only Google Fonts get the cache-first treatment.
  if (url.origin !== self.location.origin) {
    if (url.hostname === 'fonts.googleapis.com' || url.hostname === 'fonts.gstatic.com') {
      event.respondWith(cacheFirst(request, FONT_CACHE));
    }
    return;
  }

  // Same-origin hashed build output: immutable, safe to serve from cache.
  if (url.pathname.startsWith('/build/assets/')) {
    event.respondWith(cacheFirst(request, CACHE));
    return;
  }

  if (STATIC_ASSETS.includes(url.pathname)) {
    event.respondWith(cacheFirst(request, CACHE));
  }
  // NOTE: '/' , '/login', '/api/*' intentionally fall through to network.
});
