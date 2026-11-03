<template>
    <div class="help-page">
        <!-- Hero: search + quick jumps -->
        <section class="hp-hero">
            <span class="hp-orb hp-orb--blue" aria-hidden="true"></span>
            <span class="hp-orb hp-orb--teal" aria-hidden="true"></span>
            <div class="hp-hero-inner">
                <span class="hp-badge">
                    <v-icon size="15">mdi-lifebuoy</v-icon>
                    Help Center
                </span>
                <h1 class="hp-title">How can we help?</h1>
                <p class="hp-sub">
                    Short, practical guides for moving transactions and setting the system up.
                </p>

                <div class="hp-search">
                    <v-text-field
                        v-model="query"
                        prepend-inner-icon="mdi-magnify"
                        placeholder="Search guides, steps, or settings…"
                        variant="solo"
                        density="comfortable"
                        rounded="lg"
                        flat
                        hide-details
                        clearable
                        bg-color="white"
                        aria-label="Search help"
                    />
                </div>

                <nav class="hp-jumps" aria-label="Help sections">
                    <button type="button" class="hp-jump" @click="scrollTo('work')">
                        <v-icon size="16">mdi-account-check-outline</v-icon>
                        Doing your work
                        <span class="hp-jump-count">{{ userSteps.length }}</span>
                    </button>
                    <button v-if="isSuperadmin" type="button" class="hp-jump" @click="scrollTo('setup')">
                        <v-icon size="16">mdi-cog-outline</v-icon>
                        Setting the system up
                        <span class="hp-jump-count">{{ adminSteps.length }}</span>
                    </button>
                    <button type="button" class="hp-jump" @click="scrollTo('reference')">
                        <v-icon size="16">mdi-source-branch</v-icon>
                        Reference &amp; notes
                        <span class="hp-jump-count">{{ notes.length + 1 }}</span>
                    </button>
                </nav>
            </div>
        </section>

        <!-- No search results -->
        <div v-if="query.trim() && !anyVisible" class="hp-empty">
            <v-icon size="34" color="#005EED">mdi-magnify-close</v-icon>
            <div class="hp-empty-text">
                <div class="hp-empty-title">No matches for “{{ query.trim() }}”</div>
                <div class="hp-empty-hint">Try a different word, or clear the search to see every guide.</div>
            </div>
            <v-btn variant="tonal" color="primary" rounded="lg" @click="query = ''">Clear search</v-btn>
        </div>

        <!-- Doing your work -->
        <section v-if="filteredUser.length" id="work" class="hp-section">
            <header class="hp-section-head">
                <span class="hp-section-icon">
                    <v-icon size="20">mdi-account-check-outline</v-icon>
                </span>
                <div>
                    <div class="hp-kicker">For everyone</div>
                    <h2 class="hp-section-title">Doing your work</h2>
                </div>
                <span class="hp-count">{{ filteredUser.length }}</span>
            </header>

            <v-expansion-panels v-model="open" multiple class="hp-panels">
                <v-expansion-panel
                    v-for="item in filteredUser"
                    :key="'user-' + item.i"
                    :value="'user-' + item.i"
                    class="hp-panel"
                >
                    <v-expansion-panel-title class="hp-panel-title">
                        <div class="hp-row">
                            <span class="hp-num">{{ item.i + 1 }}</span>
                            <span class="hp-ico">
                                <v-icon size="19">{{ item.s.icon }}</v-icon>
                            </span>
                            <span class="hp-row-text">
                                <span class="hp-row-title">{{ item.s.title }}</span>
                                <span class="hp-row-hint">{{ item.s.hint }}</span>
                            </span>
                        </div>
                    </v-expansion-panel-title>
                    <v-expansion-panel-text>
                        <div class="hp-body text-body-2" v-html="item.s.text" />
                        <div v-if="item.s.to" class="hp-actions">
                            <v-btn color="primary" rounded="lg" :to="item.s.to" append-icon="mdi-arrow-right">
                                Open page
                            </v-btn>
                        </div>
                    </v-expansion-panel-text>
                </v-expansion-panel>
            </v-expansion-panels>
        </section>

        <!-- Admin setup -->
        <section v-if="isSuperadmin && filteredAdmin.length" id="setup" class="hp-section">
            <header class="hp-section-head">
                <span class="hp-section-icon is-purple">
                    <v-icon size="20">mdi-cog-outline</v-icon>
                </span>
                <div>
                    <div class="hp-kicker">Superadmin</div>
                    <h2 class="hp-section-title">Setting the system up</h2>
                </div>
                <span class="hp-count">{{ filteredAdmin.length }}</span>
            </header>

            <v-expansion-panels v-model="open" multiple class="hp-panels">
                <v-expansion-panel
                    v-for="item in filteredAdmin"
                    :key="'admin-' + item.i"
                    :value="'admin-' + item.i"
                    class="hp-panel"
                >
                    <v-expansion-panel-title class="hp-panel-title">
                        <div class="hp-row">
                            <span class="hp-num is-purple">{{ item.i + 1 }}</span>
                            <span class="hp-ico is-purple">
                                <v-icon size="19">{{ item.s.icon }}</v-icon>
                            </span>
                            <span class="hp-row-text">
                                <span class="hp-row-title">{{ item.s.title }}</span>
                                <span class="hp-row-hint">{{ item.s.hint }}</span>
                            </span>
                        </div>
                    </v-expansion-panel-title>
                    <v-expansion-panel-text>
                        <div class="hp-body text-body-2" v-html="item.s.text" />
                        <div v-if="item.s.to" class="hp-actions">
                            <v-btn color="primary" rounded="lg" :to="item.s.to" append-icon="mdi-arrow-right">
                                Open page
                            </v-btn>
                        </div>
                    </v-expansion-panel-text>
                </v-expansion-panel>
            </v-expansion-panels>
        </section>

        <!-- Stations & routes + notes -->
        <section v-if="showStations || filteredNotes.length" id="reference" class="hp-section">
            <header class="hp-section-head">
                <span class="hp-section-icon is-teal">
                    <v-icon size="20">mdi-source-branch</v-icon>
                </span>
                <div>
                    <div class="hp-kicker">Reference</div>
                    <h2 class="hp-section-title">Stations, routes &amp; notes</h2>
                </div>
                <span class="hp-count">{{ filteredNotes.length + (showStations ? 1 : 0) }}</span>
            </header>

            <v-expansion-panels v-if="showStations" v-model="open" multiple class="hp-panels mb-4">
                <v-expansion-panel value="stations" class="hp-panel">
                    <v-expansion-panel-title class="hp-panel-title">
                        <div class="hp-row">
                            <span class="hp-ico is-teal">
                                <v-icon size="19">mdi-source-branch</v-icon>
                            </span>
                            <span class="hp-row-text">
                                <span class="hp-row-title">Transaction Steps &amp; Routes</span>
                                <span class="hp-row-hint">Stations are steps · arrows are routes · Procurement 14-station example</span>
                            </span>
                        </div>
                    </v-expansion-panel-title>
                    <v-expansion-panel-text>
                        <div class="hp-body text-body-2">
                            Stations are steps where papers sit; arrows are routes papers travel.
                            See the Procurement 14-station example in the full guide.
                        </div>
                        <div class="hp-actions">
                            <v-btn color="primary" rounded="lg" @click="openWindow('stations')" append-icon="mdi-arrow-right">
                                Open full guide
                            </v-btn>
                        </div>
                    </v-expansion-panel-text>
                </v-expansion-panel>
            </v-expansion-panels>

            <div v-if="filteredNotes.length" class="hp-notes">
                <button
                    v-for="{ n, i } in filteredNotes"
                    :key="'n' + i"
                    type="button"
                    class="hp-note"
                    @click="openWindow('note-' + i)"
                >
                    <span class="hp-note-ico">
                        <v-icon size="20">{{ n.icon }}</v-icon>
                    </span>
                    <span class="hp-note-text">
                        <span class="hp-note-title">{{ n.title }}</span>
                        <span class="hp-note-hint">{{ n.hint }}</span>
                    </span>
                    <v-icon class="hp-note-arrow" size="20">mdi-arrow-top-right</v-icon>
                </button>
            </div>
        </section>

        <!-- Window dialog -->
        <v-dialog v-model="windowOpen" max-width="820">
            <v-card v-if="activeContent" rounded="xl" class="hp-dialog">
                <v-card-title class="hp-dialog-head">
                    <v-avatar :color="activeContent.color" rounded="lg" size="40" class="mr-3">
                        <v-icon color="white">{{ activeContent.icon }}</v-icon>
                    </v-avatar>
                    <span class="text-h6 font-weight-bold">{{ activeContent.title }}</span>
                    <v-spacer />
                    <v-btn icon="mdi-close" variant="text" @click="windowOpen = false" />
                </v-card-title>
                <v-divider />
                <v-card-text class="pa-5">
                    <div v-if="activeKey === 'stations'">
                        <v-row>
                            <v-col cols="12" md="6">
                                <div class="text-subtitle-2 font-weight-bold mb-2">
                                    <v-icon start size="small" color="grey-darken-3">mdi-format-list-numbered</v-icon>
                                    Steps (stations — where papers sit)
                                </div>
                                <p class="text-caption text-medium-emphasis mb-2">
                                    A step is one desk: it has an order <b>#</b>, a <b>Name</b>, a
                                    <b>Stage</b> (office/phase label), an <b>SLA</b> target in minutes,
                                    <b>start/end</b> flags, and <b>Roles</b> (who may press next).
                                    A paper sits on exactly one step at a time.
                                </p>
                                <v-table density="compact" class="text-caption mb-2">
                                    <thead>
                                        <tr>
                                            <th class="text-left font-weight-bold">#</th>
                                            <th class="text-left font-weight-bold">Step</th>
                                            <th class="text-left font-weight-bold">Who</th>
                                            <th class="text-left font-weight-bold">Flag</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td class="font-weight-bold">1</td>
                                            <td>Create Purchase Request + Attach E-Signature</td>
                                            <td>End User</td>
                                            <td><v-chip size="x-small" variant="tonal" color="success" rounded="0">start</v-chip></td>
                                        </tr>
                                        <tr>
                                            <td class="font-weight-bold">2–4</td>
                                            <td>Upload to Drive → Create DTS → Email GSO</td>
                                            <td>End User</td>
                                            <td>—</td>
                                        </tr>
                                        <tr>
                                            <td class="font-weight-bold">5–6</td>
                                            <td>Input PR Number → Return for E-Sign</td>
                                            <td>GSO</td>
                                            <td>—</td>
                                        </tr>
                                        <tr>
                                            <td class="font-weight-bold">7–9</td>
                                            <td>City Admin signs → Email CTO → Treasurer signs</td>
                                            <td>City Admin / CTO / Treasurer</td>
                                            <td>—</td>
                                        </tr>
                                        <tr>
                                            <td class="font-weight-bold">10–13</td>
                                            <td>Couriers → CBO validates → Earmark</td>
                                            <td>CTO / CAdmin / CBO</td>
                                            <td>—</td>
                                        </tr>
                                        <tr>
                                            <td class="font-weight-bold">14</td>
                                            <td>Submit Documents to BAC-PAAD</td>
                                            <td>BAC-PAAD</td>
                                            <td><v-chip size="x-small" variant="tonal" color="info" rounded="0">end</v-chip></td>
                                        </tr>
                                    </tbody>
                                </v-table>
                                <p class="text-caption text-medium-emphasis">
                                    Every flow needs at least one <b>start</b> and one <b>end</b> before it can go live.
                                </p>
                            </v-col>
                            <v-col cols="12" md="6">
                                <div class="text-subtitle-2 font-weight-bold mb-2">
                                    <v-icon start size="small" color="grey-darken-3">mdi-arrow-right-bold</v-icon>
                                    Routes (arrows — how papers move)
                                </div>
                                <p class="text-caption text-medium-emphasis mb-2">
                                    A route connects one step to another: <b>From → To</b> plus an
                                    <b>action</b> (<b>submit</b> = forward, <b>return</b> = send back
                                    for correction). No arrow, no move.
                                </p>
                                <v-table density="compact" class="text-caption mb-2">
                                    <thead>
                                        <tr>
                                            <th class="text-left font-weight-bold">From</th>
                                            <th class="text-left font-weight-bold">To</th>
                                            <th class="text-left font-weight-bold">Action</th>
                                            <th class="text-left font-weight-bold">Means</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td class="font-weight-bold">1 · Create PR</td>
                                            <td class="font-weight-bold">2 · Upload Drive</td>
                                            <td><v-chip size="x-small" variant="tonal" color="primary" rounded="0">submit</v-chip></td>
                                            <td>Normal forward hop</td>
                                        </tr>
                                        <tr>
                                            <td class="font-weight-bold">5 · Input PR No</td>
                                            <td class="font-weight-bold">6 · E-Sign step</td>
                                            <td><v-chip size="x-small" variant="tonal" color="primary" rounded="0">submit</v-chip></td>
                                            <td>GSO forwards after encoding</td>
                                        </tr>
                                        <tr>
                                            <td class="font-weight-bold">6 · Return E-Sig</td>
                                            <td class="font-weight-bold">1 · Create PR</td>
                                            <td><v-chip size="x-small" variant="tonal" color="warning" rounded="0">return</v-chip></td>
                                            <td>E-sign missing — back to originator</td>
                                        </tr>
                                        <tr>
                                            <td class="font-weight-bold">13 · Earmark</td>
                                            <td class="font-weight-bold">14 · BAC-PAAD</td>
                                            <td><v-chip size="x-small" variant="tonal" color="primary" rounded="0">submit</v-chip></td>
                                            <td>Final release; 14 has no outgoing arrows</td>
                                        </tr>
                                    </tbody>
                                </v-table>
                                <p class="text-caption text-medium-emphasis">
                                    Rule of thumb: <b>13 forwards + 1 return = 14 routes</b> for a
                                    14-station chain with one correction loop.
                                </p>
                            </v-col>
                        </v-row>
                        <div class="d-flex justify-end mt-3">
                            <v-btn color="primary" rounded="lg" to="/admin/transaction-types" append-icon="mdi-arrow-right">
                                Open page
                            </v-btn>
                        </div>
                    </div>
                    <div v-else-if="activeContent?.body" class="text-body-2" v-html="activeContent.body" />
                </v-card-text>
                <v-divider />
                <v-card-actions class="justify-end">
                    <v-btn variant="text" rounded="lg" @click="windowOpen = false">Close</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>

    <div class="help-foot" aria-hidden="true"></div>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { useAuth } from '@/composables/useAuth'

