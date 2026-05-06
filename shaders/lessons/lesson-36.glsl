// shaders/lessons/lesson-36.glsl
// Lesson 36: MAGMA: THERMAL-KINETIC ADVECTION / BLACKBODY RADIATION
// Category: Pre-Lithic Fluid Dynamics / Emissive Source
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// vec2 flow(p) = vec2(sin(p.y + t), cos(p.x - t))
// p += flow(p * 1.5) * 0.1
// sum ridge(sin(dot(n_p, vec2(1.2, 0.8)))) * amp
// T = pow(heat, 2.5)
// hot * pow(T, 8.0) * 0.5
// float T_kelvin = 400.0 + heat * 1600.0;
// float lambda_peak = 2898000.0 / T_kelvin;
// vec2 vel_new = vel - grad(pressure) * dt;
//  is solved by the Poisson equation 
// float plume = exp(-pow(uv.x - vent_x, 2.0) / sigma_x) * exp(-uv.y / scale_height);
