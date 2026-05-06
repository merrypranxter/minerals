// shaders/minerals/fantasy/shape-memory-alloy.glsl
// SHAPE-MEMORY ALLOY MINERAL
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Fantasy)

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform float u_temperature;

// Austenite (high temp) vs Martensite (low temp) phases
float phase_fraction(float temp, float transition_temp, float width) {
    return smoothstep(transition_temp - width, transition_temp + width, temp);
}

// Austenite shape (remembered)
float austenite_shape(vec2 p) {
    // Perfect cube
    float cube = max(abs(p.x), abs(p.y)) - 0.5;
    return cube;
}

// Martensite shape (deformed)
float martensite_shape(vec2 p, float deformation) {
    // Twinned, sheared
    vec2 sheared = p;
    sheared.x += sheared.y * deformation;

    float twin = abs(fract(sheared.x * 3.0) - 0.5) * 2.0;
    float shape = max(abs(sheared.x), abs(sheared.y)) - 0.5;

    return shape + twin * 0.02;
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Temperature control
    float temp = u_temperature;
    float austenite_frac = phase_fraction(temp, 0.5, 0.1);

    // Deformation from mouse (or time)
    float deformation = sin(u_time * 0.5) * 0.3;

    // Interpolate shapes
    float austenite = austenite_shape(uv);
    float martensite = martensite_shape(uv, deformation);
    float shape = mix(martensite, austenite, austenite_frac);

    float inside = smoothstep(0.02, -0.02, shape);
    float edge = smoothstep(0.05, 0.0, abs(shape));

    // Phase colors
    vec3 austenite_color = vec3(0.7, 0.7, 0.8); // Silvery
    vec3 martensite_color = vec3(0.5, 0.3, 0.3); // Darker, stressed
    vec3 color = mix(martensite_color, austenite_color, austenite_frac);

    // Twin boundaries visible in martensite
    float twins = abs(fract(uv.x * 3.0 + uv.y * deformation * 3.0) - 0.5) * 2.0;
    float twin_lines = smoothstep(0.95, 1.0, twins) * (1.0 - austenite_frac);
    color += vec3(0.3, 0.3, 0.4) * twin_lines;

    vec3 final = color * inside + vec3(0.9, 0.9, 1.0) * edge;

    gl_FragColor = vec4(final, 1.0);
}
