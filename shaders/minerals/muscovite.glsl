// shaders/minerals/muscovite.glsl
// MUSCOVITE
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

vec3 interference(float d, float cosTheta) {
    vec3 spectral_shift = vec3(0.1, 0.2, 0.3);
    return 0.5 + 0.5 * cos(6.28318 * (spectral_shift * d * cosTheta + u_time * 0.1));
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    vec3 view = normalize(vec3(uv, 1.0));

    vec3 final_color = vec3(0.0);
    float total_alpha = 0.0;

    for(int i = 0; i < 8; i++) {
        float depth = float(i) * 0.05;
        vec2 layer_uv = uv + view.xy * depth;
        float flake_noise = fract(sin(dot(floor(layer_uv * 10.0), vec2(12.9898, 78.233))) * 43758.5453);
        float mask = step(0.4 + float(i) * 0.05, flake_noise);
        float glint = pow(max(0.0, dot(view, vec3(0.0, 0.0, 1.0))), 64.0) * mask;
        vec3 irid = interference(depth, view.z) * mask * 0.5;

        final_color += (vec3(0.1, 0.12, 0.15) + irid + glint) * (1.0 - total_alpha);
        total_alpha += mask * 0.2;
        if(total_alpha >= 1.0) break;
    }

    final_color += vec3(0.05, 0.04, 0.02) * (1.0 - total_alpha);
    gl_FragColor = vec4(final_color, 1.0);
}
