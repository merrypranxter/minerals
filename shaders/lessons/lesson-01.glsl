// shaders/lessons/lesson-01.glsl
// Lesson 01: AGATE / MALACHITE: RECURSIVE DOMAIN WARPING
// Category: Structural Color / Sedimentary Banding
// Source: MINERALS_LESSONS.md

float trap = 1e10;
for(int i=0; i<5; i++) {
  p = abs(p) / dot(p,p) - 0.6;
  trap = min(trap, length(p - vec2(0.5, 0.0)));
}
vec3 col = pal(trap, ...);
