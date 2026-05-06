// shaders/minerals/azurite-malachite.glsl
// AZURITE-MALACHITE (The Copper Gradient)
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

// Reaction-diffusion approximation for mineral front
float chemical_front(vec2 p, float t) {
    // Azurite (blue) retreats, malachite (green) advances
    float wave = sin(p.x * 2.0 + p.y * 1.5 + t * 0.3);
    float noise = fbm(p * 3.0 + t * 0.1);
    return smoothstep(-0.2, 0.2, wave + noise * 0.5);
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Banding from both minerals
    float band_azurite = sin(uv.x * 8.0 + fbm(uv * 2.0) * 2.0);
    float band_malachite = sin(uv.y * 6.0 + fbm(uv * 1.5 + 100.0) * 3.0);

    // Chemical front position
    float front = chemical_front(uv, u_time);

    // Colors
    vec3 azurite = vec3(0.05, 0.15, 0.6);  // Deep azure
    vec3 malachite = vec3(0.05, 0.4, 0.15); // Rich green
    vec3 transition = vec3(0.1, 0.3, 0.4);  // Teal boundary

    // Mix based on front
    vec3 color = mix(azurite, malachite, front);
    color = mix(color, transition, smoothstep(0.4, 0.6, front) * smoothstep(0.6, 0.4, front));

    // Concentric banding from each
    float bands = smoothstep(-0.2, 0.2, band_azurite) * (1.0 - front) 
                + smoothstep(-0.2, 0.2, band_malachite) * front;
    color *= 0.7 + bands * 0.6;

    // Fibrous malachite texture on green side
    float fibers = pow(abs(sin(uv.x * 50.0 + uv.y * 30.0)), 4.0);
    color += malachite * fibers * front * 0.3;

    gl_FragColor = vec4(color, 1.0);
}
