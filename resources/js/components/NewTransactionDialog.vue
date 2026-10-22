<template>
  <Teleport to="body">
    <div class="ntx-scrim" :class="{ show: modelValue }" @mousedown.self="close">
      <div ref="dlgRef" class="ntx-dlg" role="dialog" aria-modal="true" aria-labelledby="ntx-title">
        <div class="ntx-hd">
          <div class="ntx-badge">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z" />
              <path d="M14 3v5h5M12 11v6M9 14h6" />
            </svg>
          </div>
          <div>
            <h2 id="ntx-title">New Transaction</h2>
            <p>Choose a type to start a new request.</p>
          </div>
          <button class="ntx-x" type="button" aria-label="Close" @click="close">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round">
              <path d="M6 6l12 12M18 6 6 18" />
            </svg>
          </button>
        </div>

        <form class="ntx-bd" novalidate @submit.prevent="submit">
          <div class="ntx-f" :class="{ bad: typeBad }">
            <label for="ntx-type">Transaction type <span class="ntx-req">*</span></label>
            <div class="ntx-sl">
              <select
                id="ntx-type"
                ref="typeRef"
                v-model="typeId"
                class="ntx-in"
                :aria-invalid="typeBad ? 'true' : 'false'"
                @change="typeBad = false"
              >
                <option value="">Select a transaction type</option>
                <option v-for="t in typeOptions" :key="t.id" :value="t.id">{{ t.label }}</option>
              </select>
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                <path d="m6 9 6 6 6-6" />
              </svg>
            </div>
            <div class="ntx-em">Choose a transaction type.</div>
          </div>

          <div class="ntx-flow" :class="{ show: flowSteps.length }" aria-live="polite">
            <h4>Steps this transaction will follow <span>{{ flowSteps.length }} steps</span></h4>
            <div>
              <div v-for="(s, i) in flowSteps" :key="s.id || i" class="ntx-st">
                <span class="ntx-n">{{ i + 1 }}</span>
                <div>
                  <b>{{ s.name || s.code || 'Untitled step' }}</b>
                  <small v-if="officeLabel(s)">{{ officeLabel(s) }}</small>
                </div>
              </div>
            </div>
          </div>

          <div v-if="isSuperadmin" class="ntx-f" :class="{ bad: officeBad }">
            <label for="ntx-off">Originating Office <span class="ntx-req">*</span></label>
            <div class="ntx-sl">
              <select
                id="ntx-off"
                ref="officeRef"
                v-model="officeId"
                class="ntx-in"
                :aria-invalid="officeBad ? 'true' : 'false'"
                @change="officeBad = false"
              >
                <option value="">Select an originating office</option>
                <option v-for="o in officeOptions" :key="o.id" :value="o.id">{{ o.label }}</option>
              </select>
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                <path d="m6 9 6 6 6-6" />
              </svg>
            </div>
            <div class="ntx-em">Choose an originating office.</div>
          </div>

          <div class="ntx-f">
            <label for="ntx-title">
              Title <span class="ntx-opt">(optional)</span>
              <span class="ntx-cnt">{{ title.length }}/100</span>
            </label>
            <input
              id="ntx-title"
              v-model="title"
              class="ntx-in"
              maxlength="100"
              placeholder="e.g. Office supplies for Q4"
              autocomplete="off"
            >
            <div class="ntx-help">A short label to help you find this transaction later.</div>
          </div>

          <div class="ntx-info">
            <svg viewBox="0 0 24 24" fill="currentColor">
              <path d="M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20zm1 15h-2v-6h2zm0-8h-2V7h2z" />
            </svg>
            <span>Transaction will follow the <b>current steps</b> for the chosen type.</span>
          </div>

          <div v-if="error" class="ntx-alert">{{ error }}</div>
        </form>

        <div class="ntx-ftr">
          <button class="ntx-b ntx-ghost" type="button" :disabled="saving" @click="close">Cancel</button>
          <button class="ntx-b ntx-pri" type="button" :disabled="saving" @click="submit">
            {{ saving ? 'Creating…' : 'Create transaction' }}
          </button>
        </div>
      </div>
    </div>
  </Teleport>
</template>

<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'

