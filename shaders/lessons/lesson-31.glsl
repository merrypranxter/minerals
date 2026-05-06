// shaders/lessons/lesson-31.glsl
// Lesson 31: SPECTROLITE: LAMELLAR INTERFERENCE PLANES (BØGGILD TRAP)
// Category: Full-Spectrum Feldspar Fire / Half-Vector Alignment
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// flash_normal
// 0.1 * sin(uv * 10.0 + u_time * 0.1)
// spectrolite_color(angle)
// pow(0.5 + 0.5*cos(6.28*(angle + vec3(0.0, 0.33, 0.67))), vec3(2.0)) * 2.0
// vec3(0.02, 0.02, 0.03)
// flash_normals[]
// for(int t=0; t<4; t++) { alignment[t] = dot(halfV, warpedNormal(flash_normal[t])); schiller += spectrolite_color(alignment[t] * freq_shift[t]) * pow(max(0.0, alignment[t]), sharpness[t]); }
// DeviceOrientationEvent
// window.addEventListener('deviceorientation', (e) => { u_lightDir = quaternionFromEuler(e.alpha, e.beta, e.gamma) * baseLight; });
