// shaders/lessons/lesson-26.glsl
// Lesson 26: RUTILATED QUARTZ: INTERNAL PARALLAX INCLUSIONS
// Category: Volumetric Depth Deception / Nested Raymarching
// Source: MINERALS_LESSONS.md

// On entry to crystal surface, bend ray
vec3 refracted = refract(rd, surfaceNormal, 1.0/1.544);  // Quartz IOR
// March refracted ray through interior
for(int i=0; i<30; i++) {
  vec3 p = entry_pos + refracted * t_interior;
  float needle_d = sdNeedle(p, needle_a, needle_b, 0.003);
  // ...
}
