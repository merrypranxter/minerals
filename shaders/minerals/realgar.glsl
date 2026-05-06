// shaders/minerals/realgar.glsl
// REALGAR
// Source: Weird Guy Mineral Shader Corpus

// Decay accumulator
float prev_decay = texture2D(u_buffer, uv).r;
float light_exposure = smoothstep(0.4, 0.0, length(uv - u_mouse / u_resolution));
float current_decay = clamp(prev_decay + light_exposure * 0.005 + 0.001, 0.0, 1.0);

// Morph SDF to noise field as decay increases
float crystal_field = mix(d, d + (powder_noise - 0.5) * 0.5, current_decay);

// Red to yellow
vec3 color = mix(vec3(0.7, 0.0, 0.1), vec3(1.0, 0.8, 0.0), current_decay);