const props = defineProps({
  modelValue: { type: Boolean, default: false },
  // [{ id, label, workflow_steps: [{ id, name, code, office: { code, name } | null }] }]
  typeOptions: { type: Array, default: () => [] },
  officeOptions: { type: Array, default: () => [] },
  isSuperadmin: { type: Boolean, default: false },
  saving: { type: Boolean, default: false },
  error: { type: String, default: '' },
})

const emit = defineEmits(['update:modelValue', 'submit'])

const dlgRef = ref(null)
const typeRef = ref(null)
const officeRef = ref(null)
const typeId = ref('')
const officeId = ref('')
const title = ref('')
const typeBad = ref(false)
const officeBad = ref(false)

// Steps of the selected type — supplied by the transaction-types lookup
// (liveWorkflow.steps), so the preview needs no extra request.
const flowSteps = computed(() => {
  const match = (props.typeOptions || []).find((t) => Number(t.id) === Number(typeId.value))
  return (match && match.workflow_steps) || []
})

function officeLabel(step) {
  // Blank and end-user stations both follow the transaction's Originating
  // Office. Show the actual office when the type preview pins one.
  if (step?.is_end_user) return "User's Office"
  return step?.office?.code || step?.office?.name || "User's Office"
}

function reset() {
  typeId.value = ''
  officeId.value = ''
  title.value = ''
  typeBad.value = false
  officeBad.value = false
}

function close() {
  emit('update:modelValue', false)
}

function submit() {
  const typeMissing = typeId.value === '' || typeId.value === null
  const officeMissing =
    props.isSuperadmin && (officeId.value === '' || officeId.value === null)

  typeBad.value = typeMissing
  officeBad.value = officeMissing
  if (typeMissing || officeMissing) {
    nextTick(() => {
      try {
        if (typeMissing) typeRef.value?.focus()
        else officeRef.value?.focus()
      } catch {
        /* ignore */
      }
    })
    return
  }

  emit('submit', {
    transaction_type_id: typeId.value,
    office_id: props.isSuperadmin ? officeId.value : undefined,
    title: title.value.trim() ? title.value.trim() : null,
  })
}

function onKeydown(e) {
  if (!props.modelValue) return
  if (e.key === 'Escape') {
    e.preventDefault()
    close()
    return
  }
  if (e.key !== 'Tab') return
  const dlg = dlgRef.value
  if (!dlg) return
  const els = [...dlg.querySelectorAll('button, input, select')].filter(
    (el) => el.offsetParent !== null && !el.disabled
  )
  if (!els.length) return
  const first = els[0]
  const last = els[els.length - 1]
  if (e.shiftKey && document.activeElement === first) {
    e.preventDefault()
    last.focus()
  } else if (!e.shiftKey && document.activeElement === last) {
    e.preventDefault()
    first.focus()
  }
}

watch(
  () => props.modelValue,
  (open) => {
    if (!open) return
    reset()
    nextTick(() => {
      try {
        typeRef.value?.focus()
      } catch {
        /* ignore */
      }
    })
  }
)

// The type-office allowlist governs who can create; the first station no
// longer restricts the Originating Office. Superadmins keep the full list.
watch(typeId, () => {
  typeBad.value = false
  if (!props.isSuperadmin) return
  const valid = (props.officeOptions || []).some(
    (o) => Number(o.id) === Number(officeId.value)
  )
  if (!valid) officeId.value = ''
})

onMounted(() => document.addEventListener('keydown', onKeydown, true))
onBeforeUnmount(() => document.removeEventListener('keydown', onKeydown, true))
</script>

<style scoped>
.ntx-scrim {
  --ntx-panel: #fff;
  --ntx-ink: #14213d;
  --ntx-muted: #5b6780;
  --ntx-line: #d5dbe8;
  --ntx-field: #f4f6fb;
  --ntx-hover: #f3f6fc;
  --ntx-blue: #1d3fae;
  --ntx-blue-d: #142d82;
  --ntx-blue-bg: #e8eeff;
  --ntx-err: #c62828;
  --ntx-info-bg: #eef3ff;
  --ntx-ring: rgba(29, 63, 174, 0.28);
  --ntx-scrim: rgba(14, 22, 48, 0.5);
  color-scheme: light;
  position: fixed;
  inset: 0;
  background: var(--ntx-scrim);
  display: grid;
  place-items: center;
  padding: 20px;
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.2s, visibility 0s 0.2s;
  z-index: 3000;
}
.ntx-scrim.show {
  opacity: 1;
  visibility: visible;
  transition: opacity 0.2s;
}
@media (prefers-color-scheme: dark) {
  .ntx-scrim {
    --ntx-panel: #161e36;
    --ntx-ink: #eef2fb;
    --ntx-muted: #9aa7c4;
    --ntx-line: #2b3558;
    --ntx-field: #1c2645;
    --ntx-hover: #1d2745;
    --ntx-blue: #6f8cff;
    --ntx-blue-d: #8aa1ff;
    --ntx-blue-bg: #25306a;
    --ntx-err: #ff8a80;
    --ntx-info-bg: #1b2548;
    --ntx-ring: rgba(138, 161, 255, 0.38);
    --ntx-scrim: rgba(0, 0, 0, 0.62);
    color-scheme: dark;
  }
}

