// Philippine flag geometry in flag units: the field is 2 wide by 1 tall,
// origin at the top of the hoist. Shared by the renderer (WavingFlag) and
// the welcome screen's overlays, so glows land on the painted sun and stars.

export const TIP = Math.sqrt(3) / 2; // right corner of the white triangle
export const SUN = [TIP / 3, 0.5]; // centre of the triangle
export const STARS = [
    [0.086, 0.105],
    [0.086, 0.895],
    [TIP - 0.125, 0.5],
];

// Where the flag sits in a container of size w x h: `frame` gives the sun's
// position as a share of the container and the field height as a multiple
// of the container height. Returns the field's top-left and height in px.
export function fieldRect(frame, w, h) {
    const fieldH = frame.height * h;
    return {
        x: frame.sunX * w - SUN[0] * fieldH,
        y: frame.sunY * h - SUN[1] * fieldH,
        h: fieldH,
    };
}

// A point on the flag (flag units) as left/top percentages of the container.
export function pointOnContainer(frame, aspect, [fx, fy]) {
    const r = fieldRect(frame, aspect, 1);
    return [((r.x + fx * r.h) / aspect) * 100, (r.y + fy * r.h) * 100];
}
