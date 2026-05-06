// shaders/lessons/lesson-16.glsl
// Lesson 16: CROCOITE: HOLLOW PRISMATIC SKELETON (MONOCLINIC SIPHON)
// Category: Skeletal Crystallography / Hollow SDF Subtraction
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// sdHollowPrism
// length(p.xz) - (h.x * 0.8)
// vec3(1.5, 0.5, 0.0)
// exp(-t * 0.3)
// pow(1.0 - d * 20.0, 16.0)
// float ior_r = 2.31; float ior_g = 2.36; float ior_b = 2.42;
// F → F[+F][-F]FF
// sdHollowPrism
// vec3 oklch_color = vec3(0.7, 0.25, 30.0);
// toLinearRGB(oklch_to_linear(oklch_color))
