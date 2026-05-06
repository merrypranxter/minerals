# Shaders

GLSL shader library extracted from the Weird Guy Mineral Shader Corpus.

## Directory Structure

```
shaders/
├── utilities/
│   └── common.glsl          # Shared utility functions (palette, hash, smin, SDF primitives)
├── minerals/
│   ├── *.glsl               # Real mineral shaders (passes 1, 2, and 4-real)
│   └── fantasy/
│       ├── *.glsl           # Fantasy/impossible mineral shaders (pass 4-fantasy)
│       └── *.glsl           # Atmospheric crystals (hailstone, snowflake, frost-flower)
└── lessons/
    └── lesson-NN.glsl       # One file per lesson from MINERALS_LESSONS.md
```

## Uniforms Convention

All shaders use the following standard uniforms:

| Uniform          | Type    | Description                        |
|------------------|---------|------------------------------------|
| `u_time`         | float   | Elapsed time in seconds            |
| `u_resolution`   | vec2    | Viewport width × height in pixels  |
| `u_mouse`        | vec2    | Mouse position in pixels           |

Some shaders require additional uniforms:
- `u_back_image` — background texture (pass-through/refraction shaders)
- `u_recorded_image` — previous-frame texture (feedback loop shaders)
- `u_environment` — environment map (metallic/reflective shaders)
- `u_background` — static background image (compositing shaders)
- `u_lightTemp` — light color temperature (Alexandrite)

## Common Utilities (`utilities/common.glsl`)

- `pal(t, a, b, c, d)` — Inigo Quilez cosine palette
- `hash21(p)`, `hash33(p)` — hash functions
- `rot(a)` — 2D rotation matrix
- `smin(a, b, k)` — smooth minimum (polynomial blend)
- `sdSphere`, `sdBox`, `sdHexPrism`, `sdNeedle`, `sdOctahedron`, `sdRhombohedron` — SDF primitives
- `ridge(n)` — ridge noise helper
- `fbm(p)` — fractal Brownian motion
- `braggColor(d, cosTheta, time_offset)` — Bragg-diffraction color palette

## Lesson Index

Lessons 01–40 correspond to the 40 technique lessons in `docs/SHADER_TECHNIQUES.md`.

| Lessons | Cluster | Theme |
|---------|---------|-------|
| 01–12   | A–C     | Structural color, fiber shading, SDF geometry |
| 13–19   | D–E     | Temporal/reactive, volumetric depth |
| 20–37   | F–H     | Polar/radial, stochastic, meta/recursive |
| 38–40   | —       | Reaction-diffusion, cellular automata, infrastructure |

## Sources

Shaders were extracted from the Weird Guy Mineral Shader Corpus seed files:

- Pass 1 — minerals 1–36 (agate through syntax-quartz)
- Pass 2 — minerals 37–45 (fluorite through moldavite)
- Pass 4 — fantasy F11–F20, real R1–R10, atmospheric A1–A3
- MINERALS_LESSONS.md → `docs/SHADER_TECHNIQUES.md` — 40 lessons with technique explanations
