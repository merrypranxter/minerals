// shaders/lessons/lesson-04.glsl
// Lesson 04: PRECIOUS OPAL: VORONOI DOMAINS + BRAGG DIFFRACTION
// Category: Photonic Crystal / Domain-Based Color
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// lattice_seed
// fire_mask = pow(abs(interference), 20.0)
// vec3(0.1, 0.12, 0.15)
// 0.5 + 0.5 * cos(6.28318 * (vec3(1.0, 0.0, 0.5) * t + vec3(0.0, 0.33, 0.67)))
//  per Voronoi cell: 
// lambda = 2.0 * sphere_d * cosTheta;
// vec3 p_layer = p + viewDir * z * 0.5;
