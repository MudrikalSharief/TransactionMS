<template>
    <div>
        <v-card rounded="0" elevation="1" class="lgu-card mb-4">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar color="grey-darken-3" rounded="0" size="40" class="mr-3">
                    <v-icon color="white">mdi-help-circle-outline</v-icon>
                </v-avatar>
                <div>
                    <span class="text-h6 font-weight-bold">Help &amp; Manual</span>
                    <div class="text-caption text-medium-emphasis font-weight-bold">
                        Press a panel to open its window
                    </div>
                </div>
            </v-card-title>
        </v-card>

        <!-- Doing your work -->
        <div class="text-subtitle-1 font-weight-bold mb-2 d-flex align-center">
            <v-avatar color="#1565C0" rounded="0" size="28" class="mr-2">
                <v-icon color="white" size="18">mdi-account-check-outline</v-icon>
            </v-avatar>
            Doing your work
        </div>
        <v-row class="mb-5">
            <v-col v-for="(s, i) in userSteps" :key="'u'+i" cols="12" sm="6" md="4">
                <v-card rounded="0" elevation="1" class="lgu-card help-panel" @click="openWindow('user-'+i)">
                    <v-card-text class="d-flex align-center pa-4">
                        <v-avatar color="#1565C0" rounded="0" size="40" class="mr-3">
                            <v-icon color="white">{{ s.icon }}</v-icon>
                        </v-avatar>
                        <div class="flex-grow-1">
                            <div class="font-weight-bold">{{ i + 1 }}. {{ s.title }}</div>
                            <div class="text-caption text-medium-emphasis help-hint">{{ s.hint }}</div>
                        </div>
                        <v-icon color="grey-darken-3">mdi-chevron-right</v-icon>
                    </v-card-text>
                </v-card>
            </v-col>
        </v-row>

        <!-- Admin setup -->
        <template v-if="isSuperadmin">
            <div class="text-subtitle-1 font-weight-bold mb-2 d-flex align-center">
                <v-avatar color="#2E7D32" rounded="0" size="28" class="mr-2">
                    <v-icon color="white" size="18">mdi-cog-outline</v-icon>
                </v-avatar>
                Setting the system up
            </div>
            <v-row class="mb-5">
                <v-col v-for="(s, i) in adminSteps" :key="'a'+i" cols="12" sm="6" md="4">
                    <v-card rounded="0" elevation="1" class="lgu-card help-panel" @click="openWindow('admin-'+i)">
                        <v-card-text class="d-flex align-center pa-4">
                            <v-avatar color="#2E7D32" rounded="0" size="40" class="mr-3">
                                <v-icon color="white">{{ s.icon }}</v-icon>
                            </v-avatar>
                            <div class="flex-grow-1">
                                <div class="font-weight-bold">{{ i + 1 }}. {{ s.title }}</div>
                                <div class="text-caption text-medium-emphasis help-hint">{{ s.hint }}</div>
                            </div>
                            <v-icon color="grey-darken-3">mdi-chevron-right</v-icon>
                        </v-card-text>
                    </v-card>
                </v-col>
            </v-row>
        </template>

        <!-- Stations & routes + notes -->
        <div class="text-subtitle-1 font-weight-bold mb-2 d-flex align-center">
            <v-avatar color="#6A1B9A" rounded="0" size="28" class="mr-2">
                <v-icon color="white" size="18">mdi-source-branch</v-icon>
            </v-avatar>
            Stations, routes &amp; notes
        </div>
        <v-row class="mb-2">
            <v-col cols="12" md="6">
                <v-card rounded="0" elevation="1" class="lgu-card help-panel" @click="openWindow('stations')">
                    <v-card-text class="d-flex align-center pa-4">
                        <v-avatar color="#6A1B9A" rounded="0" size="40" class="mr-3">
                            <v-icon color="white">mdi-source-branch</v-icon>
                        </v-avatar>
                        <div class="flex-grow-1">
                            <div class="font-weight-bold">Transaction Steps &amp; Routes</div>
                            <div class="text-caption text-medium-emphasis help-hint">Stations are steps · arrows are routes · Procurement 14-station example</div>
                        </div>
                        <v-icon color="grey-darken-3">mdi-chevron-right</v-icon>
                    </v-card-text>
                </v-card>
            </v-col>
            <v-col v-for="(n, i) in notes" :key="'n'+i" cols="12" md="6">
                <v-card rounded="0" elevation="1" class="lgu-card help-panel" @click="openWindow('note-'+i)">
                    <v-card-text class="d-flex align-center pa-4">
                        <v-avatar color="#BF360C" rounded="0" size="40" class="mr-3">
                            <v-icon color="white">{{ n.icon }}</v-icon>
                        </v-avatar>
                        <div class="flex-grow-1">
                            <div class="font-weight-bold">{{ n.title }}</div>
                            <div class="text-caption text-medium-emphasis help-hint">{{ n.hint }}</div>
                        </div>
                        <v-icon color="grey-darken-3">mdi-chevron-right</v-icon>
                    </v-card-text>
                </v-card>
            </v-col>
        </v-row>
    </div>

    <!-- Window dialog -->
    <v-dialog v-model="windowOpen" max-width="800">
        <v-card v-if="activeContent" rounded="0">
            <v-card-title class="d-flex align-center pa-5">
                <v-avatar :color="activeContent.color" rounded="0" size="40" class="mr-3">
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
                </div>
                <div v-else class="text-body-2" v-html="activeContent.body" />
                <v-alert v-if="activeContent.note" type="info" variant="tonal" class="mt-4">
                    {{ activeContent.note }}
                </v-alert>
            </v-card-text>
            <v-divider />
            <v-card-actions class="justify-end pa-4">
                <v-btn variant="text" @click="windowOpen = false">Close</v-btn>
                <v-btn
                    v-if="activeContent.to"
                    color="grey-darken-3"
                    rounded="0"
                    :to="activeContent.to"
                    @click="windowOpen = false"
                >
                    Open page
                    <v-icon end size="small">mdi-arrow-right</v-icon>
                </v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useAuth } from '@/composables/useAuth'

