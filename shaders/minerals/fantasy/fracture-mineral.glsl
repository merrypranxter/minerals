// shaders/minerals/fantasy/fracture-mineral.glsl
// FRACTURE MINERAL (Self-Healing)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Fantasy)

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

// Crack pattern
float crack_pattern(vec2 p, float seed, float width) {
    float crack = 0.0;
    vec2 pos = p;

    // Branching crack
    for(int i = 0; i < 10; i++) {
        float fi = float(i);
        float angle = sin(fi * 3.7 + seed) * 1.5;
        vec2 dir = vec2(cos(angle), sin(angle));

        float along = dot(pos, dir);
        float across = length(pos - dir * along);

        crack += smoothstep(width, 0.0, across) * step(0.0, along) * step(along, 0.3);

        // Branch
        if(hash21(pos * 10.0) > 0.7) {
            pos = pos - dir * 0.3;
        }
    }

    return crack;
}

// Healing over time
float healing(float time, float heal_rate) {
    return 1.0 - exp(-time * heal_rate);
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Damage cycle: crack → heal → crack
    float cycle = fract(u_time * 0.2);
    float damage_time = smoothstep(0.0, 0.3, cycle);
    float heal_time = smoothstep(0.3, 1.0, cycle);

    // Crack
    float crack = crack_pattern(uv, 1.0, 0.02 * (1.0 - damage_time));

    // Healing fills crack
    float heal = healing(heal_time, 3.0);
    float healed_crack = crack * (1.0 - heal);

    // Scar tissue (slightly different color)
    vec3 mineral = vec3(0.3, 0.4, 0.5);
    vec3 crack_color = vec3(0.1, 0.1, 0.15);
    vec3 scar = vec3(0.35, 0.42, 0.52); // Slightly different

    vec3 color = mix(mineral, crack_color, healed_crack);
    color = mix(color, scar, smoothstep(0.5, 1.0, heal) * crack * 0.5);

    // Surface texture
    float texture = fbm(uv * 5.0) * 0.1;
    color += texture;

    gl_FragColor = vec4(color, 1.0);
}
