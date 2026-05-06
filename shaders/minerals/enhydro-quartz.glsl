// shaders/minerals/enhydro-quartz.glsl
// ENHYDRO QUARTZ
// Source: Weird Guy Mineral Shader Corpus

// Gravity from mouse
vec2 gravity_up = normalize(u_mouse / u_resolution - 0.5);

// Bubble seeks "up"
vec2 bubble_pos = cavity_pos + gravity_up * (cavity_radius * 0.7);
bubble_pos += sin(u_time * 2.0) * 0.02; // Wobble