const auth = useAuth()

const isSuperadmin = computed(() => {
    const roles = auth.user.value?.roles ?? []
    return roles.some((r) => r.code === 'superadmin')
})

// Search + expanded panels (inline reading, no popups).
const query = ref('')
const open = ref([])

function matches(q, ...fields) {
    if (!q) return true
    return fields.filter(Boolean).join(' ').toLowerCase().includes(q)
}

// Quick-jump chips scroll to a section instead of navigating.
function scrollTo(id) {
    const el = document.getElementById(id)
    if (!el) return
    const reduce = window.matchMedia?.('(prefers-reduced-motion: reduce)').matches
    el.scrollIntoView({ behavior: reduce ? 'auto' : 'smooth', block: 'start' })
}

const userSteps = computed(() => [
    isSuperadmin.value
        ? {
            icon: 'mdi-swap-horizontal',
            title: 'Transactions',
            hint: 'All requests in the system',
            text: 'This is the full queue — every request in the system appears here, with New Transaction and delete actions.',
            to: '/transactions',
        }
        : {
            icon: 'mdi-swap-horizontal',
            title: 'Transactions',
            hint: 'Your queue by office and role',
            text: 'Requests for your office and items waiting on your role appear here.',
            to: '/transactions',
        },
    {
        icon: 'mdi-mouse-left-click-outline',
        title: 'Open a request',
        hint: 'Details, checklist and history',
        text: 'Click any row to see its details, checklist, and history.',
        to: null,
    },
    {
        icon: 'mdi-clipboard-check-outline',
        title: 'Finish the checklist',
        hint: 'Check every required item',
        text: 'Check off each requirement — one tap ticks it; an optional panel lets you jot station info while checking. Required items must all be checked before you can proceed.',
        to: null,
    },
    {
        icon: 'mdi-play-circle-outline',
        title: 'Press Proceed',
        hint: 'Move forward or return',
        text: 'Pick an action and press Proceed: a window gathers the station info and remarks, then moves the request to the next step (or sends it back, if you choose a return action).',
        to: null,
    },
    {
        icon: 'mdi-chart-donut',
        title: 'Track progress',
        hint: 'Stations and color guide',
        text: 'Hover the Current Step chip to see the step-by-step progress. The ? button explains the colors. Green Final Step means done.',
        to: null,
    },
])

