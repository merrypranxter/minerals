// shaders/lessons/lesson-33.glsl
// Lesson 33: OPALIZED FOSSIL: BIOMORPHIC BRAGG DIFFRACTION
// Category: Biological SDF + Photonic Crystal
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// shell_mask = step(r, 0.8) * step(0.1, r)
// hash33(floor(p))
// interference = dot(viewDir, lightDir)
// fire_color = bragg_color(domain * 1.5, cosTheta)
// vec3(0.1, 0.12, 0.15)
// float whorl = log(r) / log(growth_rate); float chamber = fract(whorl * 14.0);
// chamber_index
// float nacre_d = 0.0005; float nacre_n = 1.53;
