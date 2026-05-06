// shaders/lessons/lesson-12.glsl
// Lesson 12: CHALCANTHITE: TRICLINIC SKEW MATRIX
// Category: Non-Orthogonal Crystallography / Lattice Vandalism
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// mat3 triclinic_skew() { return mat3(1.0, 0.2, 0.1, 0.3, 1.0, -0.2, 0.1, 0.1, 1.0); }
// . Recursive accretion: 
//  Deep vitriol: 
//  → electric cyan: 
//  driven by 
// mat3 G = mat3(a*a, a*b*cos(gamma), a*c*cos(beta), ...)
//  driving a 
// p + viewDir * 0.05 * thickness
// exp(-step * extinction)
