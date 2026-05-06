// shaders/minerals/moonstone.glsl
// MOONSTONE
// Source: Weird Guy Mineral Shader Corpus

// Adularia cloud (Mie scattering)
vec2 cloud_uv = uv + viewDir.xy * 0.2;
float billow = 0.0;
for(int i = 1; i <= 3; i++) {
    float f = float(i) * 2.0;
    billow += cloud_noise(cloud_uv * f + u_time * 0.05) * (1.0 / f);
}

// Ghostly flash
float flash = pow(max(0.0, dot(viewDir, normalize(vec3(mouse, 1.0)))), 8.0);
vec3 final_glow = blue_ghost * flash * billow * 3.0;
