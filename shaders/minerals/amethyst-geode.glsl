// shaders/minerals/amethyst-geode.glsl
// AMETHYST GEODE
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

mat2 rot(float a) {
    float s = sin(a), c = cos(a);
    return mat2(c, -s, s, c);
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    vec3 ro = vec3(0, 0, -2);
    vec3 rd = normalize(vec3(uv, 1.5));

    float t = 0.0;
    for(int i = 0; i < 60; i++) {
        vec3 p = ro + rd * t;
        float d = -(length(p) - 1.2); // Hollow sphere

        vec3 pc = p;
        for(int j = 0; j < 5; j++) {
            pc.xy *= rot(0.78 + u_time * 0.05);
            pc = abs(pc) - 0.35;
        }
        float crystals = length(pc.xy) - 0.02;
        d = max(d, -crystals); // Subtractive

        if(d < 0.001 || t > 5.0) break;
        t += d * 0.5;
    }

    vec3 stone = vec3(0.05, 0.04, 0.06);
    vec3 violet = vec3(0.4, 0.1, 0.8) * (1.5 / (t * t));
    float flash = pow(1.0 - t / 2.0, 16.0);
    vec3 final = mix(stone, violet + flash, step(t, 3.0));

    gl_FragColor = vec4(final, 1.0);
}
