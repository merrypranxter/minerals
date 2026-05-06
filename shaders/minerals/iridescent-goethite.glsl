// shaders/minerals/iridescent-goethite.glsl
// IRIDESCENT GOETHITE (TURGITE)
// Source: Weird Guy Mineral Shader Corpus

// Botryoidal habit
float d = length(uv - vec2(sin(u_time * 0.2) * 0.2)) - 0.4;
d = smin(d, length(uv - vec2(0.3, 0.2)) - 0.3, 0.1);
d = smin(d, length(uv - vec2(-0.2, -0.3)) - 0.35, 0.1);

// Curvature from distance field
float curvature = 1.0 - abs(d * 5.0);
float phase = angle * 2.0 + curvature * 3.0 + u_time * 0.1;
