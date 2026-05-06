// shaders/minerals/fantasy/gravity-crystal.glsl
// GRAVITY CRYSTAL (Spacetime Curvature)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Fantasy)

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform sampler2D u_background;
uniform vec2 u_mass_center;

// Gravitational lensing
vec2 gravitational_lens(vec2 p, vec2 mass, float mass_size) {
    vec2 delta = p - mass;
    float r = length(delta);

    // Einstein deflection angle
    float deflection = mass_size / (r + 0.01);

    // Bend light toward mass
    vec2 bend = normalize(delta) * deflection;

    return p + bend;
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Mass center
    vec2 mass = (u_mass_center / u_resolution - 0.5) * 2.0;
    float mass_size = 0.2;

    // Lensed background
    vec2 lensed_uv = gravitational_lens(uv, mass, mass_size);
    vec3 background = texture2D(u_background, lensed_uv * 0.5 + 0.5).rgb;

    // Einstein ring
    float ring_r = length(uv - mass);
    float einstein_ring = exp(-pow(ring_r - mass_size * 2.0, 2.0) * 100.0);

    // Accretion disk (hot matter falling in)
    float disk = smoothstep(mass_size * 0.5, mass_size * 2.0, ring_r);
    disk *= smoothstep(mass_size * 4.0, mass_size * 2.0, ring_r);
    vec3 disk_color = vec3(1.0, 0.5, 0.1) * disk;

    // Event horizon (black)
    float horizon = smoothstep(mass_size, mass_size * 0.5, ring_r);

    // Combine
    vec3 final = background * (1.0 - disk) + disk_color;
    final += vec3(0.5, 0.7, 1.0) * einstein_ring * 2.0;
    final *= 1.0 - horizon;

    gl_FragColor = vec4(final, 1.0);
}
