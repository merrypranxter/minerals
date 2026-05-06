// shaders/lessons/lesson-30.glsl
// Lesson 30: CAVANSITE: RADIATING PRISMATIC VOIDS / ELECTRIC ROSETTES
// Category: Saturated Geometric Rosettes / High-Contrast AO
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// needle_noise(p)
// pow(abs(sin(n.x*60.0)*sin(n.y*60.0)*sin(n.z*60.0)), 0.5)
// sdRosette(p, r)
// length(p) - (r + needle_noise(p)*0.15)
// neon_blue = vec3(0.0, 0.4, 2.5)
// vec3(0.0, 0.05, 0.2)
// mix(deep_indigo, neon_blue, ao)
// float sh_l2_m2 = sqrt(15.0/PI) * n.x * n.y;
// float sh_l3_m3 = 0.25 * sqrt(35.0/(2.0*PI)) * (3*n.x*n.x - n.y*n.y) * n.y;
// needle_noise