const adminSteps = [
    {
        icon: 'mdi-shield-account',
        title: 'Roles',
        hint: 'Create roles first',
        text: 'Create the roles first (e.g. encoder, verifier, approver). Everything else hangs off roles.',
        to: '/admin/roles',
    },
    {
        icon: 'mdi-account-group',
        title: 'Users',
        hint: 'Give each user a role',
        text: 'Add users and give each one a role. Work only appears in the queue of the role assigned to the step.',
        to: '/admin/users',
    },
    {
        icon: 'mdi-format-list-bulleted-type',
        title: 'Transaction Types',
        hint: 'Kinds of requests',
        text: 'Define the kinds of requests (e.g. Communication). Each transaction type gets its own steps.',
        to: '/admin/transaction-types',
    },
    {
        icon: 'mdi-form-textbox',
        title: 'Fields',
        hint: 'Form inputs per step',
        text: 'Define the form fields (text, number, date, select…). Mark which are required or unique.',
        to: '/admin/fields',
    },
    {
        icon: 'mdi-clipboard-check-outline',
        title: 'Requirements',
        hint: 'Checklist items per step',
        text: 'Define the checklist items that steps will ask workers to complete. Required items block moving forward until checked.',
        to: '/admin/requirements',
    },
    {
        icon: 'mdi-source-branch',
        title: 'Transaction Steps',
        hint: '1-2-3 steps, save goes live',
        text: 'Open a Transaction Type → Steps → edit the steps → Save goes live for new transactions. Steps need at least one start and one end.',
        to: '/admin/transaction-types',
    },
    {
        icon: 'mdi-bank',
        title: 'Gov References',
        hint: 'RA, IRR, COA citations',
        text: 'Attach the governing references (RA, IRR, COA…) so the transaction type cites its legal basis.',
        to: '/admin/government-references',
    },
    {
        icon: 'mdi-swap-horizontal',
        title: 'Transactions',
        hint: 'Watch requests flow',
        text: 'New transactions automatically follow the current steps for their type. Watch them flow through the steps here.',
        to: '/transactions',
    },
]

