// shaders/lessons/lesson-11.glsl
// Lesson 11: MUSCOVITE / MICA: ITERATIVE LAYER PEELING
// Category: Dielectric Stacking / Sub-Atomic Cleavage
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// vec3 spectral_shift = vec3(0.1, 0.2, 0.3); return 0.5 + 0.5 * cos(6.28318 * (spectral_shift * d * cosTheta + u_time * 0.1));
// final_color += contribution * (1.0 - total_alpha); total_alpha += mask * 0.2;
// step(0.4 + float(i)*0.05, flake_noise)
// float gap = curvature * r * r;
// float ring = sin(2.0 * PI * 2.0 * gap / lambda);
// vec2 uv_o = uv; vec2 uv_e = uv + viewDir.xy * 0.01 * birefringence;
