// shaders/minerals/vivianite.glsl
// VIVIANITE
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform sampler2D u_buffer;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    vec2 p = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    float prev = texture2D(u_buffer, uv).r;
    float light = smoothstep(0.5, 0.0, length(uv - u_mouse / u_resolution));
    float exposure = clamp(prev + light * 0.01, 0.0, 1.0);

    // Bladed geometry
    float d = 0.0;
    vec2 st = p;
    for(int i = 0; i < 5; i++) {
        st *= mat2(1.1, 0.5, -0.2, 1.2);
        st = abs(st) - 0.3;
        d += exp(-length(st) * 5.0);
    }

    vec3 ghost = vec3(0.8, 0.9, 0.8) * d;
    vec3 bruised = vec3(0.0, 0.05, 0.15) * d;
    vec3 final = mix(ghost, bruised, exposure);

    float glint = pow(max(0.0, 1.0 - length(st)), 32.0) * (1.0 - exposure);
    final += vec3(0.5, 1.0, 0.8) * glint;

    gl_FragColor = vec4(final, exposure);
}
