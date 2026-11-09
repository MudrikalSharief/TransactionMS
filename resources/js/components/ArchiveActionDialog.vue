<template>
  <v-dialog
    :model-value="open"
    :max-width="isArchive ? 480 : 440"
    @update:model-value="(v) => emit('update:open', v)"
  >
    <v-card class="aa-card" rounded="xl">
      <div class="aa-body">
        <div
          class="aa-badge"
          :class="isArchive ? 'aa-badge--archive' : 'aa-badge--unarchive'"
          aria-hidden="true"
        >
          <v-icon size="24">
            {{ isArchive ? 'mdi-archive-outline' : 'mdi-archive-arrow-up-outline' }}
          </v-icon>
        </div>

        <h2 class="aa-title">
          {{ isArchive ? 'Archive transaction?' : 'Unarchive transaction?' }}
        </h2>
        <p class="aa-lead">
          <template v-if="isArchive">
            Move <span class="aa-code">{{ code }}</span> out of the active
            Transactions list and into the Archive.
          </template>
          <template v-else>
            Bring <span class="aa-code">{{ code }}</span> back to the active
            Transactions list.
          </template>
        </p>

        <template v-if="isArchive">
          <div v-if="!isDone" class="aa-warning" role="note">
            <v-icon size="20" color="warning">mdi-alert-outline</v-icon>
            <span>
              <b>This transaction is still in process.</b>
              Archiving stops all workflow actions until you restore it.
            </span>
          </div>

          <section class="aa-section">
            <h3>What changes</h3>
            <ul class="aa-list aa-list--change">
              <li>
                <v-icon size="18" color="warning">mdi-arrow-right</v-icon>
                <span>It leaves the active Transactions list and moves to <b>Archive</b>.</span>
              </li>
              <li>
                <v-icon size="18" color="warning">mdi-pause</v-icon>
                <span>Workflow actions are <b>paused</b> until it is restored.</span>
              </li>
            </ul>
          </section>

          <section class="aa-section">
            <h3>What stays safe</h3>
            <ul class="aa-list aa-list--safe">
              <li>
                <v-icon size="18" color="success">mdi-check-circle-outline</v-icon>
                <span><b>Nothing is deleted.</b> The transaction, its attachments and its full workflow history stay in the system.</span>
              </li>
              <li>
                <v-icon size="18" color="success">mdi-check-circle-outline</v-icon>
                <span><b>You can restore it any time</b> with Unarchive.</span>
              </li>
            </ul>
          </section>
        </template>

        <ul v-else class="aa-list aa-list--safe aa-list--unarchive" aria-label="What happens">
          <li>
            <v-icon size="18" color="success">mdi-check-circle-outline</v-icon>
            <span><b>Nothing is lost.</b> Its status, attachments and workflow history stay the same.</span>
          </li>
          <li>
            <v-icon size="18" color="success">mdi-check-circle-outline</v-icon>
            <span><b>It can be worked on again.</b> It becomes actionable as soon as you confirm.</span>
          </li>
        </ul>
      </div>

      <div class="aa-footer">
        <button
          type="button"
          class="aa-btn aa-btn--ghost"
          :disabled="saving"
          @click="emit('update:open', false)"
        >
          Cancel
        </button>
        <button
          type="button"
          class="aa-btn aa-btn--primary"
          :class="isArchive ? 'aa-btn--archive' : 'aa-btn--unarchive'"
          :disabled="saving"
          :aria-busy="saving"
          @click="emit('confirm')"
        >
          <v-progress-circular
            v-if="saving"
            indeterminate
            size="17"
            width="2.5"
            class="aa-spin"
            style="color: currentColor"
          />
          <span>{{ saving ? busyLabel : confirmLabel }}</span>
        </button>
      </div>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  open: { type: Boolean, default: false },
  mode: { type: String, default: 'archive' },
  transaction: { type: Object, default: null },
  saving: { type: Boolean, default: false },
})

const emit = defineEmits(['update:open', 'confirm'])

const isArchive = computed(() => props.mode === 'archive')
const isDone = computed(() => !!props.transaction?.is_done)
const code = computed(
  () => props.transaction?.reference_number || `#${props.transaction?.id ?? ''}`,
)
const confirmLabel = computed(() =>
  isArchive.value ? 'Archive transaction' : 'Unarchive transaction',
)
const busyLabel = computed(() => (isArchive.value ? 'Archiving…' : 'Unarchiving…'))
</script>

