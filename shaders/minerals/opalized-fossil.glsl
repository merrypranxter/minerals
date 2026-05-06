// shaders/minerals/opalized-fossil.glsl
// OPALIZED FOSSIL
// Source: Weird Guy Mineral Shader Corpus

// Ammonite SDF
float r = length(uv);
float theta = atan(uv.y, uv.x);
float spiral = fract(log(r) * 1.5 - theta * 0.159);

// Opal interior (Voronoi patches)
vec3 p = vec3(uv * 5.0, sin(u_time * 0.1));
float domain = voronoi_patches(p);

// Diffraction per patch
float cosTheta = dot(viewDir, lightDir);
vec3 opal_fire = bragg_color(domain * 1.5, cosTheta);
