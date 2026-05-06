// shaders/minerals/petrified-wood.glsl
// PETRIFIED WOOD
// Source: Weird Guy Mineral Shader Corpus

// 1. Biological ghost (polar)
float r = length(uv);
float theta = atan(uv.y, uv.x);

// 2. Geological attack (domain warp)
vec2 p = uv;
for(int i = 0; i < 3; i++) {
    p += cos(p.yx * 3.0 + u_time * 0.1) * 0.2;
    r += sin(p.x * 10.0 + p.y * 5.0) * 0.05;
}

// 3. Quantized strata (rings)
float rings = floor(r * 15.0 + cell_noise(uv * 0.1) * 2.0);
