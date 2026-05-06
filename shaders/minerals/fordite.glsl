// shaders/minerals/fordite.glsl
// FORDITE
// Source: Weird Guy Mineral Shader Corpus

vec3 material_hash(float id) {
    return fract(sin(vec3(id * 12.989, id * 78.233, id * 45.164)) * 43758.5453);
}

// In main:
// float layer_idx = floor(n * 12.0);
// vec3 dna = material_hash(layer_idx);
// float roughness = dna.x;
// float glitter_prob = dna.y;
// float metallic = dna.z;