const notes = [
    {
        icon: 'mdi-swap-horizontal',
        title: 'Running transactions are safe',
        hint: 'Edits apply to new ones only',
        body: 'Saving applies to <b>new transactions immediately</b> — running ones finish on the flow they started with. Deleting a step that papers sit on is blocked.',
    },
    {
        icon: 'mdi-source-branch',
        title: 'Which flow is followed?',
        hint: 'Pinned to starting version',
        body: 'Each transaction stays on the transaction type it started with. Saves go live for <b>new transactions only</b>.',
    },
    {
        icon: 'mdi-undo-variant',
        title: 'What is a return?',
        hint: 'Backward hop for correction',
        body: 'A <b>return route</b> sends work backward (e.g. Station 2 → Station 1) for correction — that is normal, not an error.',
    },
]

const filteredUser = computed(() => {
    const q = query.value.trim().toLowerCase()
    return userSteps.value
        .map((s, i) => ({ s, i }))
        .filter(({ s }) => matches(q, s.title, s.hint, s.text))
})

const filteredAdmin = computed(() => {
    const q = query.value.trim().toLowerCase()
    return adminSteps
        .map((s, i) => ({ s, i }))
        .filter(({ s }) => matches(q, s.title, s.hint, s.text))
})

const showStations = computed(() =>
    matches(
        query.value.trim().toLowerCase(),
        'Transaction Steps & Routes',
        'Stations are steps',
        'arrows are routes',
        'Procurement 14-station example',
    ),
)

