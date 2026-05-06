// shaders/minerals/ludwigite-vonsenite.glsl
// LUDWIGITE-VONSENITE
// Source: Weird Guy Mineral Shader Corpus

// Radiating tangent
vec2 tangent = normalize(uv);

// Kajiya-Kay specular
vec3 halfV = normalize(viewDir + lightDir);
float dotTH = dot(vec3(tangent, 0.0), halfV);
float sinTH = sqrt(1.0 - dotTH * dotTH);
float spec = pow(sinTH, 128.0);
