// shaders/lessons/lesson-25.glsl
// Lesson 25: YOOPERLITE: UV-REACTIVE FLUORESCENCE TOGGLE
// Category: Spectral Toggle / Emissive Reveal
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// vec3(0.2, 0.21, 0.23)
// smoothstep(0.5, 0.1, length(uv - mouse))
// pow(1.0 - sodalite_cells(uv * 8.0), 4.0) * vec3(1.0, 0.4, 0.0) * 5.0
// vec3(0.1, 0.0, 0.4) * uv_lens * 0.5
// float fluor_intensity = excitation_flux * quantum_yield;
// vec3(1.0, 0.55, 0.0)
// float glow = texture2D(u_buffer, uv).r * 0.995 + new_excitation;
// float quench = 1.0 - step(0.3, quench_noise(uv * 3.0));