const filteredNotes = computed(() => {
    const q = query.value.trim().toLowerCase()
    return notes
        .map((n, i) => ({ n, i }))
        .filter(({ n }) => matches(q, n.title, n.hint, n.body))
})

// Detail window (stations full guide + note cards). Keys: 'stations', 'note-<index>'.
const windowOpen = ref(false)
const activeKey = ref(null)
const activeContent = computed(() => {
    if (activeKey.value === 'stations') {
        return { icon: 'mdi-source-branch', title: 'Transaction Steps & Routes', color: '#005EED' }
    }
    const m = /^note-(\d+)$/.exec(activeKey.value || '')
    if (m) {
        const n = notes[Number(m[1])]
        if (n) return { icon: n.icon, title: n.title, color: '#BF360C', body: n.body }
    }
    return null
})
function openWindow(key) {
    activeKey.value = key
    windowOpen.value = true
}

const anyVisible = computed(
    () =>
        filteredUser.value.length > 0 ||
        filteredAdmin.value.length > 0 ||
        showStations.value ||
        filteredNotes.value.length > 0,
)

// Searching expands every match so results read inline at once.
watch(query, () => {
    if (!query.value.trim()) {
        open.value = []
        return
    }
    open.value = [
        ...filteredUser.value.map(({ i }) => `user-${i}`),
        ...filteredAdmin.value.map(({ i }) => `admin-${i}`),
        ...(showStations.value ? ['stations'] : []),
        ...filteredNotes.value.map(({ i }) => `note-${i}`),
    ]
})
</script>

