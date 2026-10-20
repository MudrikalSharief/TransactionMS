<template>
    <div ref="root" class="waving-flag" aria-hidden="true">
        <canvas ref="canvas"></canvas>
    </div>
</template>

<script setup>
// The Philippine flag, drawn to a texture with its official geometry and
// rendered full-bleed as cloth in WebGL: waving in a gusting wind, with light
// on the crests and shadow in the folds. Fills its container; `frame` places
// it (see flagGeometry). Falls back to a still flag without WebGL, and holds
// still under reduced motion.
import { onMounted, onUnmounted, ref } from "vue";
import { STARS, SUN, TIP, fieldRect } from "./flagGeometry";

const props = defineProps({
    // { sunX, sunY, height }: sun position as a share of the container,
    // field height as a multiple of the container height.
    frame: { type: Object, required: true },
});
const emit = defineEmits(["ready"]);

const root = ref(null);
const canvas = ref(null);

// Header (the canvas sleeve at the hoist) as a share of the texture width.
const TEX_W = 2048;
const TEX_H = 1024;
const HEADER_PX = 72;
const HEADER = HEADER_PX / TEX_W;

const rect = { x: 0, y: 0, w: 0, h: 0 };
let cssW = 0;
let cssH = 0;

// ---- Flag artwork -------------------------------------------------------

function drawFlagTexture() {
    const c = document.createElement("canvas");
    c.width = TEX_W;
    c.height = TEX_H;
    const g = c.getContext("2d");

    g.fillStyle = "#e7e2d4";
    g.fillRect(0, 0, HEADER_PX, TEX_H);

    // Field in flag units: 2 wide by 1 tall (stretched back by the mesh).
    g.setTransform((TEX_W - HEADER_PX) / 2, 0, 0, TEX_H, HEADER_PX, 0);

    g.fillStyle = "#0038a8";
    g.fillRect(0, 0, 2, 0.5);
    g.fillStyle = "#ce1126";
    g.fillRect(0, 0.5, 2, 0.5);

    g.fillStyle = "#ffffff";
    g.beginPath();
    g.moveTo(0, 0);
    g.lineTo(TIP, 0.5);
    g.lineTo(0, 1);
    g.closePath();
    g.fill();

    const [cx, cy] = SUN;
    g.fillStyle = "#fcd116";

    // Sun: a broad disk; each of the eight rays is a long centre beam between
    // two shorter ones, close together so the rays read apart.
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
    const corners = [
        [0, 0],
        [0, 1],
        [TIP, 0.5],
    ];
    STARS.forEach(([sx, sy], i) => {
        const [vx, vy] = corners[i];
        const toward = Math.atan2(vy - cy, vx - cx);
        const R = 0.052;
        g.beginPath();
        for (let p = 0; p < 10; p++) {
            const a = toward + (p * Math.PI) / 5;
            const rad = p % 2 === 0 ? R : R * 0.382;
            const px = sx + Math.cos(a) * rad;
            const py = sy + Math.sin(a) * rad;
            if (p === 0) g.moveTo(px, py);
            else g.lineTo(px, py);
        }
        g.closePath();
        g.fill();
    });

    return c;
}

// ---- Layout -------------------------------------------------------------

function measure() {
    cssW = root.value.clientWidth;
    cssH = root.value.clientHeight;
    const f = fieldRect(props.frame, cssW, cssH);
    // Mesh = header + a 2:1 field; the header sits just off the field's left.
    rect.w = (f.h * 2) / (1 - HEADER);
    rect.x = f.x - rect.w * HEADER;
    rect.y = f.y;
    rect.h = f.h;
}

// ---- WebGL --------------------------------------------------------------

const VERT = `
attribute vec2 a_uv;
uniform vec2 u_res;
uniform vec4 u_rect;
uniform float u_time;
uniform float u_wind;
uniform float u_header;
varying vec2 v_uv;
varying vec3 v_n;
varying float v_depth;

const float AMP = 0.10;

// How free the cloth is: held at the hoist, loose soon after (only the
// hoist half of the flag is on screen, so the motion has to start early).
float freedom(vec2 uv) {
    float u = max(uv.x - u_header, 0.0) / (1.0 - u_header);
    return pow(u, 0.7);
}

float gust(float t) {
    return 0.74 + 0.26 * sin(t * 0.41) * sin(t * 0.27 + 1.3);
}

// Depth of the cloth: diagonal folds travelling away from the hoist.
float wave(vec2 uv, float t) {
    float s = 0.56 * sin(uv.x * 10.5 - t * 3.2 + uv.y * 2.2)
            + 0.29 * sin(uv.x * 17.0 - t * 5.1 - uv.y * 2.6 + 1.1)
            + 0.15 * sin(uv.x * 27.0 - t * 7.6 + uv.y * 4.0 + 2.0);
    return freedom(uv) * gust(t) * s;
}

// Cloth position in container pixels; z is depth toward the viewer. The
// cloth also shifts within its plane, so the stripes and the triangle's
// edges ripple instead of staying ruler-straight.
vec3 place(vec2 uv, float t) {
    float f = freedom(uv) * gust(t) * u_wind;
    float z = wave(uv, t) * u_wind * u_rect.z * AMP;
    float x = u_rect.x + uv.x * u_rect.z * (1.0 - 0.05 * u_wind * uv.x)
            + u_rect.w * 0.018 * f * cos(uv.x * 9.0 - t * 2.9 + uv.y * 1.7);
    float y = u_rect.y + uv.y * u_rect.w
            + u_rect.w * 0.04 * f * sin(uv.x * 9.0 - t * 3.2 + uv.y * 1.5 + 0.9);
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
    // folds and edges ripple; the still hoist keeps its place.
    vec2 c = vec2(u_rect.x, u_rect.y + u_rect.w * 0.5);
    float focal = u_rect.w * 3.0;
    vec2 s = c + (p.xy - c) * focal / (focal - p.z);

    gl_Position = vec4(s.x / u_res.x * 2.0 - 1.0, 1.0 - s.y / u_res.y * 2.0, 0.0, 1.0);
}`;

