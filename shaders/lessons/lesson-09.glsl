// shaders/lessons/lesson-09.glsl
// Lesson 09: URANINITE: STOCHASTIC DECAY ENGINE
// Category: Radioactive Decay / Inverse-Square Physics
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// float intensity = 0.01 / (d*d + 0.001); intensity *= exp(-0.1 * u_time);
// float particle_hit = step(0.99, noise * intensity * 50.0)
// v = normalize(sin(vec3(u_time * 1.1, u_time * 0.7, u_time * 1.3)))
// abs(dot(normalize(p), v) - cos(cherenkovAngle)) < epsilon
// float track = sdCapsule(p, origin, origin + dir * length, 0.02);
//  increases near the source, progressively decouple RGB channels with different spatial offsets: 
