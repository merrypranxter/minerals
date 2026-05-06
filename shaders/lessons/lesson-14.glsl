// shaders/lessons/lesson-14.glsl
// Lesson 14: VIVIANITE: TEMPORAL OXIDATION BUFFERS
// Category: Reactive / Photochromic Minerals
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// float current_exposure = clamp(prev_exposure + light_hit * 0.01, 0.0, 1.0)
// vec3(0.8, 0.9, 0.8) * d
// vec3(0.0, 0.05, 0.15) * d
// mix(ghost_state, bruised_state, current_exposure)
// float spread = max(max(texture2D(u_buffer, uv + e.xy).r, texture2D(u_buffer, uv - e.xy).r), max(texture2D(u_buffer, uv + e.yx).r, texture2D(u_buffer, uv - e.yx).r));
// floor(exposure * 4.0)
// fract(exposure * 4.0)
// , use a sigmoid approach: 
