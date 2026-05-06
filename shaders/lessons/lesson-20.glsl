// shaders/lessons/lesson-20.glsl
// Lesson 20: COVELLITE: SUBTRACTIVE INTERFERENCE MAPPING
// Category: Quantum Electrodynamics Approximation / Dielectric Loss
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// covellite_palette(t)
// base = vec3(0.02, 0.05, 0.2) + vec3(0.1, 0.8, 1.0) * pow(sin(t * 6.28 + vec3(0, 1.2, 2.5)), vec3(4.0))
// float edge_leak = pow(1.0 - abs(d), 8.0); vec3 brass = vec3(0.8, 0.6, 0.2) * edge_leak
// pow(max(0.0, 1.0 - length(p * 0.1)), 64.0)
// vec2 ior_o = vec2(1.45, 0.21); vec2 ior_e = vec2(4.0, 2.5);
// Fs = abs((ni - nt) / (ni + nt))^2
// float age = mod(u_time * 0.01, 1.0)
// vec2 hex_uv = hexToGrid(uv); vec2 cell = floor(hex_uv); float hex_d = hexDist(fract(hex_uv) - 0.5);
