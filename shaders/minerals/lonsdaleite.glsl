// shaders/minerals/lonsdaleite.glsl
// LONSDALEITE
// Source: Weird Guy Mineral Shader Corpus

// Hexagonal prism SDF
float d = sdHexPrism(p, vec2(0.6, 1.2));

// Internal shock lamellae
float lamellae = sin(p.z * 100.0 + p.x * 50.0) * 0.5 + 0.5;

// Hardness glint
float spec = pow(max(0.0, dot(norm, vec3(0, 0, 1))), 512.0);
