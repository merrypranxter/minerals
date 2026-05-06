// shaders/lessons/lesson-19.glsl
// Lesson 19: WIDMANSTÄTTEN PATTERNS: OCTAHEDRAL HYPER-PLANAR SLICING
// Category: Extra-Terrestrial / 4D Geometry
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// float s1 = abs(fract(dot(p, n1) * 4.0) - 0.5);
// pattern = min(min(s1,s2), min(s3,s4))
// edge = smoothstep(0.02, 0.0, pattern - 0.01)
// fwidth(pattern)
// vec3 kamacite = vec3(0.35, 0.34, 0.32); vec3 taenite = vec3(0.42, 0.43, 0.45);
// vec4 p4 = vec4(p, u_time * 0.01);
// float h4 = abs(fract(dot(p4, normalize(vec4(1,1,1,1))) * 4.0) - 0.5);
// float schreibersite = step(0.98, fract(sin(dot(p, n1+n2)) * 10.0));
// darken = schreibersite * 0.5
