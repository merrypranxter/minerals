// shaders/lessons/lesson-39.glsl
// Lesson 39: META-MINERAL: CELLULAR AUTOMATA UNCLAMPED ACCRETION
// Category: MNCA / Floating-Point Logic Storm
// Source: MINERALS_LESSONS.md

// Key techniques (inline snippets):
// r1=1.0, r2=3.0, r3=8.0
// if(r1 > 0.2 && r1 < 0.5) state += 0.05; if(r2 > 0.6) state -= 0.1; if(r3 < 0.1) state *= 1.01;
// vec3(state*0.1, state*state, exp(state))
// K(r) = exp(4.0 - 1.0/(r*(1.0-r) + eps))
// U(x) = convolve(A, K)(x);
// dA/dt = clamp(growth(U), -1, 1)
// growth(u) = 2*exp(-pow((u-mu)/sigma, 2.0)) - 1;
// uint rule110(uint left, uint center, uint right) { return (rule & (1 << (left*4 + center*2 + right))) >> (left*4 + center*2 + right); }
