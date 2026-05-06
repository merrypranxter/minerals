// shaders/lessons/lesson-05.glsl
// Lesson 05: TIGER'S EYE: ANISOTROPIC FIBER SHADING (CHATOYANCY)
// Category: Anisotropic Specularity / Fiber Optics
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// float dotLT = dot(L, T); float dotVT = dot(V, T); float chatoyancy = pow(sqrt(1.0-dotLT*dotLT) * sqrt(1.0-dotVT*dotVT) - dotLT*dotVT, 32.0);
// float sinTH = sqrt(max(0.0, 1.0 - dot(T,H)*dot(T,H))); float spec = pow(sinTH, N);
// sqrt(1.0 - dot(T,L)*dot(T,L))
// T_perp = normalize(cross(T, vec3(0,0,1)))
