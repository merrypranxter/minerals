// shaders/minerals/obsidian.glsl
// OBSIDIAN (Volcanic Glass / Conchoidal Fracture)
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

// Conchoidal fracture pattern
float conchoidal(vec2 p, vec2 center, float scale) {
    vec2 local = (p - center) * scale;
    float r = length(local);
    float theta = atan(local.y, local.x);
    // Shell-like curves
    float shell = r - sin(theta * 3.0 + r * 5.0) * 0.1;
    return smoothstep(0.5, 0.0, shell);
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Flow banding from viscous lava
    float flow = sin(uv.x * 3.0 + uv.y * 5.0 + fbm(uv * 2.0) * 2.0);
    float bands = smoothstep(-0.3, 0.3, flow);

    // Multiple fracture centers
    float fracture = 0.0;
    for(int i = 0; i < 5; i++) {
        vec2 center = vec2(
            sin(float(i) * 2.5 + u_time * 0.1) * 0.5,
            cos(float(i) * 1.7) * 0.5
        );
        fracture += conchoidal(uv, center, 3.0 + float(i));
    }

    // Obsidian colors: black, mahogany, snowflake (cristobalite inclusions)
    vec3 black = vec3(0.02, 0.02, 0.03);
    vec3 mahogany = vec3(0.15, 0.05, 0.03);
    vec3 snowflake = vec3(0.9, 0.9, 0.85);

    // Flow bands = color variation
    vec3 color = mix(black, mahogany, bands);

    // Fracture edges = sharp highlight
    float edge = smoothstep(0.1, 0.0, fracture);
    color += vec3(0.3, 0.3, 0.4) * edge * 2.0; // Glassy edge

    // Snowflake inclusions (random white spots)
    float snow = step(0.97, fbm(uv * 15.0));
    color = mix(color, snowflake, snow * 0.3);

    // Glassy reflection
    float gloss = pow(1.0 - abs(uv.x), 8.0) * 0.3;
    color += vec3(0.2, 0.2, 0.3) * gloss;

    gl_FragColor = vec4(color, 1.0);
}
