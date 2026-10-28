import { computed } from 'vue'
import { useAuth, isSuperadminUser, isOfficeAdminUser } from '@/composables/useAuth'

// Whose data the signed-in user sees: every office, or their own.
export function useOfficeScope() {
    const auth = useAuth()

    return computed(() => {
        const u = auth.user.value
        if (!u) return null
        if (isSuperadminUser(u)) {
            return { kind: 'all', icon: 'mdi-earth', label: 'All offices', badge: 'Superadmin', tooltip: 'You see every office' }
        }
        const office = u.office
        if (!office) return null
        const label = office.code ? `${office.code} · ${office.name}` : office.name
        if (isOfficeAdminUser(u)) {
            return { kind: 'office', icon: 'mdi-office-building-outline', label, badge: 'Office admin', tooltip: `You manage ${office.name}` }
        }
        return { kind: 'member', icon: 'mdi-office-building-outline', label, badge: '', tooltip: `Your office: ${office.name}` }
    })
}
