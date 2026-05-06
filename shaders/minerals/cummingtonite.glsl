// shaders/minerals/cummingtonite.glsl
// CUMMINGTONITE
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

float fiber_noise(float theta) {
    return fract(sin(theta * 123.456 + floor(theta * 10.0)) * 43758.5453);
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    float r = length(uv);
    float theta = atan(uv.y, uv.x);

    float needles = 0.0;
    for(int i = 1; i < 5; i++) {
        float f = float(i) * 20.0;
        needles += sin(theta * f + u_time * 0.5 + fiber_noise(theta)) * (1.0 / float(i));
    }

    float mouse_theta = atan(u_mouse.y - u_resolution.y/2.0, u_mouse.x - u_resolution.x/2.0);
    float highlight = pow(max(0.0, cos(theta - mouse_theta)), 16.0);

    vec3 base_brown = vec3(0.15, 0.1, 0.05);
    vec3 gold_fiber = vec3(0.8, 0.5, 0.2);
    float mask = smoothstep(0.1, 0.5, needles) * exp(-r * 2.0);

    vec3 final = base_brown + (gold_fiber * mask * (1.0 + highlight * 3.0));
    final = mix(final, vec3(0.02), smoothstep(0.15, 0.0, r));

    gl_FragColor = vec4(final, 1.0);
}
