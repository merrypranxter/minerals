// shaders/minerals/yooperlite.glsl
// YOOPERLITE
// Source: Weird Guy Mineral Shader Corpus

// Base: dull syenite
vec3 stone = vec3(0.2, 0.21, 0.23) + noise * 0.05;

// UV reveal
float uv_lens = smoothstep(0.5, 0.1, length(uv - mouse));

// Glowing sodalite cells
float cells = sodalite_cells(uv * 8.0);
float fire_mask = pow(1.0 - cells, 4.0);
vec3 fire_color = vec3(1.0, 0.4, 0.0) * fire_mask * 5.0;

vec3 final = mix(stone, stone + fire_color, uv_lens);
