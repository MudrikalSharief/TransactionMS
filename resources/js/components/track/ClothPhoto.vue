<template>
    <canvas ref="canvas" class="cloth-photo" aria-hidden="true"></canvas>
</template>

<script setup>
// Makes a photo of a flag move like cloth: WebGL resamples the picture
// through travelling diagonal folds (so the fabric and its stripes ripple)
// and lights the folds as they pass. An ellipse around the greeting, which
// is part of the photo, is held still so the text stays sharp. Sits on top
// of the same photo shown as a plain <img>, which shows through until the
// texture loads, and covers for it without WebGL or under reduced motion.
import { onMounted, onUnmounted, ref } from "vue";

const props = defineProps({
    src: { type: String, required: true },
});

const canvas = ref(null);

const VERT = `
attribute vec2 a_pos;
varying vec2 v_uv;
void main() {
    v_uv = vec2(a_pos.x * 0.5 + 0.5, 0.5 - a_pos.y * 0.5);
    gl_Position = vec4(a_pos, 0.0, 1.0);
}`;

const FRAG = `
precision mediump float;
uniform sampler2D u_tex;
uniform float u_time;
uniform float u_wind;
uniform float u_aspect;
varying vec2 v_uv;

// Cloth height: a broad billow plus diagonal folds, all travelling away
// from the hoist (left).
float fold(vec2 p, float t) {
    return 0.62 * sin(p.x * 4.2 + p.y * 1.6 - t * 1.9)
         + 0.42 * sin(p.x * 7.5 + p.y * 3.4 - t * 2.9 + 0.7)
         + 0.22 * sin(p.x * 13.0 - p.y * 4.2 - t * 4.4 + 1.3)
         + 0.10 * sin(p.x * 22.0 + p.y * 6.0 - t * 6.5 + 2.1);
}

void main() {
    vec2 uv = v_uv;
    // Work in a square-ish space so folds keep their angle on any shape.
    vec2 p = vec2(uv.x * u_aspect, uv.y);
    float t = u_time;
    float gust = 0.75 + 0.25 * sin(t * 0.43) * sin(t * 0.29 + 1.2);

    // Held at the hoist edge, freer toward the fly end; still over the
    // greeting (centre of the picture).
    float free = 0.35 + 0.65 * smoothstep(0.0, 1.0, uv.x);
    vec2 q = (uv - vec2(0.51, 0.5)) / vec2(0.36, 0.30);
    float hold = smoothstep(0.78, 1.0, length(q));
    float k = free * hold * gust * u_wind;

    // Slope of the cloth from the height field (for the ripple and light).
    float e = 0.002;
    float h = fold(p, t);
    float hx = (fold(p + vec2(e, 0.0), t) - h) / e;
    float hy = (fold(p + vec2(0.0, e), t) - h) / e;

    // Ripple: the cloth lifts and falls with the height (the stripes and
    // edges bend) and slides a little along its slope.
    vec2 shift = vec2(hx * 0.0016, h * 0.012 + hy * 0.0022) * k;
    vec3 col = texture2D(u_tex, clamp(uv - shift, 0.001, 0.999)).rgb;

    // Light: folds facing the upper-left key brighten, the backs darken,
    // with a soft satin glint on the brightest crests.
    float facing = clamp(-(hx * 0.6 + hy * 0.8) / 7.0, -1.0, 1.0);
    float lit = 1.0 + 0.36 * facing * k;
    float glint = pow(max(facing, 0.0), 3.0) * 0.22 * k;
    col = col * lit + glint * vec3(1.0, 0.9, 0.75);

    gl_FragColor = vec4(col, 1.0);
}`;

let gl = null;
let uni = {};
let raf = 0;
let start = 0;
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

function sizeCanvas() {
    const el = canvas.value;
    const dpr = Math.min(window.devicePixelRatio || 1, 1.5);
    el.width = Math.max(1, Math.round(el.clientWidth * dpr));
    el.height = Math.max(1, Math.round(el.clientHeight * dpr));
    if (gl) gl.viewport(0, 0, el.width, el.height);
}

const easeOut = (x) => 1 - Math.pow(1 - x, 3);

function frame(now) {
    const ms = now - start;
    const el = canvas.value;
    gl.uniform1f(uni.u_time, ms / 1000);
    // The wind picks up as the screen opens.
    gl.uniform1f(uni.u_wind, 0.5 + 0.5 * easeOut(Math.min(ms / 1500, 1)));
    gl.uniform1f(uni.u_aspect, el.clientWidth / Math.max(1, el.clientHeight));
    gl.drawArrays(gl.TRIANGLES, 0, 6);
    raf = requestAnimationFrame(frame);
}

function init(img) {
    gl = canvas.value.getContext("webgl", { alpha: false, antialias: false });
    if (!gl) return false;

    const prog = gl.createProgram();
    gl.attachShader(prog, compile(gl.VERTEX_SHADER, VERT));
    gl.attachShader(prog, compile(gl.FRAGMENT_SHADER, FRAG));
    gl.linkProgram(prog);
    if (!gl.getProgramParameter(prog, gl.LINK_STATUS)) return false;
    gl.useProgram(prog);

    // One full-screen quad; the fragment shader does the work.
    gl.bindBuffer(gl.ARRAY_BUFFER, gl.createBuffer());
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 1, -1, -1, 1, -1, 1, 1, -1, 1, 1]), gl.STATIC_DRAW);
    const loc = gl.getAttribLocation(prog, "a_pos");
    gl.enableVertexAttribArray(loc);
    gl.vertexAttribPointer(loc, 2, gl.FLOAT, false, 0, 0);

    // The photo is not a power of two: no mipmaps, clamped edges.
    gl.bindTexture(gl.TEXTURE_2D, gl.createTexture());
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGB, gl.RGB, gl.UNSIGNED_BYTE, img);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);

    for (const name of ["u_tex", "u_time", "u_wind", "u_aspect"]) {
        uni[name] = gl.getUniformLocation(prog, name);
    }
    gl.uniform1i(uni.u_tex, 0);
    return true;
}

onMounted(() => {
    // Reduced motion: leave the still photo underneath on its own.
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

    const img = new Image();
    img.decoding = "async";
    img.onload = () => {
        if (!canvas.value) return;
        let ok = false;
        try {
            sizeCanvas();
            ok = init(img);
        } catch {
            ok = false;
        }
        if (!ok) {
            gl = null;
            return;
        }
        observer = new ResizeObserver(sizeCanvas);
        observer.observe(canvas.value);
        start = performance.now();
        raf = requestAnimationFrame(frame);
        canvas.value.classList.add("on");
    };
    img.src = props.src;
});

onUnmounted(() => {
    cancelAnimationFrame(raf);
    observer?.disconnect();
    gl?.getExtension("WEBGL_lose_context")?.loseContext();
    gl = null;
});
</script>

<style scoped>
/* Hidden until the first frame is ready, so the still photo shows first. */
.cloth-photo {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    opacity: 0;
    transition: opacity 0.6s ease-out;
    pointer-events: none;
}
.cloth-photo.on {
    opacity: 1;
}
</style>