<style scoped>
.aa-card {
  --aa-ink: rgb(var(--v-theme-on-surface));
  --aa-muted: rgb(var(--v-theme-secondary));
  --aa-line: rgba(var(--v-border-color), var(--v-border-opacity));
  --aa-field: rgba(var(--v-theme-on-surface), 0.045);
  --aa-amber: #9a5b00;
  --aa-amber-bg: #fff4dc;
  --aa-amber-line: #f2c765;
  --aa-amber-solid: #ffb300;
  --aa-amber-solid-dark: #f2a600;
  --aa-amber-ink: #3d2700;
  --aa-blue: rgb(var(--v-theme-primary));
  --aa-blue-ink: rgb(var(--v-theme-on-primary));
  overflow: hidden;
  border-radius: 24px;
  background: rgb(var(--v-theme-surface));
  color: var(--aa-ink);
}

html.dark .aa-card {
  --aa-amber: #ffbf47;
  --aa-amber-bg: #3d2d0e;
  --aa-amber-line: #6b4f17;
  --aa-amber-ink: #2b1c00;
}

.aa-body {
  padding: 24px 24px 6px;
}

.aa-badge {
  width: 48px;
  height: 48px;
  border-radius: 14px;
  display: grid;
  place-items: center;
}

.aa-badge--archive {
  background: var(--aa-amber-bg);
  color: var(--aa-amber);
}

.aa-badge--unarchive {
  background: rgba(var(--v-theme-primary), 0.12);
  color: var(--aa-blue);
}

.aa-title {
  margin: 16px 0 0;
  font-size: 20px;
  font-weight: 800;
  letter-spacing: -0.01em;
  line-height: 1.3;
  color: var(--aa-ink);
}

.aa-lead {
  margin: 8px 0 0;
  font-size: 14.5px;
  line-height: 1.55;
  color: var(--aa-muted);
}

.aa-code {
  display: inline-block;
  font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.02em;
  color: var(--aa-ink);
  background: var(--aa-field);
  border: 1px solid var(--aa-line);
  border-radius: 8px;
  padding: 1px 8px;
  margin: 0 1px;
}

.aa-warning {
  display: flex;
  gap: 12px;
  align-items: flex-start;
  margin-top: 16px;
  padding: 12px 14px;
  border-radius: 14px;
  background: var(--aa-amber-bg);
  border: 1px solid var(--aa-amber-line);
  font-size: 13.5px;
  line-height: 1.5;
  color: var(--aa-ink);
}

.aa-warning :deep(.v-icon) {
  flex: none;
  margin-top: 1px;
  color: var(--aa-amber);
}

.aa-warning b {
  display: block;
  font-weight: 800;
  color: var(--aa-amber);
  margin-bottom: 2px;
}

.aa-section {
  margin-top: 16px;
}

.aa-section h3 {
  margin: 0 0 8px;
  font-size: 11.5px;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--aa-muted);
}

.aa-list {
  list-style: none;
  margin: 0;
  padding: 12px 14px;
  background: var(--aa-field);
  border-radius: 14px;
  display: grid;
  gap: 9px;
}

.aa-list--unarchive {
  margin-top: 16px;
  padding: 14px 16px;
  gap: 10px;
}

.aa-list li {
  display: flex;
  gap: 11px;
  align-items: flex-start;
  font-size: 13.5px;
  line-height: 1.45;
  font-weight: 500;
  color: var(--aa-ink);
}

.aa-list :deep(.v-icon) {
  flex: none;
  margin-top: 1px;
}

.aa-list b {
  font-weight: 700;
}

.aa-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 18px 24px 22px;
}

.aa-btn {
  height: 46px;
  border-radius: 12px;
  padding: 0 22px;
  font: inherit;
  font-size: 14.5px;
  font-weight: 700;
  border: 1.5px solid transparent;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 9px;
  cursor: pointer;
  text-transform: none;
  letter-spacing: normal;
  transition: background 0.15s, border-color 0.15s, filter 0.15s;
}

.aa-btn:disabled {
  cursor: progress;
  opacity: 0.8;
}

.aa-btn--ghost {
  background: transparent;
  border-color: var(--aa-line);
  color: var(--aa-ink);
}

.aa-btn--ghost:hover:not(:disabled) {
  background: var(--aa-field);
}

.aa-btn--primary {
  min-width: 170px;
}

.aa-btn--archive {
  background: var(--aa-amber-solid);
  color: var(--aa-amber-ink);
}

.aa-btn--archive:hover:not(:disabled) {
  background: var(--aa-amber-solid-dark);
}

.aa-btn--unarchive {
  background: var(--aa-blue);
  color: var(--aa-blue-ink);
}

.aa-btn--unarchive:hover:not(:disabled) {
  filter: brightness(0.92);
}

.aa-btn :deep(.v-progress-circular) {
  color: currentColor;
}

@media (max-width: 480px) {
  .aa-body {
    padding: 20px 18px 4px;
  }

  .aa-footer {
    flex-direction: column-reverse;
    padding: 16px 18px 20px;
  }

  .aa-btn {
    width: 100%;
  }
}

@media (prefers-reduced-motion: reduce) {
  .aa-btn {
    transition: none;
  }
}
</style>
