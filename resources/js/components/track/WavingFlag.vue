<template>
    <div class="waving-flag" :style="poleStyle" aria-hidden="true">
        <span class="pole"></span>
        <span class="finial"></span>
        <span class="halyard"></span>
        <canvas ref="canvas" class="cloth"></canvas>
    </div>
</template>

<script setup>
// The Philippine flag, drawn to a texture with its official geometry and
// rendered as cloth in WebGL: raised up the pole, then waving in a gusting
// wind with light on the crests and shadow in the folds. Falls back to a
// still flag without WebGL, and holds still under reduced motion.
import { computed, onMounted, onUnmounted, reactive, ref } from "vue";

const emit = defineEmits(["ready"]);

const canvas = ref(null);
const layout = reactive({ x: 0, y: 0, w: 0, h: 0, pole: 8 });

// Header (the canvas sleeve with grommets) as a share of the texture width.
const TEX_W = 2048;
const TEX_H = 1024;
const HEADER_PX = 72;
const HEADER = HEADER_PX / TEX_W;

const RAISE_MS = 1700;

const poleStyle = computed(() => ({
    "--hoist": layout.x + "px",
    "--top": layout.y + "px",
    "--pole": layout.pole + "px",
}));

// ---- Flag artwork -------------------------------------------------------

function drawFlagTexture() {
    const c = document.createElement("canvas");
    c.width = TEX_W;
    c.height = TEX_H;
    const g = c.getContext("2d");

    // Header: off-white canvas sleeve, a seam, two brass grommets.
    g.fillStyle = "#e7e2d4";
    g.fillRect(0, 0, HEADER_PX, TEX_H);
    g.fillStyle = "rgba(0,0,0,0.12)";
    g.fillRect(HEADER_PX - 3, 0, 3, TEX_H);
    for (const gy of [0.07, 0.93]) {
        g.beginPath();
        g.arc(HEADER_PX * 0.48, TEX_H * gy, 20, 0, Math.PI * 2);
        g.fillStyle = "#a8834d";
        g.fill();
        g.beginPath();
        g.arc(HEADER_PX * 0.48, TEX_H * gy, 11, 0, Math.PI * 2);
        g.fillStyle = "#3a3226";
        g.fill();
    }

    // Field in flag units: 2 wide by 1 tall (stretched back by the mesh).
    g.save();
    g.setTransform((TEX_W - HEADER_PX) / 2, 0, 0, TEX_H, HEADER_PX, 0);

    g.fillStyle = "#0038a8";
    g.fillRect(0, 0, 2, 0.5);
    g.fillStyle = "#ce1126";
    g.fillRect(0, 0.5, 2, 0.5);

    // White equilateral triangle at the hoist.
    const tip = Math.sqrt(3) / 2;
    g.fillStyle = "#ffffff";
    g.beginPath();
    g.moveTo(0, 0);
    g.lineTo(tip, 0.5);
    g.lineTo(0, 1);
    g.closePath();
    g.fill();

    const gold = "#fcd116";
    const cx = tip / 3;
    const cy = 0.5;

    // Sun: eight rays of three beams each, around a disk.
    g.fillStyle = gold;
    const beam = (angle, inner, outer, half) => {
        const dx = Math.cos(angle);
        const dy = Math.sin(angle);
        g.beginPath();
        g.moveTo(cx + dx * inner - dy * half, cy + dy * inner + dx * half);
        g.lineTo(cx + dx * outer, cy + dy * outer);
        g.lineTo(cx + dx * inner + dy * half, cy + dy * inner - dx * half);
        g.closePath();
        g.fill();
    };
    // A broad disk; each ray is a long centre beam between two shorter ones.
    // Beams sit close together so the eight rays read apart.
    const DISK = 0.086;
    for (let k = 0; k < 8; k++) {
        const a = (k * Math.PI) / 4;
        beam(a, DISK * 0.8, 0.212, 0.022);
        beam(a - 0.14, DISK * 0.8, 0.176, 0.0145);
        beam(a + 0.14, DISK * 0.8, 0.176, 0.0145);
    }
    g.beginPath();
    g.arc(cx, cy, DISK, 0, Math.PI * 2);
    g.fill();

    // Three five-pointed stars, each pointing to its corner.
    const star = (sx, sy, toward) => {
        const R = 0.052;
        const r = R * 0.382;
        g.beginPath();
        for (let i = 0; i < 10; i++) {
            const a = toward + (i * Math.PI) / 5;
            const rad = i % 2 === 0 ? R : r;
            const px = sx + Math.cos(a) * rad;
            const py = sy + Math.sin(a) * rad;
            if (i === 0) g.moveTo(px, py);
            else g.lineTo(px, py);
        }
        g.closePath();
        g.fill();
    };
    const corners = [
        [0, 0, 0.086, 0.105],
        [0, 1, 0.086, 0.895],
        [tip, 0.5, tip - 0.125, 0.5],
    ];
    for (const [vx, vy, sx, sy] of corners) {
        star(sx, sy, Math.atan2(vy - cy, vx - cx));
    }
    g.restore();

    return c;
}

