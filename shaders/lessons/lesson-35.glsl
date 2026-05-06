// shaders/lessons/lesson-35.glsl
// Lesson 35: LONSDALEITE: HEXAGONAL IMPACT LATTICE / SHOCK LAMELLAE
// Category: Extra-Terrestrial / Hexagonal Crystal System
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// const vec3 k = vec3(-0.8660254, 0.5, 0.57735)
// p = abs(p); p.xy -= 2.0 * min(dot(k.xy, p.xy), 0.0) * k.xy;
// sin(p.z*100.0 + p.x*50.0) * 0.5 + 0.5
// vec3(1.0, 0.5, 0.0) * shock * 0.2
// vec3 proj = vec4_to_hex_3d(p_4d, u_time * 0.001);
// float shockR = u_time * shockSpeed; float shock_intensity = exp(-pow(length(p) - shockR, 2.0) / shockWidth);
