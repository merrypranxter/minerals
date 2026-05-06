// shaders/lessons/lesson-27.glsl
// Lesson 27: ALEXANDRITE: KELVIN-DRIVEN SPECTRAL ABSORPTION
// Category: Chromatic Adaptation / Electronic Transitions
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// alexandrite_logic(temp, angle)
// emerald = vec3(0.1, 0.6, 0.4)
// ruby = vec3(0.6, 0.1, 0.3)
// smoothstep(0.4, 0.6, temp + angle * 0.2)
// angle * 0.2
// pow(max(0.0, 1.0 - length(f)), 16.0)
// for(float lambda = 380.0; lambda < 750.0; lambda += 10.0) { float transmittance = alexandriteTransmittance(lambda, temp); X += transmittance * cmf_x(lambda); Y += transmittance * cmf_y(lambda); Z += transmittance * cmf_z(lambda); }
// vec3 left_color = alexandriteUnderIlluminant(D65, viewDir);
// vec3 right_color = alexandriteUnderIlluminant(A_source, viewDir);
// CCT = -449*n³ + 3525*n² - 6823.3*n + 5520.33
