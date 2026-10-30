// The running light on the login artwork's orbit ring, drawn on one canvas
// in picture coordinates (1536 x 1024): a white-hot head gliding at an even
// speed with a fading blue tail, and each bead flashing as the head passes
// it. One clock drives all of it. It is clipped where the ring passes
// behind the buttons and the City Hall tower.
import { BEAD_AT, RING_CLIP, RING_POINTS } from "./ringPath.js";

const W = 1536;

// Picture px, unless noted.
const TAIL_PX = 150; // tail length
const TAIL_STEPS = 30; // tail segments (smooth fade)
const HEAD_R = 16;
const BEAD_R = 30;
const BEAD_FLASH = 0.18; // fraction of a lap a bead stays visible after the head passes

// Ring as points with their distance along it; closes back to the start.
function buildRing() {
    const pts = [];
    for (let i = 0; i < RING_POINTS.length; i += 2) pts.push([RING_POINTS[i], RING_POINTS[i + 1]]);
    const dist = [0];
    for (let i = 1; i <= pts.length; i++) {
        const [ax, ay] = pts[i - 1];
        const [bx, by] = pts[i % pts.length];
        dist.push(dist[i - 1] + Math.hypot(bx - ax, by - ay));
    }
    return { pts, dist, length: dist[pts.length] };
}

// Point at distance s along the ring (wraps round).
function pointAt(ring, s) {
    const { pts, dist, length } = ring;
    s = ((s % length) + length) % length;
    let lo = 0;
    let hi = pts.length;
    while (hi - lo > 1) {
        const mid = (lo + hi) >> 1;
        if (dist[mid] <= s) lo = mid;
        else hi = mid;
    }
    const t = (s - dist[lo]) / (dist[lo + 1] - dist[lo] || 1);
    const a = pts[lo];
    const b = pts[(lo + 1) % pts.length];
    return [a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t];
}

// Bead brightness `p` laps after the head passed it: a quick flash, then a
// fade; dark until the head comes round again.
function beadLevel(p) {
    if (p < 0.012) return p / 0.012;
    if (p < BEAD_FLASH) return 1 - (p - 0.012) / (BEAD_FLASH - 0.012);
    return 0;
}

export function createRingLight(canvas, { lap = 3 } = {}) {
    const ctx = canvas.getContext("2d");
    const ring = buildRing();
    const clip = new Path2D(RING_CLIP);
    const beads = BEAD_AT.map((f) => pointAt(ring, f * ring.length));

    // Pre-drawn sprites: radial glows are costly to build every frame.
    const sprite = (r, stops) => {
        const c = document.createElement("canvas");
        c.width = c.height = Math.ceil(r * 2 * 2); // 2x for sharpness
        const g = c.getContext("2d");
        const grad = g.createRadialGradient(c.width / 2, c.height / 2, 0, c.width / 2, c.height / 2, c.width / 2);
        for (const [at, col] of stops) grad.addColorStop(at, col);
        g.fillStyle = grad;
        g.fillRect(0, 0, c.width, c.height);
        return c;
    };
    const headSprite = sprite(HEAD_R, [
        [0, "#ffffff"],
        [0.22, "#d6efff"],
        [0.45, "rgba(47, 139, 255, 0.85)"],
        [1, "rgba(47, 139, 255, 0)"],
    ]);
    const beadSprite = sprite(BEAD_R, [
        [0, "#ffffff"],
        [0.12, "#ffffff"],
        [0.22, "#a8dcff"],
        [0.38, "#2f8bff"],
        [0.55, "rgba(30, 110, 255, 0.4)"],
        [0.75, "rgba(30, 110, 255, 0.12)"],
        [1, "rgba(30, 110, 255, 0)"],
    ]);

    let scale = 1;
    function resize() {
        const dpr = Math.min(window.devicePixelRatio || 1, 2);
        const w = Math.max(1, Math.round(canvas.clientWidth * dpr));
        const h = Math.max(1, Math.round(canvas.clientHeight * dpr));
        if (canvas.width !== w || canvas.height !== h) {
            canvas.width = w;
            canvas.height = h;
        }
        scale = w / W;
    }

    function draw(seconds) {
        const lapPos = (seconds / lap) % 1;
        const head = lapPos * ring.length;
        ctx.setTransform(1, 0, 0, 1, 0, 0);
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.setTransform(scale, 0, 0, scale, 0, 0);
        ctx.save();
        ctx.clip(clip, "evenodd");

        // Beads flash as the head passes.
        for (let i = 0; i < beads.length; i++) {
            const level = beadLevel((((lapPos - BEAD_AT[i]) % 1) + 1) % 1);
            if (level <= 0) continue;
            const [x, y] = beads[i];
            const r = BEAD_R * (0.8 + 0.25 * level);
            ctx.globalAlpha = level;
            ctx.drawImage(beadSprite, x - r, y - r, r * 2, r * 2);
        }

        // Tail: short segments behind the head, thinner and fainter with
        // distance; a wide soft glow under a bright core.
        ctx.lineCap = "round";
        let prev = pointAt(ring, head);
        for (let k = 1; k <= TAIL_STEPS; k++) {
            const f = k / TAIL_STEPS; // 0 at the head .. 1 at the end
            const p = pointAt(ring, head - TAIL_PX * f);
            const fade = (1 - f) ** 1.5;
            ctx.strokeStyle = "#2f8bff";
            ctx.globalAlpha = 0.28 * fade;
            ctx.lineWidth = 12 * (1 - 0.6 * f);
            ctx.beginPath();
            ctx.moveTo(prev[0], prev[1]);
            ctx.lineTo(p[0], p[1]);
            ctx.stroke();
            ctx.strokeStyle = "#bfe6ff";
            ctx.globalAlpha = 0.9 * fade;
            ctx.lineWidth = 3.5 * (1 - 0.5 * f);
            ctx.stroke();
            prev = p;
        }

        // Head.
        const [hx, hy] = pointAt(ring, head);
        ctx.globalAlpha = 1;
        ctx.drawImage(headSprite, hx - HEAD_R, hy - HEAD_R, HEAD_R * 2, HEAD_R * 2);
        ctx.restore();
    }

    let raf = 0;
    let start = 0;
    function frame(now) {
        if (!start) start = now;
        draw((now - start) / 1000);
        raf = requestAnimationFrame(frame);
    }

    // A resize clears the canvas; repaint the still frame when not running.
    const ro = new ResizeObserver(() => {
        resize();
        if (!raf) draw(0.05);
    });
    ro.observe(canvas);
    resize();

    return {
        play() {
            cancelAnimationFrame(raf);
            start = 0;
            raf = requestAnimationFrame(frame);
        },
        // Stop moving and leave one still moment drawn (animations off).
        pause(seconds = 0.05) {
            cancelAnimationFrame(raf);
            raf = 0;
            resize();
            draw(seconds);
        },
        // Draw one moment (tests, reduced motion).
        drawAt(seconds) {
            resize();
            draw(seconds);
        },
        stop() {
            cancelAnimationFrame(raf);
            ro.disconnect();
        },
    };
}
