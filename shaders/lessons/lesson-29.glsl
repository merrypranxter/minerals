// shaders/lessons/lesson-29.glsl
// Lesson 29: MOONSTONE: ADULARESCENCE / SUBSURFACE SCATTERING ANISOTROPY
// Category: Mie Scattering / Internal Volume Glow
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// cloud_noise(cloud_uv * float(i) + u_time * 0.05) * (1.0/float(i))
// pow(max(0.0, dot(viewDir, normalize(vec3(mouse, 1.0)))), 8.0)
// pow(dist, 4.0) * sphere_mask
// float g = 0.8;  // asymmetry parameter
// float mie_phase = (1.0 - g*g) / pow(4.0 * PI * (1.0 + g*g - 2.0*g*cosTheta), 1.5);
// for(int k=0; k<N_LAYERS; k++) { float delta = 4.0*PI*n*layer_thickness[k]*cosTheta/lambda; R += r[k] * exp(2.0*PI*i * (sum_delta)); }
// flash > 0.7
// vec3 rainbow = 0.5 + 0.5 * cos(6.28 * (flash + vec3(0, 0.33, 0.67)));
// mix(adularescence, rainbow, flash_strength - 0.7)
