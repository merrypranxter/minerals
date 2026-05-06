// shaders/minerals/opal.glsl
// OPAL
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

vec3 opal_fire(float t) {
    return 0.5 + 0.5 * cos(6.28318 * (vec3(1.0, 0.0, 0.5) * t + vec3(0.0, 0.33, 0.67)));
}

vec3 hash33(vec3 p) {
    p = fract(p * vec3(443.897, 441.423, 437.195));
    p += dot(p, p.yxz + 19.19);
    return fract((p.xxy + p.yzz) * p.zyx);
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    vec3 viewDir = normalize(vec3(uv, 1.0));

    vec3 p = vec3(uv * 4.0, u_time * 0.05);
    vec3 id = floor(p);
    vec3 f = fract(p);

    float min_dist = 1.0;
    vec3 domain_normal;

    for(int x = -1; x <= 1; x++) {
        for(int y = -1; y <= 1; y++) {
            vec3 neighbor = vec3(float(x), float(y), 0.0);
            vec3 lattice_seed = hash33(id + neighbor);
            vec3 point = neighbor + 0.5 + 0.5 * sin(u_time * 0.2 + 6.2831 * lattice_seed);
            float d = length(f - point);
            if(d < min_dist) {
                min_dist = d;
                domain_normal = normalize(lattice_seed - 0.5);
            }
        }
    }

    float interference = dot(viewDir, domain_normal);
    float fire_mask = pow(abs(interference), 20.0);
    vec3 fire_color = opal_fire(interference * 2.0 + u_time * 0.1);
    vec3 base_stone = vec3(0.1, 0.12, 0.15) + (1.0 - min_dist) * 0.05;

    vec3 final = mix(base_stone, fire_color, fire_mask * 2.0);
    final += vec3(0.1, 0.15, 0.2) * (1.0 - fire_mask);

    gl_FragColor = vec4(final, 1.0);
}
