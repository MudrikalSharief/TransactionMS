const officeIcons = {
    OCA: "/images/offices/city-administrator.png",
    OCAC: "/images/offices/city-accountant.png",
    OCAG: "/images/offices/city-agriculturist.png",
    OCAS: "/images/offices/city-assessor.png",
    OCB: "/images/offices/city-budget.png",
    OCCR: "/images/offices/city-civil-registrar.png",
    OCDRDM: "/images/offices/city-disaster-risk-management.png",
    OCE: "/images/offices/city-engineer.png",
    OCH: "/images/offices/city-health.png",
    CHRMO: "/images/offices/city-human-resource-management.png",
    LEGAL: "/images/offices/city-legal.png",
    OCPD: "/images/offices/city-planning-and-development.jpg",
    OCT: "/images/offices/city-treasurer.png",
    OCV: "/images/offices/city-veterinarian.png",
    GDS: "/images/offices/cmo-gender-development-services.png",
    LEDIPS: "/images/offices/cmo-local-economic-development.png",
    CCZ: "/images/offices/colegio-de-la-ciudad-de-zamboanga.png",
    OCENR: "/images/offices/environment-and-natural-resources.png",
    GSO: "/images/offices/general-services.png",
    SP: "/images/offices/sangguniang-panlungsod.png",
    SSP: "/images/offices/secretary-to-sangguniang-panlungsod.png",
    OCSWD: "/images/offices/social-welfare-and-development.png",
};

export const anyOfficeIcon = "/images/offices/zamboanga-city-seal.png";

// Resolution is pure (code/icon_url -> URL) but runs for every table row on
// every render; memoizing keeps tab switches from redoing the lookup.
const resolved = new Map();

// URLs already handed to the browser's image cache in this tab session.
const warmed = new Set();

export function officeIcon(office) {
    const custom = String(office?.icon_url || "").trim();
    const code = String(office?.code || "").toUpperCase();
    const key = custom ? `u:${custom}` : `c:${code}`;

    if (resolved.has(key)) return resolved.get(key);

    const url = custom || officeIcons[code] || "";
    resolved.set(key, url);
    return url;
}

/**
 * Start loading the icons a list is about to paint, before Vue renders the
 * <img> tags. Combined with the service worker (public/sw.js), repeat tab
 * switches/reloads reuse the cached bitmap instead of re-downloading it.
 * Safe to call repeatedly: each URL is warmed at most once per session.
 */
export function warmOfficeIcons(offices) {
    const list = Array.isArray(offices) ? offices : offices ? [offices] : [];

    for (const office of list) {
        const url = officeIcon(office);
        if (!url || warmed.has(url)) continue;

        warmed.add(url);
        try {
            const img = new Image();
            img.decoding = "async";
            img.src = url;
            if (typeof img.decode === "function") img.decode().catch(() => {});
        } catch {
            // Image constructor unavailable (SSR/tests): the <img> still loads.
        }
    }
}
