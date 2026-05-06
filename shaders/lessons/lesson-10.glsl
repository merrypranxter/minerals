// shaders/lessons/lesson-10.glsl
// Lesson 10: CUMMINGTONITE: POLAR ENTROPY / RADIATING FIBER MANIFOLD
// Category: Polar Coordinate Shading / Angular Anisotropy
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// float needles = 0.0; for(int i=1; i<=5; i++) { float f = float(i) * 20.0; needles += sin(theta * f + u_time * 0.5 + fiber_noise(theta)) * (1.0/float(i)); }
// float mouse_theta = atan(mouse_pos); float highlight = pow(max(0.0, cos(theta - mouse_theta)), 16.0);
// float gabor(vec2 p, vec2 freq) { return exp(-dot(p,p) * 2.0) * cos(dot(p, freq)); }
// float lissajous = sin(theta * A + u_time * speed_a) * sin(theta * B + u_time * speed_b);
// vec3 absorption = vec3(0.2, 0.1, 0.05) * (1.0 - cos(theta - fiber_theta));
