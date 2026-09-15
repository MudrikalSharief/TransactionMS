<template>
    <v-app>
        <v-app-bar
            v-if="showAuthUi"
            color="white"
            elevation="0"
            style="border-bottom: 2px solid #7C3AED"
        >
            <v-app-bar-nav-icon
                icon="mdi-menu"
                v-tooltip="'Menu'"
                color="primary"
                @click="toggleNav"
            />
            <div
                class="d-flex align-center flex-shrink-0 mr-4 ml-3"
                style="flex: 0 0 auto; min-width: max-content"
            >
                <v-img
                    src="/zamboanga-seal.png"
                    alt="Zamboanga Seal"
                    width="32"
                    height="32"
                    class="mr-2"
                    style="flex: 0 0 auto"
                />
                <div
                    class="d-flex flex-column justify-center"
                    style="white-space: nowrap; line-height: 1"
                >
                    <div
                        class="font-weight-bold text-primary"
                        style="font-size: 1.25rem; line-height: 1"
                    >
                        TransactionMS
                    </div>
                    <div
                        class="font-weight-bold text-medium-emphasis"
                        style="font-size: 0.62rem; letter-spacing: 0.14em; text-transform: uppercase; line-height: 1; margin-top: 3px"
                    >
                        Management System
                    </div>
                </div>
            </div>

            <div
                class="d-none d-md-flex align-center justify-center"
                style="flex: 1 1 auto; min-width: 0; padding: 0 24px"
            >
                <v-autocomplete
                    v-model="searchSelect"
                    v-model:search="searchText"
                    :items="searchResults"
                    item-title="title"
                    item-value="value"
                    return-object
                    clearable
                    hide-details
                    density="compact"
                    variant="solo"
                    bg-color="#e5e9ef"
                    rounded="pill"
                    prepend-inner-icon="mdi-magnify"
                    placeholder="Search"
                    :no-data-text="searchNoDataText"
                    :menu-props="{ contentClass: 'search-menu', offset: 18 }"
                    class="font-weight-bold search-pixiv"
                    style="width: 100%; max-width: 520px"
                    @focus="ensureSearchData"
                    @update:model-value="goToResult"
                >
                    <template v-slot:item="{ props, item }">
                        <v-list-item
                            v-bind="props"
                            :prepend-icon="item.raw.icon"
                            :title="item.raw.title"
                            :subtitle="item.raw.subtitle"
                        />
                    </template>
                </v-autocomplete>
            </div>

            <div class="d-flex align-center" style="flex: 0 0 auto">
                <v-chip
                    variant="flat"
                    class="mr-2 font-weight-medium"
                    style="background: #f1f5f9; color: #334155"
                    v-tooltip="'Zamboanga local time'"
                >
                    <v-icon start color="primary">mdi-clock-outline</v-icon>
                    {{ clock }}
                </v-chip>

                <v-chip
                    variant="flat"
                    class="mr-2 font-weight-medium"
                    style="background: #f1f5f9; color: #334155"
                    v-tooltip="'Weather in Zamboanga City: ' + weatherLabel"
                >
                    <v-icon start color="primary">{{ weatherIcon }}</v-icon>
                    {{ temperature }} · Zamboanga
                </v-chip>

                <v-chip
                    v-if="auth.user.value"
                    variant="flat"
                    class="mr-2 font-weight-medium d-none d-md-flex"
                    style="background: #f1f5f9; color: #334155"
                    v-tooltip="userTooltip"
                >
                    <v-icon color="primary">mdi-account-circle</v-icon>
                </v-chip>

                <v-btn
                    icon="mdi-logout"
                    v-tooltip="'Log out'"
                    color="primary"
                    @click="onLogout"
                />
            </div>
        </v-app-bar>

        <v-navigation-drawer
            v-if="showAuthUi"
            v-model="drawer"
            :rail="rail"
            style="border-right: 2px solid #7C3AED"
            @mouseenter="expandOnHover"
            @mouseleave="collapseOnLeave"
        >
            <v-list nav color="primary">
                <v-list-item to="/" prepend-icon="mdi-view-dashboard" rounded="lg">
                    <v-list-item-title>DASHBOARD</v-list-item-title>
                </v-list-item>
                <v-list-item
                    to="/my/transactions"
                    prepend-icon="mdi-file-document-multiple"
                    rounded="lg"
                >
                    <v-list-item-title>MY TRANSACTIONS</v-list-item-title>
                </v-list-item>

                <template v-if="isSuperadmin">
                    <v-list-item
                        to="/transactions"
                        prepend-icon="mdi-swap-horizontal"
                        rounded="lg"
                    >
                        <v-list-item-title>TRANSACTIONS</v-list-item-title>
                    </v-list-item>
                    <v-list-item to="/admin/users" prepend-icon="mdi-account-group" rounded="lg">
                        <v-list-item-title>USERS</v-list-item-title>
                    </v-list-item>
                    <v-list-item to="/admin/roles" prepend-icon="mdi-shield-account" rounded="lg">
                        <v-list-item-title>ROLES</v-list-item-title>
                    </v-list-item>
                    <v-list-item
                        to="/admin/transaction-types"
                        prepend-icon="mdi-format-list-bulleted-type"
                        rounded="lg"
                    >
                        <v-list-item-title>TRANSACTION TYPES</v-list-item-title>
                    </v-list-item>
                    <v-list-item
                        to="/admin/fields"
                        prepend-icon="mdi-form-textbox"
                        rounded="lg"
                    >
                        <v-list-item-title>FIELDS</v-list-item-title>
                    </v-list-item>
                    <v-list-item
                        to="/admin/requirements"
                        prepend-icon="mdi-clipboard-check-outline"
                        rounded="lg"
                    >
                        <v-list-item-title>REQUIREMENTS</v-list-item-title>
                    </v-list-item>
                    <v-list-item
                        to="/admin/government-references"
                        prepend-icon="mdi-bank"
                        rounded="lg"
                    >
                        <v-list-item-title>GOV REFERENCES</v-list-item-title>
                    </v-list-item>
                </template>
            </v-list>
            <template #append>
                <v-divider />
                <div
                    class="d-flex pa-2 drawer-footer"
                    :class="rail ? 'flex-column align-center ga-1' : 'flex-row align-center justify-space-evenly ga-2'"
                >
                    <v-btn
                        :icon="rail"
                        size="small"
                        variant="tonal"
                        color="primary"
                        density="comfortable"
                        v-tooltip="rail ? (isDark ? 'Light mode' : 'Dark mode') : undefined"
                        @click="toggleTheme"
                    >
                        <v-icon>{{ isDark ? "mdi-weather-sunny" : "mdi-weather-night" }}</v-icon>
                        <span v-if="!rail" class="ml-1 text-caption font-weight-bold">
                            {{ isDark ? "LIGHT" : "DARK" }}
                        </span>
                    </v-btn>
                    <v-btn
                        :icon="rail"
                        size="small"
                        variant="tonal"
                        color="primary"
                        density="comfortable"
                        to="/help"
                        v-tooltip="rail ? 'Help' : undefined"
                    >
                        <v-icon>mdi-help-circle-outline</v-icon>
                        <span v-if="!rail" class="ml-1 text-caption font-weight-bold">HELP</span>
                    </v-btn>
                </div>
            </template>
        </v-navigation-drawer>

        <v-main>
            <v-container v-if="showAuthUi" fluid class="pa-6">
                <router-view />
            </v-container>
            <template v-else>
                <router-view />
            </template>
        </v-main>
    </v-app>
