// shaders/lessons/lesson-06.glsl
// Lesson 06: BISMUTH: MANHATTAN DISTANCE HOPPER CRYSTALS
// Category: Non-Euclidean Geometry / Recursive Voids
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// p = abs(p) - 0.5; p *= 1.5; scale *= 1.5; float step_d = l1_norm(p) / scale; d = max(d, step_d);
// 0.5 + 0.5 * cos(time + d * 50.0 + vec3(0,2,4))
//  creates the rainbow step-bands. Edge detection via 
// float linf_norm(vec3 p) { return max(abs(p.x), max(abs(p.y), abs(p.z))); }
// mix(l1_norm(p), linf_norm(p), 0.5)
// float thickness = fract(d * frequency) * edge_proximity;
// edge_proximity = smoothstep(0.0, 0.1, fract(d * 5.0));
//  to drive the 
//  subtraction offset in the IFS loop: 
