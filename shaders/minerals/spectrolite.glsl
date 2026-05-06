// shaders/minerals/spectrolite.glsl
// SPECTROLITE
// Source: Weird Guy Mineral Shader Corpus

// Internal twinning plane
vec3 flash_normal = normalize(vec3(0.2, 0.5, 1.0));
flash_normal.xy += 0.1 * sin(uv * 10.0 + u_time * 0.1);

// Alignment check
float alignment = dot(halfV, flash_normal);
float schiller_mask = pow(max(0.0, alignment), 64.0);
vec3 color_flash = spectrolite_color(alignment * 5.0 + u_time * 0.1);