// ---- Layout -------------------------------------------------------------

function measure() {
    const w = window.innerWidth;
    const h = window.innerHeight;
    let fieldH;
    if (w >= h) {
        fieldH = Math.min(h * 0.36, w * 0.235);
        layout.x = Math.max(56, w * 0.075);
        layout.y = h * 0.13;
    } else {
        fieldH = (w * 0.74) / 2;
        layout.x = w * 0.12;
        layout.y = h * 0.1;
    }
    layout.h = fieldH;
    // Mesh width = header + a 2:1 field.
    layout.w = (fieldH * 2) / (1 - HEADER);
    layout.pole = Math.max(7, Math.round(fieldH * 0.045));
}

// ---- WebGL --------------------------------------------------------------

const VERT = `
attribute vec2 a_uv;
uniform vec2 u_res;
uniform vec4 u_rect;
uniform float u_time;
uniform float u_wind;
uniform float u_lift;
uniform float u_header;
varying vec2 v_uv;
varying vec3 v_n;
varying float v_depth;

const float AMP = 0.12;

float wave(vec2 uv, float t) {
    float u = max(uv.x - u_header, 0.0) / (1.0 - u_header);
    float a = pow(u, 1.1);
    float gust = 0.74 + 0.26 * sin(t * 0.41) * sin(t * 0.27 + 1.3);
    float s = 0.58 * sin(uv.x * 8.5 - t * 3.2 + uv.y * 1.1)
            + 0.27 * sin(uv.x * 14.0 - t * 5.1 - uv.y * 1.9 + 1.1)
            + 0.15 * sin(uv.x * 23.0 - t * 7.6 + uv.y * 3.5 + 2.0) * u;
    return a * gust * s;
}

// Cloth position in page pixels; z is depth toward the viewer.
vec3 place(vec2 uv, float t) {
    float z = wave(uv, t) * u_wind * u_rect.z * AMP;
    // Cloth draws in a little as it ripples, and the fly end sags a touch.
    float x = u_rect.x + uv.x * u_rect.z * (1.0 - 0.05 * u_wind * uv.x);
    float y = u_rect.y + u_lift + uv.y * u_rect.w
            + uv.x * uv.x * u_rect.w * 0.035 * (1.15 - u_wind);
    return vec3(x, y, z);
}

void main() {
    vec3 p = place(a_uv, u_time);
    vec3 pu = place(a_uv + vec2(0.004, 0.0), u_time);
    vec3 pv = place(a_uv + vec2(0.0, 0.004), u_time);
    v_n = normalize(cross(pu - p, pv - p));
    v_uv = a_uv;
    v_depth = p.z / (u_rect.z * AMP + 0.001);

    // Perspective about the hoist: cloth swinging toward you grows, so the
    // edges ripple. The hoist itself (z = 0) stays on the pole.
    vec2 c = vec2(u_rect.x, u_rect.y + u_lift + u_rect.w * 0.5);
    float focal = u_rect.w * 3.0;
    vec2 s = c + (p.xy - c) * focal / (focal - p.z);

    gl_Position = vec4(s.x / u_res.x * 2.0 - 1.0, 1.0 - s.y / u_res.y * 2.0, 0.0, 1.0);
}`;