<style scoped>
.help-page {
    --hp-ink: #0f172a;
    --hp-muted: #64748b;
    --hp-card: #ffffff;
    --hp-border: #e2e8f0;
    --hp-blue: #005eed;
    --hp-blue-soft: rgba(0, 94, 237, 0.08);
}

html.dark .help-page {
    --hp-ink: #e2e8f0;
    --hp-muted: #94a3b8;
    --hp-card: #1e1e2e;
    --hp-border: #2e2e44;
    --hp-blue-soft: rgba(147, 197, 253, 0.12);
}

/* ---- hero ---- */
.hp-hero {
    position: relative;
    overflow: hidden;
    margin-bottom: 26px;
    padding: 46px 32px 30px;
    border-radius: 20px;
    color: #fff;
    background:
        radial-gradient(120% 150% at 88% 0%, rgba(37, 99, 235, 0.6) 0%, transparent 55%),
        radial-gradient(110% 130% at 0% 100%, rgba(14, 165, 164, 0.4) 0%, transparent 55%),
        linear-gradient(135deg, #0b2b66 0%, #071d47 100%);
    box-shadow: 0 28px 60px -34px rgba(7, 29, 71, 0.85);
}

.hp-orb {
    position: absolute;
    border-radius: 50%;
    filter: blur(2px);
    pointer-events: none;
}

.hp-orb--blue {
    top: -90px;
    right: -60px;
    width: 260px;
    height: 260px;
    background: radial-gradient(circle, rgba(96, 165, 250, 0.32), transparent 70%);
}

.hp-orb--teal {
    bottom: -120px;
    left: -80px;
    width: 300px;
    height: 300px;
    background: radial-gradient(circle, rgba(45, 212, 191, 0.22), transparent 70%);
}

.hp-hero-inner {
    position: relative;
    z-index: 1;
    max-width: 860px;
}

.hp-badge {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 7px 13px;
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.1);
    font-size: 0.68rem;
    font-weight: 800;
    letter-spacing: 0.14em;
    text-transform: uppercase;
}

.hp-title {
    margin: 18px 0 8px;
    font-size: clamp(1.85rem, 3.2vw, 2.6rem);
    font-weight: 850;
    line-height: 1.08;
    letter-spacing: -0.02em;
}

.hp-sub {
    max-width: 560px;
    margin: 0 0 24px;
    color: rgba(255, 255, 255, 0.76);
    font-size: 0.94rem;
    line-height: 1.6;
}

.hp-search {
    max-width: 620px;
}

.hp-search :deep(.v-field) {
    border-radius: 12px;
    box-shadow: 0 10px 26px -16px rgba(2, 20, 60, 0.9);
}

