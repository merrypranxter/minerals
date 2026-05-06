// shaders/lessons/lesson-28.glsl
// Lesson 28: ENHYDRO QUARTZ: GRAVITY-AWARE FLUID VOID
// Category: Hydrostatics / Gravity-Aligned SDF
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// max(abs(uv.x), abs(uv.y)) - 0.7
// pow(1.0 - dist_to_bubble * 12.0, 2.0)
// float water_level = sphWaterHeight(uv, particles);
// float meniscus_curve = -exp(-dist_to_wall * 20.0) * 0.03;
// float bubble_meniscus = exp(-dist_to_bubble * 10.0) * curvature;
// float ior_bubble = 1.0 + cretaceous_co2_ppm * co2_refractivity;
