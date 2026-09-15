// Single source of truth for workflow-definition status presentation.
// Statuses: draft (editable) | published (immutable) | archived (immutable).
// Anything unknown falls back to the draft look so it never misleads.

export function wfStatusColor(status) {
    switch (status) {
        case 'published':
            return 'success'
        case 'archived':
            return 'grey'
        default:
            return 'warning'
    }
}

export function wfStatusIcon(status) {
    switch (status) {
        case 'published':
            return 'mdi-check-circle'
        case 'archived':
            return 'mdi-archive'
        default:
            return 'mdi-file-document-edit'
    }
}

export function wfStatusLabel(status) {
    return status || 'draft'
}

// Published and archived versions are both immutable.
export function isReadonlyStatus(status) {
    return status === 'published' || status === 'archived'
}
