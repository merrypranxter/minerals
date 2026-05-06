// shaders/minerals/magma.glsl
// MAGMA
// Source: Weird Guy Mineral Shader Corpus

// Blackbody approximation
float T = pow(heat, 2.5);
vec3 hot = vec3(1.8, 0.6, 0.1);   // Blinding orange
vec3 mid = vec3(0.5, 0.05, 0.01); // Blood red
vec3 cold = vec3(0.02, 0.01, 0.0); // Cooling basalt

vec3 magmatic_col = mix(cold, mid, smoothstep(0.2, 0.6, T));
magmatic_col = mix(magmatic_col, hot, smoothstep(0.6, 1.2, T));

// Emissive bloom
magmatic_col += hot * pow(T, 8.0) * 0.5;
