// shaders/lessons/lesson-32.glsl
// Lesson 32: AMBER: CHRONO-RESIN VOLUME
// Category: Organic Chemistry / Paleontological Preservation
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// honey = vec3(1.0, 0.7, 0.1)
// cognac = vec3(0.4, 0.1, 0.0)
// mix(honey, cognac, pow(depth, 2.0))
// z = float(i)*0.15
// p_z = uv + viewDir.xy * z
// debris = step(0.98, flow_noise(p_z * 5.0)) * (1.0 - z)
// vec3 extinction = vec3(0.1, 0.5, 2.0);
// vec3 transmittance = exp(-extinction * ray_length_through_amber);
// float surface_grazing = pow(max(0.0, 1.0 - abs(dot(viewDir, surfaceNormal))), 4.0);
// vec3 blue_fluor = vec3(0.0, 0.4, 1.0) * surface_grazing * uv_proximity;
