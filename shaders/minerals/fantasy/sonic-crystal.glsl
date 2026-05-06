// shaders/minerals/fantasy/sonic-crystal.glsl
// SONIC CRYSTAL (Phononic Band Gap)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Fantasy)

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform float u_frequency; // Sound frequency to visualize

// Phononic crystal lattice
float phononic_lattice(vec2 p, float lattice_size, float defect_size) {
    vec2 grid = p / lattice_size;
    vec2 id = floor(grid);
    vec2 f = fract(grid) - 0.5;

    // Scatterers at lattice points
    float scatterer = length(f) - 0.3;

    // Defect (cavity) at center
    float defect = length(p) - defect_size;

    // Combine: lattice with central defect
    return max(scatterer, -defect);
}

// Sound wave propagation
float sound_wave(vec2 p, float freq, float time, float band_gap) {
    // Waves that pass through
    float pass = sin(p.x * freq + time) * cos(p.y * freq * 0.7 + time);

    // Waves blocked by band gap
    float block = step(band_gap, freq) * 0.1;

    return pass * (1.0 - block);
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Crystal structure
    float lattice = phononic_lattice(uv * 5.0, 0.2, 0.15);
    float inside = smoothstep(0.02, -0.02, lattice);
    float edge = smoothstep(0.05, 0.0, abs(lattice));

    // Sound visualization
    float wave = sound_wave(uv, u_frequency, u_time * 5.0, 10.0);

    // Band gap: frequencies that can't pass
    float gap = step(8.0, u_frequency) * step(u_frequency, 12.0);

    // Colors: passing = blue, blocked = red, gap = black
    vec3 passing = vec3(0.2, 0.4, 0.9) * abs(wave);
    vec3 blocked = vec3(0.9, 0.2, 0.1) * (1.0 - abs(wave)) * 0.5;
    vec3 gap_color = vec3(0.05, 0.05, 0.05) * gap;

    vec3 final = passing + blocked + gap_color;

    // Crystal structure visible
    final += vec3(0.3, 0.3, 0.4) * edge;
    final *= 0.7 + inside * 0.3;

    gl_FragColor = vec4(final, 1.0);
}
