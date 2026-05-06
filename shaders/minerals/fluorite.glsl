// shaders/minerals/fluorite.glsl
// FLUORITE (The Octahedral Rainbow Trap)
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

// Cubic cleavage: 4 planes at tetrahedral angles
float cleavage(vec3 p) {
    vec3 a = abs(p);
    // The 4 cleavage planes of fluorite
    float p1 = abs(a.x + a.y + a.z - 1.0);
    float p2 = abs(a.x + a.y - a.z - 1.0);
    float p3 = abs(a.x - a.y + a.z - 1.0);
    float p4 = abs(-a.x + a.y + a.z - 1.0);
    return min(min(p1, p2), min(p3, p4));
}

// Zonal color: concentric cubic shells
vec3 fluorite_zone(vec3 p) {
    float zone = floor(length(p) * 3.0);
    // Famous fluorite colors: purple, green, blue, yellow
    vec3 colors[4];
    colors[0] = vec3(0.4, 0.0, 0.6);  // Deep purple
    colors[1] = vec3(0.0, 0.5, 0.2);  // Emerald green
    colors[2] = vec3(0.1, 0.3, 0.8);  // Ocean blue
    colors[3] = vec3(0.8, 0.7, 0.0);  // Golden yellow
    return colors[int(mod(zone, 4.0))];
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    vec3 p = vec3(uv, 0.0);

    // Octahedral rotation
    float a = u_time * 0.1;
    p.xy *= rot(a);
    p.xz *= rot(a * 0.7);

    // Cleavage planes
    float cleave = cleavage(p);
    float cleave_mask = smoothstep(0.05, 0.0, cleave);

    // Zonal color
    vec3 zone_color = fluorite_zone(p);

    // Internal reflection on cleavage
    float internal_bounce = pow(cleave_mask, 4.0) * 2.0;

    // UV fluorescence toggle (mouse = UV torch)
    float uv_dist = length(uv - (u_mouse / u_resolution - 0.5) * 2.0);
    float uv_hit = smoothstep(0.5, 0.0, uv_dist);
    vec3 fluorescence = vec3(0.3, 0.1, 0.8) * uv_hit * 3.0; // Violet glow

    vec3 final = zone_color * (1.0 + internal_bounce) + fluorescence;
    final += vec3(0.5, 0.5, 1.0) * cleave_mask * 0.5; // Glassy sheen

    gl_FragColor = vec4(final, 1.0);
}