.hp-search :deep(.v-field__input) {
    padding-top: 8px;
    padding-bottom: 8px;
}

.hp-jumps {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 18px;
}

.hp-jump {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 8px 12px;
    border: 1px solid rgba(255, 255, 255, 0.22);
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.08);
    color: rgba(255, 255, 255, 0.92);
    font-size: 0.78rem;
    font-weight: 650;
    cursor: pointer;
    transition: background-color 0.18s ease, border-color 0.18s ease, transform 0.18s ease;
}

.hp-jump:hover {
    background: rgba(255, 255, 255, 0.16);
    border-color: rgba(255, 255, 255, 0.4);
    transform: translateY(-1px);
}

.hp-jump-count {
    display: inline-grid;
    place-items: center;
    min-width: 20px;
    height: 20px;
    padding: 0 6px;
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.92);
    color: #0b2b66;
    font-size: 0.68rem;
    font-weight: 800;
}

/* ---- empty search ---- */
.hp-empty {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 24px;
    padding: 18px 20px;
    border: 1px solid var(--hp-border);
    border-radius: 16px;
    background: var(--hp-card);
}

.hp-empty-text {
    flex: 1 1 auto;
    min-width: 0;
}

.hp-empty-title {
    color: var(--hp-ink);
    font-weight: 800;
}

.hp-empty-hint {
    color: var(--hp-muted);
    font-size: 0.82rem;
}

/* ---- sections ---- */
.hp-section {
    margin-bottom: 30px;
    /* Keep the section heading clear of the fixed app bar when jumping. */
    scroll-margin-top: 88px;
}

.hp-section-head {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 14px;
}

