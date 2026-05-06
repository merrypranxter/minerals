// shaders/minerals/widmanstatten.glsl
// WIDMANSTÄTTEN
// Source: Weird Guy Mineral Shader Corpus

const vec3 n1 = normalize(vec3(1, 1, 1));
const vec3 n2 = normalize(vec3(-1, 1, 1));
const vec3 n3 = normalize(vec3(1, -1, 1));
const vec3 n4 = normalize(vec3(1, 1, -1));

// Slicing plane
float s1 = abs(fract(dot(p, n1) * 4.0) - 0.5);
// ... etc
float pattern = min(min(s1, s2), min(s3, s4));
float edge = smoothstep(0.02, 0.0, pattern - 0.01);
