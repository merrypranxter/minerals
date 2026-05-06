// shaders/lessons/lesson-15.glsl
// Lesson 15: STIBNITE: ACICULAR LANCE / HIGH-ASPECT ANISOTROPIC HOSTILITY
// Category: Ballistic Geometry / Longitudinal Striation
// Source: MINERALS_LESSONS.md

// Full Kajiya-Kay with diffuse + specular
float dotLT = dot(L, T);
float dotVT = dot(V, T);
float sinLT = sqrt(max(0.0, 1.0 - dotLT*dotLT));
float sinVT = sqrt(max(0.0, 1.0 - dotVT*dotVT));
float diffuse = sinLT;  // Diffuse component
float spec_arg = sinLT * sinVT - dotLT * dotVT;  // cos(alpha_r - alpha_i)
float specular = pow(max(0.0, spec_arg), 64.0);
vec3 color = base * diffuse + highlight * specular;
