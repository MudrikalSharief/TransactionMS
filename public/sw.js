/* TRMF service worker: instant repeat loads on bad networks / weak devices.
 *
 * Strategy:
 * - /build/assets/* (Vite content-hashed: immutable) -> cache-first.
 *   Zero network on Ctrl+R; deploys are safe because new builds get new URLs
 *   and index HTML is ALWAYS fetched fresh (never cached here).
 * - Static images (/zamboanga-seal.png, /loginpage.jpg, /favicon.ico) and
 *   Google Fonts (CSS + woff2) -> cache-first, so the shell paints offline-fast.
 * - Office icons (/images/offices/*, /storage/offices/icons/*) ->
 *   stale-while-revalidate. These are what the transactions list paints on
 *   every tab switch/reload; serving the cached copy keeps the originating
 *   office row instant, and the background fetch picks up replaced artwork.
 *   Uploaded icons carry ?v=<mtime>, so their entries are effectively
 *   immutable and never need revalidating.
 * - Everything else (navigations, /api/*, /sanctum/*) -> passthrough to the
 *   network. API freshness is owned by the app's localStorage SWR layer.
 *
 * Bump CACHE below when this file's logic changes, when a same-URL
 * asset changes, or when the build's chunk graph changes (old hashed URLs
 * never re-request, so a fresh cache keeps storage tidy).
 */
const CACHE = 'trmf-static-v4';
const FONT_CACHE = 'trmf-fonts-v1';
const ICON_CACHE = 'trmf-office-icons-v1';

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
            .filter((k) => k !== CACHE && k !== FONT_CACHE && k !== ICON_CACHE)
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

// Paint from cache immediately, then refresh in the background. A failed
// refresh (offline) still returns the cached copy.
function staleWhileRevalidate(request, cacheName) {
  return caches.open(cacheName).then((cache) =>
    cache.match(request).then((hit) => {
      const network = fetch(request)
        .then((res) => {
          if (res && res.status === 200) {
            cache.put(request, res.clone()).catch(() => {});
          }
          return res;
        })
        .catch(() => hit);

      return hit || network;
    }),
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
    return;
  }

  // Originating-office icons: instant on tab switches/reloads, refreshed in
  // the background so replaced artwork still shows up.
  if (
    url.pathname.startsWith('/images/offices/') ||
    url.pathname.startsWith('/storage/offices/icons/')
  ) {
    event.respondWith(staleWhileRevalidate(request, ICON_CACHE));
  }
  // NOTE: '/' , '/login', '/api/*' intentionally fall through to network.
});
