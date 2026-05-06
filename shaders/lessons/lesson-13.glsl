// shaders/lessons/lesson-13.glsl
// Lesson 13: FORDITE: STOCHASTIC MATERIAL ID STRATIFICATION
// Category: Industrial Deposition / Polymer Hysteresis
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// float layer_idx = floor(n * num_layers);
// vec3 dna = material_hash(layer_idx)
// step(0.99, sparkle) * step(0.7, glitter_prob)
// 1.0 - smoothstep(0.45, 0.5, abs(layer_fract - 0.5)) * 0.3
// color = sampleNextColor(prevColor, era_weights)
// vec2 p_warped = p + boundary_proximity * fbm(p * 50.0) * 0.02;
// layer_fract
// step(0.99, sparkle)
// vec3 flake_n = normalize(hash33(flake_id) * 2.0 - 1.0); float flake_spec = GGX(flake_n, viewDir, lightDir, 0.01);