.ntx-scrim :focus-visible {
  outline: 3px solid var(--ntx-ring);
  outline-offset: 2px;
}

.ntx-dlg {
  width: 100%;
  max-width: 540px;
  max-height: 100%;
  display: flex;
  flex-direction: column;
  background: var(--ntx-panel);
  color: var(--ntx-ink);
  border-radius: 24px;
  box-shadow: 0 30px 70px -20px rgba(0, 0, 0, 0.5);
  transform: translateY(14px) scale(0.98);
  transition: transform 0.22s;
  font-family: 'Inter', 'Public Sans', system-ui, -apple-system, 'Segoe UI', sans-serif;
}
.ntx-scrim.show .ntx-dlg {
  transform: none;
}

.ntx-hd {
  display: flex;
  align-items: flex-start;
  gap: 14px;
  padding: 22px 24px 14px;
}
.ntx-badge {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  background: var(--ntx-blue-bg);
  color: var(--ntx-blue);
  display: grid;
  place-items: center;
  flex: none;
}
.ntx-badge svg {
  width: 22px;
  height: 22px;
}
.ntx-hd h2 {
  margin: 0;
  font-size: 20px;
  font-weight: 800;
  letter-spacing: -0.01em;
}
.ntx-hd p {
  margin: 3px 0 0;
  font-size: 14px;
  color: var(--ntx-muted);
}
.ntx-x {
  margin-left: auto;
  width: 36px;
  height: 36px;
  border: 0;
  border-radius: 10px;
  background: none;
  color: var(--ntx-muted);
  display: grid;
  place-items: center;
  flex: none;
  cursor: pointer;
}
.ntx-x:hover {
  background: var(--ntx-hover);
}
.ntx-x svg {
  width: 20px;
  height: 20px;
}

.ntx-bd {
  padding: 4px 24px 10px;
  overflow: auto;
}

.ntx-f {
  position: relative;
  margin-bottom: 18px;
}
.ntx-f label {
  display: block;
  font-size: 14px;
  font-weight: 600;
  margin-bottom: 7px;
}
.ntx-req {
  color: var(--ntx-err);
}
.ntx-opt {
  color: var(--ntx-muted);
  font-weight: 500;
}
.ntx-in {
  width: 100%;
  height: 48px;
  border: 1.5px solid var(--ntx-line);
  border-radius: 12px;
  background: var(--ntx-field);
  color: var(--ntx-ink);
  font: inherit;
  font-size: 15.5px;
  padding: 0 14px;
  transition: border-color 0.15s, box-shadow 0.15s, background 0.15s;
  box-sizing: border-box;
}
select.ntx-in {
  appearance: none;
  -webkit-appearance: none;
  padding-right: 42px;
  cursor: pointer;
}
.ntx-in::placeholder {
  color: #7b869e;
}
.ntx-in:hover {
  border-color: #aab4cc;
}
.ntx-in:focus {
  outline: none;
  border-color: var(--ntx-blue);
  background: var(--ntx-panel);
  box-shadow: 0 0 0 4px var(--ntx-ring);
}
.ntx-in[aria-invalid='true'] {
  border-color: var(--ntx-err);
}
.ntx-sl {
  position: relative;
}
.ntx-sl svg {
  position: absolute;
  right: 13px;
  top: 50%;
  width: 20px;
  height: 20px;
  transform: translateY(-50%);
  color: var(--ntx-muted);
  pointer-events: none;
}
.ntx-help {
  margin: 6px 2px 0;
  font-size: 12.5px;
  color: var(--ntx-muted);
}
.ntx-em {
  display: none;
  margin: 6px 2px 0;
  font-size: 12.5px;
  color: var(--ntx-err);
  font-weight: 600;
}
.ntx-f.bad .ntx-em {
  display: block;
}
.ntx-f.bad .ntx-help {
  display: none;
}

