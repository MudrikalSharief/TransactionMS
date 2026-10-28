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

export function officeIcon(office) {
    const custom = String(office?.icon_url || "").trim();
    if (custom) return custom;
    return officeIcons[String(office?.code || "").toUpperCase()] || "";
}