const auth = useAuth()

const isSuperadmin = computed(() => {
    const roles = auth.user.value?.roles ?? []
    return roles.some((r) => r.code === 'superadmin')
})

const windowOpen = ref(false)
const activeKey = ref(null)

function openWindow(key) {
    activeKey.value = key
    windowOpen.value = true
}

const userSteps = [
    {
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
]

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
        title: 'Processes',
        hint: 'Kinds of requests',
        text: 'Define the kinds of requests (e.g. Communication). Each process gets its own steps.',
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
        text: 'Open a Process → Steps → edit the steps → Save goes live for new transactions. Steps need at least one start and one end.',
        to: '/admin/transaction-types',
    },
    {
        icon: 'mdi-bank',
        title: 'Gov References',
        hint: 'RA, IRR, COA citations',
        text: 'Attach the governing references (RA, IRR, COA…) so the process cites its legal basis.',
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
        body: 'Each transaction stays on the process it started with. Saves go live for <b>new transactions only</b>.',
    },
    {
        icon: 'mdi-undo-variant',
        title: 'What is a return?',
        hint: 'Backward hop for correction',
        body: 'A <b>return route</b> sends work backward (e.g. Station 2 → Station 1) for correction — that is normal, not an error.',
    },
]

const activeContent = computed(() => {
    if (!activeKey.value) return null
    const [group, idx] = activeKey.value.split('-')
    if (group === 'user') {
        const s = userSteps[Number(idx)]
        return { ...s, body: s.text, color: '#1565C0', note: null }
    }
    if (group === 'admin') {
        const s = adminSteps[Number(idx)]
        return { ...s, body: s.text, color: '#2E7D32', note: null }
    }
    if (group === 'note') {
        const n = notes[Number(idx)]
        return { ...n, to: null, color: '#BF360C', note: null }
    }
    if (group === 'stations') {
        return { title: 'Transaction Steps & Routes', icon: 'mdi-source-branch', color: '#6A1B9A', to: '/admin/transaction-types', body: '', note: 'Stations are steps · arrows are routes · example: Procurement (14 stations).' }
    }
    return null
})
</script>

<style scoped>
.help-panel {
    cursor: pointer;
    transition: transform 0.15s ease, box-shadow 0.15s ease;
}
.help-panel:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 14px rgba(0, 0, 0, 0.12);
}
.help-hint {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
</style>
