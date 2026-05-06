// shaders/minerals/fantasy/plasma-crystal.glsl
// PLASMA CRYSTAL (Ionized Gas Solid)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Fantasy)

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

// Ion lattice with electron flow
float ion_lattice(vec2 p, float lattice_spacing, float disorder) {
    vec2 grid = p / lattice_spacing;
    vec2 id = floor(grid);
    vec2 f = fract(grid) - 0.5;

    // Ions at lattice points (jittered by disorder)
    vec2 ion_pos = f - (hash21(id) - 0.5) * disorder;
    float ion = length(ion_pos);

    return ion;
}

// Electron flow between ions
vec3 electron_flow(vec2 p, float time) {
    // Streamers following potential gradients
    float streamer = 0.0;
    for(int i = 0; i < 8; i++) {
        float fi = float(i);
        vec2 start = vec2(sin(fi * 2.5) * 0.5, cos(fi * 1.7) * 0.5);
        vec2 dir = normalize(p - start);
        float d = length(p - start);

        // Bifurcating streamers
        float branch = sin(atan(dir.y, dir.x) * 3.0 + time * 5.0 + fi);
        streamer += exp(-d * d * 10.0) * smoothstep(-0.5, 0.5, branch) * (1.0 + sin(time * 10.0 + fi));
    }

    // Plasma colors: violet core, blue halo, white hot
    vec3 core = vec3(0.8, 0.0, 1.0) * streamer;
    vec3 halo = vec3(0.2, 0.4, 1.0) * streamer * 0.5;
    vec3 hot = vec3(1.0, 0.9, 1.0) * pow(streamer, 4.0) * 2.0;

    return core + halo + hot;
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Crystal boundary
    float crystal = smoothstep(0.8, 0.7, length(uv));

    // Ion lattice
    float lattice = ion_lattice(uv * 3.0, 0.3, 0.1);
    float ion_glow = exp(-lattice * lattice * 50.0);

    // Electron flow
    vec3 plasma = electron_flow(uv, u_time);

    // Lattice structure visible as faint grid
    vec3 grid = vec3(0.1, 0.05, 0.2) * ion_glow;

    // Combine
    vec3 final = grid + plasma;

    // Mouse attracts electrons (electromagnetic)
    vec2 mouse = (u_mouse / u_resolution - 0.5) * 2.0;
    float attraction = exp(-length(uv - mouse) * length(uv - mouse) * 5.0);
    final += vec3(1.0, 0.5, 0.2) * attraction * 2.0;

    final *= crystal;

    gl_FragColor = vec4(final, 1.0);
}
