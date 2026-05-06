// shaders/lessons/lesson-34.glsl
// Lesson 34: LUDWIGITE-VONSENITE: KAJIYA-KAY RADIATING ANISOTROPY
// Category: Ferro-Borate / High-Aspect Fiber Specularity
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// sin(theta * 500.0 + sin(dist*10.0))
// vec3(0.02, 0.02, 0.03)
// vec3(0.6, 0.65, 0.8)
// vec3(0.1, 0.05, 0.2) * pow(1.0 - dist, 4.0)
// vec3 B = (3.0 * dot(m, r_hat) * r_hat - m) / pow(length(r), 3.0);
// m = magnetization_vector
//  rotating with 
// float fiber_density = exp(-dist * 3.0) * fiber_frequency;
// float void_hole = -(length(uv) - 0.15)
