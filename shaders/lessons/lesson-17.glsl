// shaders/lessons/lesson-17.glsl
// Lesson 17: REALGAR: PHOTONIC DECAY HYSTERESIS
// Category: Temporal Morphogenesis / Photodegradation
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// p.xy *= mat2(1.1, 0.4, -0.1, 1.0)
// current_decay = clamp(prev_decay + light_exposure * 0.005 + 0.0001, 0.0, 1.0)
//  means it ALWAYS degrades even without mouse. Geometry morph: 
// mix(realgar_red, pararealgar_yellow, current_decay)
//  increases, Voronoi cell boundaries become visible: 
// current_decay > 0.5
// if (decayMap[pixel] > 0.5) spawnParticle(pixel, { velocity: up + random() * spread, color: pararealgar_yellow })
// float uv_intensity = pow(max(0.0, 1.0 - wavelength_normalized), 3.0);
// wavelength_normalized
