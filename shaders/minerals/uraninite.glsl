// shaders/minerals/uraninite.glsl
// URANINITE
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

float sdBotryoidal(vec3 p) {
    float d = length(p) - 0.5;
    for(int i = 0; i < 4; i++) {
        vec3 offset = sin(vec3(i*1.5, i*2.2, i*3.1) + u_time * 0.1) * 0.3;
        d = min(d, length(p + offset) - 0.2);
    }
    return d;
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    float d = sdBotryoidal(vec3(uv, 0.0));

    float intensity = 0.01 / (d * d + 0.001);
    intensity *= exp(-0.1 * u_time);

    float noise = fract(sin(dot(uv + u_time, vec2(12.9898, 78.233))) * 43758.5453);
    float particle_hit = step(0.99, noise * intensity * 10.0);

    vec3 stone = vec3(0.02, 0.02, 0.03) * (1.0 - smoothstep(0.0, 0.1, d));
    vec3 ionized_blue = vec3(0.0, 0.4, 1.0) * intensity * 2.0;
    vec3 final = stone + ionized_blue + vec3(1.0) * particle_hit;

    gl_FragColor = vec4(final, 1.0);
}
