import { computed, onMounted, onUnmounted, ref } from "vue";
import { useApi } from "@/composables/useApi";
import { useSmartPoll } from "@/composables/useSmartPoll";

// How many of a clerk's pending transactions are due, by the same rule as the
// sign-in notice (LoginApprovalNotice): a step's time limit (sla_minutes)
// counts from when the paper reached it (entered_at).
//   past due   the time limit has passed
//   almost due still within it, a quarter or less of the time left
// Steps without a time limit are never due. Read-only; clerks only.
const DUE_SHARE = 0.25;

export function useDueCount({ enabled }) {
    const { api } = useApi();
    const rows = ref([]);
    const loaded = ref(false);
    const now = ref(Date.now());

    async function loadAll() {
        const all = [];
        let page = 1;
        let last = 1;
        do {
            const res = await api.get("/api/approvals", { params: { page, per_page: 100 } });
            all.push(...(res.data?.data ?? []));
            last = res.data?.meta?.last_page ?? 1;
            page += 1;
        } while (page <= last && page <= 10);
        return all;
    }

    async function refresh() {
        if (!enabled.value) return;
        try {
            rows.value = await loadAll();
            now.value = Date.now();
            loaded.value = true;
        } catch {
            /* keep the last numbers; the next poll retries */
        }
    }

    const timed = computed(() =>
        rows.value
            .map((tx) => {
                const sla = Number(tx.current_step?.sla_minutes || 0);
                const entered = Date.parse(tx.entered_at || "");
                if (!sla || !Number.isFinite(entered)) return null;
                return { sla, left: entered + sla * 60000 - now.value };
            })
            .filter(Boolean),
    );
    const pastDue = computed(() => timed.value.filter((d) => d.left < 0).length);
    const almostDue = computed(
        () => timed.value.filter((d) => d.left >= 0 && d.left <= d.sla * 60000 * DUE_SHARE).length,
    );

    // The clock moves on between fetches: a paper can slip past its limit.
    let tick = null;
    onMounted(() => {
        refresh();
        tick = setInterval(() => (now.value = Date.now()), 30000);
    });
    onUnmounted(() => clearInterval(tick));
    useSmartPoll(refresh);

    return { pastDue, almostDue, loaded, refresh };
}
