// shaders/lessons/lesson-08.glsl
// Lesson 08: PYRITE: BRUTALIST SDF TWINNING
// Category: Metallic Geometry / Crystal Twinning
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// p.xy *= mat2(cos(a), -sin(a), sin(a), cos(a)); p = abs(p) - 0.2; d = min(d, sdBox(p, vec3(0.4)));
// a = 0.785398
// float striations = sin(p.x * 100.0) * 0.5 + 0.5;
// vec3(0.8, 0.6, 0.2) * striations
// float D = (roughness*roughness) / (PI * pow(NdotH*NdotH*(roughness*roughness - 1.0) + 1.0, 2.0));
// vec3(0.95, 0.82, 0.38)
// float sdPyritohedron(vec3 p) { float c = dot(abs(p), normalize(vec3(1.618, 1.0, 0.0))); float d = dot(abs(p), normalize(vec3(0.0, 1.618, 1.0))); return max(c, max(d, max(abs(p.x), max(abs(p.y), abs(p.z))))) - r; }
// vec3 n_perturb = n + vec3(sin(p.x * 200.0) * 0.1, 0.0, 0.0);