.hp-section-icon {
    display: grid;
    place-items: center;
    flex: 0 0 auto;
    width: 44px;
    height: 44px;
    border-radius: 14px;
    color: #fff;
    background: linear-gradient(135deg, #005eed, #14b8ff);
    box-shadow: 0 10px 20px -12px rgba(0, 94, 237, 0.8);
}

.hp-section-icon.is-purple {
    background: linear-gradient(135deg, #6d28d9, #a78bfa);
    box-shadow: 0 10px 20px -12px rgba(109, 40, 217, 0.8);
}

.hp-section-icon.is-teal {
    background: linear-gradient(135deg, #0f766e, #14b8a6);
    box-shadow: 0 10px 20px -12px rgba(15, 118, 110, 0.8);
}

.hp-kicker {
    color: var(--hp-muted);
    font-size: 0.66rem;
    font-weight: 800;
    letter-spacing: 0.14em;
    text-transform: uppercase;
}

.hp-section-title {
    margin: 0;
    color: var(--hp-ink);
    font-size: 1.16rem;
    font-weight: 800;
    line-height: 1.25;
}

.hp-count {
    margin-left: auto;
    padding: 4px 10px;
    border: 1px solid var(--hp-border);
    border-radius: 999px;
    background: var(--hp-card);
    color: var(--hp-muted);
    font-size: 0.74rem;
    font-weight: 800;
}

/* ---- accordion cards ---- */
.hp-panels {
    display: flex;
    flex-direction: column;
    gap: 10px;
    background: transparent;
}

.hp-panel {
    overflow: hidden;
    border: 1px solid var(--hp-border);
    border-radius: 14px !important;
    background: var(--hp-card);
    transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.hp-panel:hover {
    border-color: rgba(0, 94, 237, 0.35);
    box-shadow: 0 14px 30px -24px rgba(15, 23, 42, 0.7);
}

.hp-panel.v-expansion-panel--active {
    border-color: rgba(0, 94, 237, 0.55);
    box-shadow: 0 18px 38px -26px rgba(0, 94, 237, 0.85);
}

.hp-panel-title {
    min-height: 70px;
    padding-inline: 16px;
}

.hp-row {
    display: flex;
    align-items: center;
    gap: 13px;
    flex: 1 1 auto;
    min-width: 0;
}

.hp-num {
    display: inline-grid;
    place-items: center;
    flex: 0 0 auto;
    min-width: 30px;
    height: 30px;
    padding: 0 7px;
    border-radius: 999px;
    color: #fff;
    background: linear-gradient(135deg, #005eed, #14b8ff);
    font-size: 0.78rem;
    font-weight: 800;
}

.hp-num.is-purple {
    background: linear-gradient(135deg, #6d28d9, #a78bfa);
}

.hp-ico {
    display: grid;
    place-items: center;
    flex: 0 0 auto;
    width: 40px;
    height: 40px;
    border-radius: 12px;
    color: var(--hp-blue);
    background: var(--hp-blue-soft);
}

.hp-ico.is-purple {
    color: #7c3aed;
    background: rgba(124, 58, 237, 0.1);
}

.hp-ico.is-teal {
    color: #0f766e;
    background: rgba(15, 118, 110, 0.1);
}

.hp-row-text {
    display: flex;
    flex-direction: column;
    min-width: 0;
}

.hp-row-title {
    color: var(--hp-ink);
    font-size: 0.94rem;
    font-weight: 750;
    line-height: 1.3;
}

.hp-row-hint {
    color: var(--hp-muted);
    font-size: 0.78rem;
    line-height: 1.35;
}

.hp-panel :deep(.v-expansion-panel-text__wrapper) {
    padding: 0 18px 18px 59px;
}

.hp-body {
    color: var(--hp-muted);
    line-height: 1.65;
}

.hp-body :deep(b) {
    color: var(--hp-ink);
}

.hp-actions {
    display: flex;
    justify-content: flex-end;
    margin-top: 14px;
}

/* ---- note cards ---- */
.hp-notes {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(275px, 1fr));
    gap: 12px;
}

.hp-note {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 16px;
    border: 1px solid var(--hp-border);
    border-radius: 14px;
    background: var(--hp-card);
    text-align: left;
    cursor: pointer;
    transition: transform 0.18s ease, border-color 0.18s ease, box-shadow 0.18s ease;
}

.hp-note:hover {
    transform: translateY(-2px);
    border-color: rgba(191, 54, 12, 0.4);
    box-shadow: 0 18px 34px -24px rgba(191, 54, 12, 0.7);
}

.hp-note-ico {
    display: grid;
    place-items: center;
    flex: 0 0 auto;
    width: 42px;
    height: 42px;
    border-radius: 13px;
    color: #fff;
    background: linear-gradient(135deg, #bf360c, #f97316);
    box-shadow: 0 10px 20px -12px rgba(191, 54, 12, 0.8);
}

.hp-note-text {
    display: flex;
    flex-direction: column;
    flex: 1 1 auto;
    min-width: 0;
}

.hp-note-title {
    color: var(--hp-ink);
    font-size: 0.9rem;
    font-weight: 750;
    line-height: 1.3;
}

.hp-note-hint {
    color: var(--hp-muted);
    font-size: 0.78rem;
    line-height: 1.35;
}

.hp-note-arrow {
    flex: 0 0 auto;
    color: var(--hp-muted);
    transition: color 0.18s ease, transform 0.18s ease;
}

.hp-note:hover .hp-note-arrow {
    color: #bf360c;
    transform: translate(2px, -2px);
}

/* ---- dialog ---- */
.hp-dialog {
    overflow: hidden;
}

.hp-dialog-head {
    display: flex;
    align-items: center;
    padding: 18px 20px;
    background: linear-gradient(135deg, #f8fafc, #eef4ff);
}

html.dark .hp-dialog-head {
    background: linear-gradient(135deg, #1e1e2e, #232b45);
}

/* ---- page foot ---- */
.help-foot {
    margin-top: 8px;
    margin-bottom: -24px;
    padding: 16px 24px;
    min-height: 50px;
    background: #1a1f2b;
}

@media (max-width: 700px) {
    .hp-hero {
        padding: 34px 20px 24px;
        border-radius: 16px;
    }

    .hp-panel :deep(.v-expansion-panel-text__wrapper) {
        padding-left: 18px;
    }

    .hp-empty {
        flex-wrap: wrap;
    }
}

@media (prefers-reduced-motion: reduce) {
    .hp-panel,
    .hp-note,
    .hp-jump,
    .hp-note-arrow {
        transition: none;
    }
}
</style>
