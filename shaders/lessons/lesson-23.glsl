// shaders/lessons/lesson-23.glsl
// Lesson 23: OKENITE: POLAR NEEDLE FUZZ / SUB-RESOLUTION DENSITY
// Category: High-Frequency Visual Softness / Volumetric Fuzz
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// float freq = 800.0
// float needles = sin(theta * freq + hash(theta) * 10.0)
// float hair_mask = pow(needles, 2.0) * edge_mask
// smoothstep(0.65, 0.55, r + needles * 0.05)
// sdCapsule(p, root, tip, radius)
// float mie = (1.0 - g*g) / pow(1.0 + g*g - 2.0*g*cosTheta, 1.5);
// transmitted = base_glow * mie_phase * exp(-density * extinction)
// fuzz_intensity(uv, center[i], radius[i])