const FRAG = `
precision mediump float;
uniform sampler2D u_tex;
varying vec2 v_uv;
varying vec3 v_n;
varying float v_depth;

void main() {
    vec3 base = texture2D(u_tex, v_uv).rgb;
    vec3 n = normalize(v_n);
    // Key light from the upper left, a cool sky fill, and the warm horizon
    // from below right (the page is set at dusk).
    vec3 key = normalize(vec3(-0.5, -0.6, 0.62));
    float d = max(dot(n, key), 0.0);
    float wrap = 0.30 + 0.70 * d;
    vec3 h = normalize(key + vec3(0.0, 0.0, 1.0));
    float sheen = pow(max(dot(n, h), 0.0), 40.0) * 0.34;
    float ao = 0.66 + 0.34 * smoothstep(-1.0, 1.0, v_depth);
    float dusk = max(dot(n, normalize(vec3(0.45, 0.7, 0.55))), 0.0);

    vec3 col = base * wrap * ao * vec3(1.0, 0.97, 0.93)
             + base * vec3(0.55, 0.65, 0.95) * 0.10
             + base * vec3(0.95, 0.55, 0.28) * 0.10 * dusk
             + sheen * vec3(1.0, 0.95, 0.85);
    gl_FragColor = vec4(col, 1.0);
}`;

let gl = null;
let prog = null;
let uni = {};
let indexCount = 0;
let raf = 0;
let start = 0;
let still = false;

function compile(type, src) {
    const s = gl.createShader(type);
    gl.shaderSource(s, src);
    gl.compileShader(s);
    if (!gl.getShaderParameter(s, gl.COMPILE_STATUS)) {
        throw new Error(gl.getShaderInfoLog(s) || "shader compile failed");
    }
    return s;
}

function initGL(texCanvas) {
    gl = canvas.value.getContext("webgl", { antialias: true, alpha: true, premultipliedAlpha: true });
    if (!gl) return false;

    prog = gl.createProgram();
    gl.attachShader(prog, compile(gl.VERTEX_SHADER, VERT));
    gl.attachShader(prog, compile(gl.FRAGMENT_SHADER, FRAG));
    gl.linkProgram(prog);
    if (!gl.getProgramParameter(prog, gl.LINK_STATUS)) return false;
    gl.useProgram(prog);

    // Grid mesh over the flag: COLS x ROWS quads.
    const COLS = 120;
    const ROWS = 60;
    const uv = new Float32Array((COLS + 1) * (ROWS + 1) * 2);
    let o = 0;
    for (let j = 0; j <= ROWS; j++) {
        for (let i = 0; i <= COLS; i++) {
            uv[o++] = i / COLS;
            uv[o++] = j / ROWS;
        }
    }
    const idx = new Uint16Array(COLS * ROWS * 6);
    o = 0;
    for (let j = 0; j < ROWS; j++) {
        for (let i = 0; i < COLS; i++) {
            const a = j * (COLS + 1) + i;
            const b = a + 1;
            const c = a + COLS + 1;
            const d = c + 1;
            idx.set([a, c, b, b, c, d], o);
            o += 6;
        }
    }
    indexCount = idx.length;

    gl.bindBuffer(gl.ARRAY_BUFFER, gl.createBuffer());
    gl.bufferData(gl.ARRAY_BUFFER, uv, gl.STATIC_DRAW);
    const loc = gl.getAttribLocation(prog, "a_uv");
    gl.enableVertexAttribArray(loc);
    gl.vertexAttribPointer(loc, 2, gl.FLOAT, false, 0, 0);
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, gl.createBuffer());
    gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, idx, gl.STATIC_DRAW);

    const tex = gl.createTexture();
    gl.bindTexture(gl.TEXTURE_2D, tex);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, texCanvas);
    gl.generateMipmap(gl.TEXTURE_2D);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_LINEAR);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
    const aniso = gl.getExtension("EXT_texture_filter_anisotropic");
    if (aniso) {
        gl.texParameterf(gl.TEXTURE_2D, aniso.TEXTURE_MAX_ANISOTROPY_EXT, Math.min(8, gl.getParameter(aniso.MAX_TEXTURE_MAX_ANISOTROPY_EXT)));
    }

    for (const name of ["u_res", "u_rect", "u_time", "u_wind", "u_lift", "u_header", "u_tex"]) {
        uni[name] = gl.getUniformLocation(prog, name);
    }
    gl.uniform1i(uni.u_tex, 0);
    gl.uniform1f(uni.u_header, HEADER);
    gl.clearColor(0, 0, 0, 0);
    return true;
}

