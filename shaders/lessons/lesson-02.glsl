// shaders/lessons/lesson-02.glsl
// Lesson 02: LABRADORITE: THIN-FILM INTERFERENCE (BRAGG SCATTERING GHOST)
// Category: Structural Color / Anisotropic Interference
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// smoothstep(0.9, 0.98, phase)
// vec3(0.05, 0.06, 0.08)
//  with the stone_noise seeding the offset. 
// float F = F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
// exp(-(dotHX*dotHX/ax + dotHY*dotHY/ay) / (dotNH*dotNH))
// n in {1, 2, 3}
// float lambda_n = 2.0 * d * cosTheta / float(n);
