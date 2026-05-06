// shaders/lessons/lesson-03.glsl
// Lesson 03: BOTRYOIDAL / HEMATITE: SMOOTH-MIN SPHERE PACKING
// Category: Organic Growth / Merging Geometry
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// smin(a, b, k)
// float h = clamp(0.5 + 0.5*(b-a)/k, 0.0, 1.0); return mix(b, a, h) - k*h*(1.0-h);
// sin(vec3(i*1.5, i*2.2, i*3.1) + u_time*0.1) * 0.3
// return -log2(exp2(-k*a) + exp2(-k*b)) / k;
// (a^n + b^n)^(1/n)
//  parameter with 
// . Low k = touching spheres with sharp seams (fresh growth). High k = fully merged blob (mature botryoidal). 
// vec2 e = vec2(0.001, 0.0); float curv = 2.0*d - sdBotryoid(p+e.xyy) - sdBotryoid(p-e.xyy);
