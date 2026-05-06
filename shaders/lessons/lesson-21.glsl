// shaders/lessons/lesson-21.glsl
// Lesson 21: MANGANESE DENDRITES: RIDGE NOISE / CAPILLARY FRACTAL STAIN
// Category: Diffusion-Limited Growth / Pseudo-Fossil
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// fbm_dendrite
// ridge(sin(dot(p, vec2(1.0, 1.7)))) * amp
// p += cos(p.yx * 2.0 + u_time * 0.1)
// smoothstep(0.1, 0.0, abs(uv.y + sin(uv.x*2.0)*0.2))
// smoothstep(growth_limit, growth_limit + 0.1, d)
// growth_limit
// float interior = step(sdRhombohedron(p), 0.0); float dendrite_fill = fbm_dendrite(p) * interior;
