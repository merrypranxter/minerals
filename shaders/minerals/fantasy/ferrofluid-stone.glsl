// shaders/minerals/fantasy/ferrofluid-stone.glsl
// FERROFLUID STONE (Magnetic Liquid Solid)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Fantasy)

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

// Ferrofluid spikes following magnetic field
float ferro_spike(vec2 p, vec2 base, vec2 field_dir, float strength) {
    vec2 local = p - base;
    float along = dot(local, field_dir);
    float across = length(local - field_dir * along);

    // Spike height proportional to field strength
    float height = strength * exp(-across * across * 20.0);
    float spike = smoothstep(height, height - 0.05, along) * step(0.0, along);

    return spike;
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Magnetic field from mouse
    vec2 field = normalize((u_mouse / u_resolution - 0.5) * 2.0 - uv);
    float strength = 1.0 / (length((u_mouse / u_resolution - 0.5) * 2.0 - uv) + 0.1);

    // Base pool
    float pool = smoothstep(0.6, 0.5, length(uv * vec2(1.0, 0.7)));

    // Spikes
    float spikes = 0.0;
    for(int i = 0; i < 30; i++) {
        float fi = float(i);
        vec2 base = vec2(sin(fi * 2.1) * 0.4, cos(fi * 1.9) * 0.3);
        spikes += ferro_spike(uv, base, field, strength * 0.3);
    }

    // Ferrofluid: black with metallic sheen
    vec3 fluid = vec3(0.05, 0.05, 0.05) * pool;
    vec3 sheen = vec3(0.3, 0.3, 0.4) * spikes * strength * 3.0;

    // Oil rainbow on surface
    float oil = fbm(uv * 5.0 + u_time * 0.1);
    vec3 rainbow = 0.5 + 0.5 * cos(oil * 10.0 + vec3(0.0, 2.09, 4.19));

    vec3 final = fluid + sheen + rainbow * pool * 0.2;

    gl_FragColor = vec4(final, 1.0);
}