// Low, warm key from the upper left in a dark room, like the photograph it
// replaces: deep shadow in the folds, a satin sheen on the crests.
const FRAG = `
precision mediump float;
uniform sampler2D u_tex;
varying vec2 v_uv;
varying vec3 v_n;
varying float v_depth;

void main() {
    vec3 base = texture2D(u_tex, v_uv).rgb;
    vec3 n = normalize(v_n);
    vec3 key = normalize(vec3(-0.5, -0.6, 0.62));
    float d = max(dot(n, key), 0.0);
    float wrap = 0.24 + 0.76 * d;
    vec3 h = normalize(key + vec3(0.0, 0.0, 1.0));
    float sheen = pow(max(dot(n, h), 0.0), 40.0) * 0.32;
    float ao = 0.6 + 0.4 * smoothstep(-1.0, 1.0, v_depth);

    vec3 col = base * wrap * ao * vec3(1.0, 0.94, 0.86) * 0.88
             + base * vec3(0.45, 0.55, 0.9) * 0.05
             + sheen * vec3(1.0, 0.92, 0.78);
    gl_FragColor = vec4(col, 1.0);
}`;

let gl = null;
let uni = {};
let indexCount = 0;
let raf = 0;
let start = 0;
let still = false;
let texCanvas = null;
let observer = null;

function compile(type, src) {
    const s = gl.createShader(type);
    gl.shaderSource(s, src);
    gl.compileShader(s);
    if (!gl.getShaderParameter(s, gl.COMPILE_STATUS)) {
        throw new Error(gl.getShaderInfoLog(s) || "shader compile failed");
    }
    return s;
}

function initGL() {
    gl = canvas.value.getContext("webgl", { antialias: true, alpha: true, premultipliedAlpha: true });
    if (!gl) return false;

    const prog = gl.createProgram();
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
            const c = a + COLS + 1;
            idx.set([a, c, a + 1, a + 1, c, c + 1], o);
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

    gl.bindTexture(gl.TEXTURE_2D, gl.createTexture());
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

    for (const name of ["u_res", "u_rect", "u_time", "u_wind", "u_header", "u_tex"]) {
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
    canvas.value.width = Math.max(1, Math.round(cssW * dpr));
    canvas.value.height = Math.max(1, Math.round(cssH * dpr));
    if (gl) gl.viewport(0, 0, canvas.value.width, canvas.value.height);
}

const easeOut = (x) => 1 - Math.pow(1 - x, 3);

function frame(now) {
    const ms = now - start;
    // The wind picks up as the screen opens, then gusts.
    const wind = still ? 0.75 : 0.55 + 0.45 * easeOut(Math.min(ms / 1400, 1));
    const t = still ? 1.4 : ms / 1000;

    gl.clear(gl.COLOR_BUFFER_BIT);
    gl.uniform2f(uni.u_res, cssW, cssH);
    gl.uniform4f(uni.u_rect, rect.x, rect.y, rect.w, rect.h);
    gl.uniform1f(uni.u_time, t);
    gl.uniform1f(uni.u_wind, wind);
    gl.drawElements(gl.TRIANGLES, indexCount, gl.UNSIGNED_SHORT, 0);

    if (!still) raf = requestAnimationFrame(frame);
}

// No WebGL: the same artwork, flat and dimmed, where the flag would hang.
function drawStill() {
    const g = canvas.value.getContext("2d");
    if (!g) return;
    const dpr = canvas.value.width / cssW;
    g.setTransform(dpr, 0, 0, dpr, 0, 0);
    g.clearRect(0, 0, cssW, cssH);
    g.drawImage(texCanvas, rect.x, rect.y, rect.w, rect.h);
    g.fillStyle = "rgba(5, 10, 24, 0.35)";
    g.fillRect(0, 0, cssW, cssH);
}

function onResize() {
    sizeCanvas();
    if (!gl) drawStill();
    else if (still) frame(performance.now());
}

onMounted(() => {
    still = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    texCanvas = drawFlagTexture();
    sizeCanvas();

    let ok = false;
    try {
        ok = initGL();
    } catch {
        ok = false;
    }
    if (ok) {
        start = performance.now();
        frame(start);
    } else {
        gl = null;
        drawStill();
    }

    observer = new ResizeObserver(onResize);
    observer.observe(root.value);
    emit("ready");
});

onUnmounted(() => {
    cancelAnimationFrame(raf);
    observer?.disconnect();
    gl?.getExtension("WEBGL_lose_context")?.loseContext();
    gl = null;
});
</script>

<style scoped>
.waving-flag,
.waving-flag canvas {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
}
</style>
