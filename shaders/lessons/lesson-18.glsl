// shaders/lessons/lesson-18.glsl
// Lesson 18: PETRIFIED WOOD: LITHIFIED CELLULAR AUTOMATA
// Category: Dual-Lattice Replacement / Paleobotany
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// float rings = floor(r * 15.0 + cell_noise(uv * 0.1) * 2.0)
// pores = step(0.95, cell_noise(uv * 50.0 + rings))
// final *= pow(1.0 - r * 0.5, 8.0)
// float anisotropy = species_param;
// float ring_thickness = climate_data[int(rings)];