function sizeCanvas() {
    measure();
    const dpr = Math.min(window.devicePixelRatio || 1, 2);
    const el = canvas.value;
    el.width = Math.round(window.innerWidth * dpr);
    el.height = Math.round(window.innerHeight * dpr);
    if (gl) gl.viewport(0, 0, el.width, el.height);
}

const easeOut = (x) => 1 - Math.pow(1 - x, 3);

function frame(now) {
    const ms = now - start;
    const raise = still ? 1 : Math.min(ms / RAISE_MS, 1);
    const lift = (1 - easeOut(raise)) * window.innerHeight * 0.22;
    const wind = still ? 0.7 : 0.35 + 0.65 * easeOut(Math.min(ms / 2600, 1));
    const t = still ? 1.4 : ms / 1000;

    gl.clear(gl.COLOR_BUFFER_BIT);
    gl.uniform2f(uni.u_res, window.innerWidth, window.innerHeight);
    gl.uniform4f(uni.u_rect, layout.x, layout.y, layout.w, layout.h);
    gl.uniform1f(uni.u_time, t);
    gl.uniform1f(uni.u_wind, wind);
    gl.uniform1f(uni.u_lift, lift);
    gl.drawElements(gl.TRIANGLES, indexCount, gl.UNSIGNED_SHORT, 0);

    if (!still) raf = requestAnimationFrame(frame);
}

// No WebGL: the same artwork, flat, where the flag would hang.
function drawStill(texCanvas) {
    const g = canvas.value.getContext("2d");
    if (!g) return;
    const dpr = canvas.value.width / window.innerWidth;
    g.setTransform(dpr, 0, 0, dpr, 0, 0);
    g.clearRect(0, 0, window.innerWidth, window.innerHeight);
    g.drawImage(texCanvas, layout.x, layout.y, layout.w, layout.h);
}

let texCanvas = null;

function onResize() {
    sizeCanvas();
    if (!gl && texCanvas) drawStill(texCanvas);
    if (gl && still) frame(performance.now());
}

onMounted(() => {
    still = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    texCanvas = drawFlagTexture();
    sizeCanvas();

    let ok = false;
    try {
        ok = initGL(texCanvas);
    } catch {
        ok = false;
    }

    if (ok) {
        start = performance.now();
        frame(start);
    } else {
        gl = null;
        drawStill(texCanvas);
    }
    window.addEventListener("resize", onResize);
    emit("ready");
});

onUnmounted(() => {
    cancelAnimationFrame(raf);
    window.removeEventListener("resize", onResize);
    gl?.getExtension("WEBGL_lose_context")?.loseContext();
    gl = null;
});
</script>

<style scoped>
.waving-flag {
    position: absolute;
    inset: 0;
    pointer-events: none;
}
.cloth {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
}
/* Brushed-steel pole whose right edge meets the flag's header. */
.pole {
    position: absolute;
    left: calc(var(--hoist) - var(--pole));
    top: calc(var(--top) - var(--pole) * 2.2);
    bottom: 0;
    width: var(--pole);
    background: linear-gradient(90deg, #1b2440 0%, #9aa3b6 30%, #d9dde6 42%, #6d768c 70%, #1a2138 100%);
}
.finial {
    position: absolute;
    left: calc(var(--hoist) - var(--pole) * 1.75);
    top: calc(var(--top) - var(--pole) * 4.3);
    width: calc(var(--pole) * 2.5);
    height: calc(var(--pole) * 2.5);
    border-radius: 50%;
    background: radial-gradient(circle at 35% 30%, #fff3c4 0%, #e3b54e 35%, #8a6421 100%);
}
.halyard {
    position: absolute;
    left: calc(var(--hoist) + 1px);
    top: calc(var(--top) - var(--pole) * 2);
    bottom: 0;
    width: 1px;
    background: rgba(214, 220, 232, 0.28);
}
</style>
