// shaders/lessons/lesson-24.glsl
// Lesson 24: IRIDESCENT GOETHITE (TURGITE): BOTRYOIDAL SPECTRAL MAP
// Category: Metallic Phase-Shifting / Curvature-Dependent Color
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// smin(d1, d2, 0.1)
// vec3 norm = normalize(vec3(d - d_eps_x, d - d_eps_y, 0.1))
// angle * 2.0 + curvature * 3.0 + u_time * 0.1
// spectral_palette
// spectral_palette(angle * 5.0) * 0.2 * (1.0 - smoothstep(0.0, 0.02, abs(d)))
// float phi = 4.0 * PI * n * thickness * cosTheta / lambda;
// float R = (r*r + r*r - 2.0*r*r*cos(phi)) / (1.0 + r*r*r*r - 2.0*r*r*cos(phi));
// float H = (d_xx + d_yy) * 0.5
// float K = d_xx * d_yy - d_xy*d_xy
// float crack_mask = smoothstep(0.03, 0.0, voronoiEdge);