</template>

<script setup>
import { computed, ref, onMounted, onUnmounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import { useDisplay, useTheme } from "vuetify";
import { useAuth } from "@/composables/useAuth";
import { useMyTransactions } from "@/composables/useMyTransactions";
import { useTransactions } from "@/composables/useTransactions";

const router = useRouter();
const route = useRoute();
const auth = useAuth();
const { mobile } = useDisplay();

// ---- Collapsible sidebar (starts collapsed) ----
// Hover expands via the same `rail` state the hamburger toggles,
// so both push the content instead of overlaying it.
const drawer = ref(!mobile.value);
const rail = ref(true);
let hoverExpanded = false;

const toggleNav = () => {
    hoverExpanded = false;
    if (mobile.value) {
        drawer.value = !drawer.value;
    } else {
        rail.value = !rail.value;
    }
};

const expandOnHover = () => {
    if (mobile.value || !drawer.value || !rail.value) return;
    hoverExpanded = true;
    rail.value = false;
};

const collapseOnLeave = () => {
    if (mobile.value || !hoverExpanded) return;
    hoverExpanded = false;
    rail.value = true;
};

const showAuthUi = computed(() => {
    return !!auth.user.value && route.name !== "login";
});

const isSuperadmin = computed(() => {
    const roles = auth.user.value?.roles ?? [];
    return roles.some((r) => r.code === "superadmin");
});

const userTooltip = computed(() => {
    const u = auth.user.value;
    if (!u) return "User";
    const roles = (u.roles ?? []).map((r) => r.name || r.code).join(", ");
    return roles ? `${u.email || u.name} (${roles})` : u.email || u.name || "User";
});

async function onLogout() {
    await auth.logout();
    await router.push({ name: "login" });
}

// ---- Global navbar search (transactions + pages) ----
const searchText = ref("");
const searchSelect = ref(null);
const searchLoading = ref(false);
let searchLoaded = false;

const myTx = useMyTransactions();
const allTx = useTransactions();

const searchPages = computed(() => {
    const pages = [
        { title: "Dashboard", subtitle: "Page", icon: "mdi-view-dashboard", to: "/" },
        {
            title: "My Transactions",
            subtitle: "Page",
            icon: "mdi-file-document-multiple",
            to: "/my/transactions",
        },
        { title: "Help", subtitle: "Page", icon: "mdi-help-circle-outline", to: "/help" },
    ];
    if (isSuperadmin.value) {
        pages.push(
            { title: "Transactions", subtitle: "Page · Admin", icon: "mdi-swap-horizontal", to: "/transactions" },
            { title: "Users", subtitle: "Page · Admin", icon: "mdi-account-group", to: "/admin/users" },
            { title: "Roles", subtitle: "Page · Admin", icon: "mdi-shield-account", to: "/admin/roles" },
            {
                title: "Transaction Types",
                subtitle: "Page · Admin",
                icon: "mdi-format-list-bulleted-type",
                to: "/admin/transaction-types",
            },
            { title: "Fields", subtitle: "Page · Admin", icon: "mdi-form-textbox", to: "/admin/fields" },
            {
                title: "Requirements",
                subtitle: "Page · Admin",
                icon: "mdi-clipboard-check-outline",
                to: "/admin/requirements",
            },
            {
                title: "Government References",
                subtitle: "Page · Admin",
                icon: "mdi-bank",
                to: "/admin/government-references",
            }
        );
    }
    return pages.map((p, i) => ({ ...p, type: "page", value: `page-${i}` }));
});

async function ensureSearchData() {
    if (searchLoaded || searchLoading.value) return;
    searchLoading.value = true;
    try {
        await myTx.fetchAll();
        if (isSuperadmin.value) {
            try {
                await allTx.fetchAll();
            } catch {
                /* my list is enough */
            }
        }
    } catch {
        /* search stays page-only */
    } finally {
        searchLoading.value = false;
        searchLoaded = true;
    }
}

const searchResults = computed(() => {
    const q = (searchText.value || "").trim().toLowerCase();
    // No auto-suggestions: only search once the user types something.
    if (!q) return [];

    const seen = new Set();
    const txItems = [];

    const pushTx = (tx, to) => {
        if (!tx || seen.has(tx.id)) return;
        seen.add(tx.id);
        txItems.push({
            type: "tx",
            value: `tx-${to}-${tx.id}`,
            title: tx.title || tx.reference_number || `Transaction #${tx.id}`,
            subtitle: [tx.reference_number, tx.transaction_type?.name || tx.transaction_type_name]
                .filter(Boolean)
                .join(" · "),
            icon: "mdi-file-document-outline",
            to: `${to}/${tx.id}`,
        });
    };

    (myTx.items.value || []).forEach((tx) => pushTx(tx, "/my/transactions"));
    if (isSuperadmin.value) {
        (allTx.items.value || []).forEach((tx) => pushTx(tx, "/transactions"));
    }

    return [
        ...txItems.filter((i) => `${i.title} ${i.subtitle}`.toLowerCase().includes(q)).slice(0, 7),
        ...searchPages.value.filter((p) => p.title.toLowerCase().includes(q)),
    ];
});

const searchNoDataText = computed(() => {
    const q = (searchText.value || "").trim();
    return q ? `No results for "${q}"` : "Search anything . . .";
});

async function goToResult(item) {
    if (!item?.to) return;
    searchSelect.value = null;
    searchText.value = "";
    await router.push(item.to);
}

// ---- Live clock (Asia/Manila, Zamboanga, time only) ----
const clock = ref("--:--:--");
const MANILA_TZ = "Asia/Manila";
let clockTimer = null;

const tickClock = () => {
    clock.value = new Date().toLocaleTimeString("en-PH", {
        timeZone: MANILA_TZ,
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit",
        hour12: true,
    });
};

// ---- Temperature (via /api/weather proxy, Zamboanga City) ----
const temperature = ref("--°C");
const weatherIcon = ref("mdi-thermometer");
const weatherLabel = ref("loading…");

const WEATHER_TEXT = {
    0: "Clear sky",
    1: "Mainly clear",
    2: "Partly cloudy",
    3: "Overcast",
    45: "Fog",
    48: "Icy fog",
    51: "Light drizzle",
    53: "Drizzle",
    55: "Heavy drizzle",
    56: "Light freezing drizzle",
    57: "Freezing drizzle",
    61: "Light rain",
    63: "Rain",
    65: "Heavy rain",
    66: "Light freezing rain",
    67: "Freezing rain",
    71: "Light snow",
    73: "Snow",
    75: "Heavy snow",
    77: "Snow grains",
    80: "Light showers",
    81: "Showers",
    82: "Heavy showers",
    85: "Light snow showers",
    86: "Snow showers",
    95: "Thunderstorm",
    96: "Storm with light hail",
    99: "Storm with hail",
};

// Dynamic icon driven by the live condition code (+ day/night)
const iconForCode = (code, temp, isDay = 1) => {
    const night = Number(isDay) === 0;
    if (code === null || code === undefined) {
        if (temp >= 32) return night ? "mdi-weather-night" : "mdi-weather-sunny";
        if (temp >= 27) return night ? "mdi-weather-night-partly-cloudy" : "mdi-weather-partly-cloudy";
        return "mdi-weather-cloudy";
    }
    if (code === 0 || code === 1) return night ? "mdi-weather-night" : "mdi-weather-sunny";
    if (code === 2) return night ? "mdi-weather-night-partly-cloudy" : "mdi-weather-partly-cloudy";
    if (code === 3) return "mdi-weather-cloudy";
    if ([45, 48].includes(code)) return "mdi-weather-fog";
    if ([51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82].includes(code))
        return "mdi-weather-rainy";
    if ([71, 73, 75, 77, 85, 86].includes(code)) return "mdi-weather-snowy";
    if ([95, 96, 99].includes(code)) return "mdi-weather-lightning-rainy";
    return "mdi-weather-cloudy";
};

const loadTemperature = async () => {
    const applyTemp = (temp, code, isDay = 1) => {
        if (temp === null || temp === undefined || Number.isNaN(Number(temp)))
            throw new Error("no data");
        const t = Math.round(Number(temp));
        temperature.value = `${t}°C`;
        weatherIcon.value = iconForCode(code, t, isDay);
        weatherLabel.value =
            code !== null && code !== undefined && WEATHER_TEXT[code]
                ? `${WEATHER_TEXT[code]}, ${t}°C`
                : `${t}°C`;
    };

    const openMeteoUrl =
        "https://api.open-meteo.com/v1/forecast?latitude=6.9214&longitude=122.0790&current=temperature_2m,weather_code,is_day&timezone=Asia%2FManila";

    try {
        const res = await fetch("/api/weather", { headers: { Accept: "application/json" } });
        if (!res.ok) throw new Error("proxy failed");
        const data = await res.json();
        if (data.temperature === null || data.temperature === undefined) {
            // Backend reachable but upstream failed: try Open-Meteo directly
            const direct = await fetch(openMeteoUrl);
            const d = await direct.json();
            applyTemp(d?.current?.temperature_2m, d?.current?.weather_code, d?.current?.is_day);
        } else {
            applyTemp(data.temperature, data.code, data.is_day);
        }
    } catch {
        try {
            const direct = await fetch(openMeteoUrl);
            const d = await direct.json();
            applyTemp(d?.current?.temperature_2m, d?.current?.weather_code, d?.current?.is_day);
        } catch {
            temperature.value = "N/A";
            weatherIcon.value = "mdi-thermometer-off";
            weatherLabel.value = "unavailable";
        }
    }
};

let weatherTimer = null;

// ---- Dark mode (persisted, applied via Vuetify theme + html.dark CSS layer) ----
const theme = useTheme();
const THEME_KEY = "lgu-tx:theme";
const isDark = computed(() => theme.global.name.value === "pixivDark");

function applyTheme(name) {
    theme.global.name.value = name;
    document.documentElement.classList.toggle("dark", name === "pixivDark");
    try {
        localStorage.setItem(THEME_KEY, name);
    } catch {
        /* private mode: theme just won't persist */
    }
}

function toggleTheme() {
    applyTheme(isDark.value ? "pixivLight" : "pixivDark");
}

onMounted(() => {
    let saved = null;
    try {
        saved = localStorage.getItem(THEME_KEY);
    } catch {
        /* ignore */
    }
    if (saved === "pixivDark" || saved === "pixivLight") applyTheme(saved);
    tickClock();
    clockTimer = setInterval(tickClock, 1000);
    loadTemperature();
    weatherTimer = setInterval(loadTemperature, 10 * 60 * 1000);
});

onUnmounted(() => {
    if (clockTimer) clearInterval(clockTimer);
    if (weatherTimer) clearInterval(weatherTimer);
});
</script>

<style scoped>
/* Compact sidebar: tighter rows so all items fit without scrolling */
.nav-compact :deep(.v-list-item) {
    min-height: 36px !important;
    padding-top: 2px;
    padding-bottom: 2px;
}
.nav-compact :deep(.v-list-item-title) {
    font-size: 0.78rem;
    line-height: 1.2;
}
.nav-compact :deep(.v-list-item__prepend .v-icon) {
    font-size: 1.1rem;
}
/* Footer theme/help pair */
.drawer-footer .v-btn {
    min-width: 0;
    text-transform: none;
    letter-spacing: 0;
}
/* Pixiv-style pill search: chunky rounded type, soft shadow, blue focus ring */
.search-pixiv :deep(.v-field) {
    box-shadow: 0 1px 3px rgba(15, 23, 42, 0.12);
    font-weight: 700;
    max-height: 38px;
}
.search-pixiv :deep(.v-field__input) {
    min-height: 38px;
    padding-top: 4px;
    padding-bottom: 4px;
}
.search-pixiv :deep(.v-field--focused) {
    box-shadow: 0 0 0 2px #7C3AED;
}
.search-pixiv :deep(.v-field__prepend-inner .v-icon) {
    color: #7C3AED;
    opacity: 1;
}
.search-pixiv :deep(input),
.search-pixiv :deep(input::placeholder) {
    font-family: 'M PLUS Rounded 1c', sans-serif;
    font-weight: 700;
}
</style>
