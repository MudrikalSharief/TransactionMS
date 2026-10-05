<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card mb-4">
            <v-card-title class="d-flex align-center pa-5 lgu-head">
                <v-avatar color="white" rounded="0" size="40" class="mr-3 lgu-head-avatar">
                    <v-icon color="#1E40AF">mdi-help-circle-outline</v-icon>
                </v-avatar>
                <div>
                    <span class="text-h6 font-weight-bold">Help &amp; Manual</span>
                    <div class="text-caption text-medium-emphasis font-weight-bold">
                        Search or press a panel to read it
                    </div>
                </div>
                <v-spacer />
                <v-text-field
                    v-model="query"
                    prepend-inner-icon="mdi-magnify"
                    label="Search help..."
                    variant="outlined"
                    density="compact"
                    rounded="0"
                    hide-details
                    clearable
                    style="max-width: 320px"
                />
            </v-card-title>
        </v-card>

        <!-- Doing your work -->
        <div v-if="filteredUser.length" class="text-subtitle-1 font-weight-bold mb-2 d-flex align-center">
            <v-avatar color="#1E40AF" rounded="0" size="28" class="mr-2">
                <v-icon color="white" size="18">mdi-account-check-outline</v-icon>
            </v-avatar>
            Doing your work
        </div>
        <v-expansion-panels v-if="filteredUser.length" v-model="open" multiple class="mb-5">
            <v-expansion-panel
                v-for="item in filteredUser"
                :key="'user-' + item.i"
                :value="'user-' + item.i"
                rounded="0"
                class="help-entry"
            >
                <v-expansion-panel-title>
                    <div class="d-flex align-center ga-3" style="min-width: 0; flex: 1 1 auto">
                        <span class="help-num flex-shrink-0">{{ item.i + 1 }}</span>
                        <v-avatar rounded="0" size="32" class="flex-shrink-0 help-ico">
                            <v-icon color="#1E40AF" size="18">{{ item.s.icon }}</v-icon>
                        </v-avatar>
                        <div style="min-width: 0">
                            <div class="font-weight-bold">{{ item.s.title }}</div>
                            <div class="text-caption text-medium-emphasis">{{ item.s.hint }}</div>
                        </div>
                    </div>
                </v-expansion-panel-title>
                <v-expansion-panel-text>
                    <div class="text-body-2" v-html="item.s.text" />
                    <div v-if="item.s.to" class="d-flex justify-end mt-3">
                        <v-btn color="primary" rounded="0" :to="item.s.to" append-icon="mdi-arrow-right">Open page</v-btn>
                    </div>
                </v-expansion-panel-text>
            </v-expansion-panel>
        </v-expansion-panels>

        <!-- Admin setup -->
        <template v-if="isSuperadmin">
            <div v-if="filteredAdmin.length" class="text-subtitle-1 font-weight-bold mb-2 d-flex align-center">
                <v-avatar color="#1E40AF" rounded="0" size="28" class="mr-2">
                    <v-icon color="white" size="18">mdi-cog-outline</v-icon>
                </v-avatar>
                Setting the system up
            </div>
            <v-expansion-panels v-if="filteredAdmin.length" v-model="open" multiple class="mb-5">
                <v-expansion-panel
                    v-for="item in filteredAdmin"
                    :key="'admin-' + item.i"
                    :value="'admin-' + item.i"
                    rounded="0"
                    class="help-entry"
                >
                    <v-expansion-panel-title>
                        <div class="d-flex align-center ga-3" style="min-width: 0; flex: 1 1 auto">
                            <span class="help-num flex-shrink-0">{{ item.i + 1 }}</span>
                            <v-avatar rounded="0" size="32" class="flex-shrink-0 help-ico">
                                <v-icon color="#1E40AF" size="18">{{ item.s.icon }}</v-icon>
                            </v-avatar>
                            <div style="min-width: 0">
                                <div class="font-weight-bold">{{ item.s.title }}</div>
                                <div class="text-caption text-medium-emphasis">{{ item.s.hint }}</div>
                            </div>
                        </div>
                    </v-expansion-panel-title>
                    <v-expansion-panel-text>
                        <div class="text-body-2" v-html="item.s.text" />
                        <div v-if="item.s.to" class="d-flex justify-end mt-3">
                            <v-btn color="primary" rounded="0" :to="item.s.to" append-icon="mdi-arrow-right">Open page</v-btn>
                        </div>
                    </v-expansion-panel-text>
                </v-expansion-panel>
            </v-expansion-panels>
        </template>

        <!-- Stations & routes + notes -->
        <div v-if="showStations || filteredNotes.length" class="text-subtitle-1 font-weight-bold mb-2 d-flex align-center">
            <v-avatar color="#1E40AF" rounded="0" size="28" class="mr-2">
                <v-icon color="white" size="18">mdi-source-branch</v-icon>
            </v-avatar>
            Stations, routes &amp; notes
        </div>
        <v-expansion-panels v-model="open" multiple class="mb-6">
            <v-expansion-panel v-if="showStations" value="stations" rounded="0" class="help-entry">
                <v-expansion-panel-title>
                    <div class="d-flex align-center ga-3" style="min-width: 0; flex: 1 1 auto">
                        <v-avatar rounded="0" size="32" class="flex-shrink-0 help-ico">
                            <v-icon color="#1E40AF" size="18">mdi-source-branch</v-icon>
                        </v-avatar>
                        <div style="min-width: 0">
                            <div class="font-weight-bold">Transaction Steps &amp; Routes</div>
                            <div class="text-caption text-medium-emphasis">Stations are steps · arrows are routes · Procurement 14-station example</div>
                        </div>
                    </div>
                </v-expansion-panel-title>
                <v-expansion-panel-text>
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
                        <v-btn color="primary" rounded="0" to="/admin/transaction-types" append-icon="mdi-arrow-right">Open page</v-btn>
                    </div>
                </v-expansion-panel-text>
            </v-expansion-panel>
            <v-expansion-panel
                v-for="item in filteredNotes"
                :key="'note-' + item.i"
                :value="'note-' + item.i"
                rounded="0"
                class="help-entry"
            >
                <v-expansion-panel-title>
                    <div class="d-flex align-center ga-3" style="min-width: 0; flex: 1 1 auto">
                        <v-avatar rounded="0" size="32" class="flex-shrink-0 help-ico">
                            <v-icon color="#1E40AF" size="18">{{ item.n.icon }}</v-icon>
                        </v-avatar>
                        <div style="min-width: 0">
                            <div class="font-weight-bold">{{ item.n.title }}</div>
                            <div class="text-caption text-medium-emphasis">{{ item.n.hint }}</div>
                        </div>
                    </div>
                </v-expansion-panel-title>
                <v-expansion-panel-text>
                    <div class="text-body-2" v-html="item.n.body" />
                </v-expansion-panel-text>
            </v-expansion-panel>
        </v-expansion-panels>
        <v-alert v-if="query.trim() && !anyVisible" type="info" variant="tonal" class="mb-4">
            No help topics match "{{ query.trim() }}".
            <v-btn variant="text" color="primary" @click="query = ''">Clear search</v-btn>
        </v-alert>
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
            icon: 'mdi-file-document-multiple',
            title: 'My Transactions',
            hint: 'Your personal queue by role',
            text: 'This is your personal queue — only requests waiting on your role appear here.',
            to: '/my/transactions',
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
/* Blank dark footer container (no text): flushes to the page bottom. */
.help-foot {
    background: #1E3A8A;
    padding: 16px 24px;
    margin-top: 8px;
    margin-bottom: -24px;
    min-height: 50px;
}
/* Modern entries: hairline card, blue number badge, soft icon tile.
   Open entries lift with a blue edge + shadow. */
.help-entry {
    border: 1px solid #e2e8f0 !important;
}
.help-entry.v-expansion-panel--active {
    border-color: #1E40AF !important;
    box-shadow: 0 10px 24px -12px rgba(30, 64, 175, 0.35) !important;
}
.help-num {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 28px;
    height: 28px;
    padding: 0 6px;
    background: #1E40AF;
    color: #ffffff;
    font-weight: 800;
    font-size: 0.8rem;
}
.help-ico {
    background: rgba(30, 64, 175, 0.1);
}
html.dark .help-entry {
    border-color: #334155 !important;
}
html.dark .help-ico {
    background: rgba(147, 197, 253, 0.14);
}
html.dark .help-ico .v-icon {
    color: #93C5FD !important;
}
</style>
