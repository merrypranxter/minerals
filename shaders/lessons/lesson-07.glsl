// shaders/lessons/lesson-07.glsl
// Lesson 07: AMETHYST GEODE: INVERSION CAVITY KIFS
// Category: Negative Space Rendering / Volumetric Raymarch
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// d = max(d, -crystals)
// d = -(length(p) - 1.2)
// vec3(0.4, 0.1, 0.8) * (1.5 / (t*t))
// float inside_dist = max(0.0, prev_t - entry_t);
// vec3 absorption = exp(-inside_dist * vec3(0.5, 1.0, 0.3));
// float tip_proximity = exp(-length(p_crystal) * 10.0); finalColor += vec3(0.8, 0.5, 1.0) * tip_proximity * flash;
// float druzy = step(0.95, fract(sin(dot(p_crystal * 100.0, vec3(12.98, 78.23, 43.76))) * 43758.0));
