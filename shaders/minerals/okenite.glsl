// shaders/minerals/okenite.glsl
// OKENITE
// Source: Weird Guy Mineral Shader Corpus

float r = length(uv);
float theta = atan(uv.y, uv.x);
float freq = 800.0;
float needles = sin(theta * freq + hash(theta) * 6.28) * 0.5 + 0.5;
float edge_mask = smoothstep(0.6, 0.4, r);
float hair_mask = pow(needles, 2.0) * edge_mask;
