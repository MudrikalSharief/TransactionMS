// One greeting rule for the workspace header and login notice. Hour is the
// Asia/Manila hour (0–23).
export function greetingForHour(hour) {
    const h = Number(hour)
    if (h >= 8 && h < 12) return 'Good morning'
    if (h >= 12 && h < 13) return 'Good noon'
    if (h >= 13 && h < 18) return 'Good afternoon'
    return 'Good evening'
}