/* flow preview */
.ntx-flow {
  display: none;
  border: 1.5px solid var(--ntx-line);
  border-radius: 16px;
  padding: 14px 16px;
  margin-bottom: 14px;
  animation: ntx-in 0.25s ease-out;
}
.ntx-flow.show {
  display: block;
}
@keyframes ntx-in {
  from {
    opacity: 0;
    transform: translateY(-6px);
  }
  to {
    opacity: 1;
    transform: none;
  }
}
.ntx-flow h4 {
  margin: 0 0 12px;
  font-size: 13px;
  font-weight: 700;
  color: var(--ntx-muted);
  display: flex;
  justify-content: space-between;
}
.ntx-flow h4 span {
  color: var(--ntx-blue);
}
.ntx-st {
  display: flex;
  gap: 12px;
  position: relative;
  padding-bottom: 12px;
}
.ntx-st:last-child {
  padding-bottom: 0;
}
.ntx-st::before {
  content: '';
  position: absolute;
  left: 11px;
  top: 24px;
  bottom: 0;
  width: 2px;
  background: var(--ntx-line);
}
.ntx-st:last-child::before {
  display: none;
}
.ntx-n {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: var(--ntx-blue-bg);
  color: var(--ntx-blue);
  font-size: 12px;
  font-weight: 800;
  display: grid;
  place-items: center;
  flex: none;
  z-index: 1;
}
.ntx-st:first-child .ntx-n {
  background: var(--ntx-blue);
  color: #fff;
}
.ntx-st b {
  font-size: 14px;
  line-height: 24px;
  font-weight: 600;
}
.ntx-st small {
  margin-left: 8px;
  font-size: 12px;
  color: var(--ntx-muted);
  font-weight: 500;
}

.ntx-info {
  display: flex;
  gap: 12px;
  align-items: center;
  background: var(--ntx-info-bg);
  border-radius: 12px;
  padding: 12px 14px;
  font-size: 13.5px;
  color: var(--ntx-ink);
  line-height: 1.45;
  margin-bottom: 6px;
}
.ntx-info svg {
  width: 20px;
  height: 20px;
  color: var(--ntx-blue);
  flex: none;
}
.ntx-info b {
  color: var(--ntx-blue);
}
.ntx-alert {
  margin: 10px 0 4px;
  padding: 10px 12px;
  border-radius: 10px;
  background: rgba(198, 40, 40, 0.1);
  color: var(--ntx-err);
  font-size: 13px;
  font-weight: 600;
}
.ntx-cnt {
  float: right;
  font-weight: 500;
  color: var(--ntx-muted);
  font-size: 12px;
}

.ntx-ftr {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 16px 24px 20px;
  border-top: 1px solid var(--ntx-line);
}
.ntx-b {
  height: 46px;
  border-radius: 12px;
  padding: 0 22px;
  font-weight: 700;
  border: 1.5px solid transparent;
  font-family: inherit;
  font-size: 15px;
  cursor: pointer;
}
.ntx-b:disabled {
  opacity: 0.6;
  cursor: default;
}
.ntx-b.ntx-ghost {
  background: none;
  border-color: var(--ntx-line);
  color: var(--ntx-ink);
}
.ntx-b.ntx-ghost:hover:not(:disabled) {
  background: var(--ntx-hover);
}
.ntx-b.ntx-pri {
  background: var(--ntx-blue);
  color: #fff;
  min-width: 150px;
}
.ntx-b.ntx-pri:hover:not(:disabled) {
  background: var(--ntx-blue-d);
}

@media (max-width: 520px) {
  .ntx-ftr {
    flex-direction: column-reverse;
  }
  .ntx-b {
    width: 100%;
  }
  .ntx-scrim {
    align-items: end;
    padding: 0;
  }
  .ntx-dlg {
    border-radius: 24px 24px 0 0;
    max-height: 94%;
  }
}
@media (prefers-reduced-motion: reduce) {
  .ntx-scrim,
  .ntx-dlg,
  .ntx-flow {
    transition: none !important;
    animation: none !important;
  }
}
</style>
