// shaders/lessons/lesson-38.glsl
// Lesson 38: META-MINERAL: REACTION-DIFFUSION CALCIFICATION
// Category: Morphogenetic / Gray-Scott Foundation
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// nextA = a + (Da * nabla2A - a*b*b + feed*(1-a))
// nextB = b + (Db * nabla2G + a*b*b - (k+feed)*b)
// float kill = 0.062 + pressure * 0.005
// vec3(nextA, nextB, abs(nextA-nextB))
// mat2 D = mat2(da_x, 0.0, 0.0, da_y)
// da_x ≠ da_y
// da_c = 0.2
// da_ab = 0.1
// geological_time
//  (deposition phase) → coral-forming params; 
