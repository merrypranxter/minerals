// shaders/lessons/lesson-22.glsl
// Lesson 22: SERAPHINITE: CURL-NOISE CHATOYANCY (FEATHERED TANGENT)
// Category: Vector Field Specularity / Curl-Noise Flow
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// get_feather_tangent(p)
// (noise(p+eps) - noise(p-eps)) / (2*eps)
// pow(1.0 - abs(dot(light_dir.xy, tangent)), 16.0)
// vec3(0.02, 0.1, 0.05)
// curlField = vec3(dFz/dy - dFy/dz, dFx/dz - dFz/dx, dFy/dx - dFx/dy)
// , step along 
//  for N steps, accumulate 
// float density = mix(0.3, 1.5, audio_band_3);
// audio_spectrum
