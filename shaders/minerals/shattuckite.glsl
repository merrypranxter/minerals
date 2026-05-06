// shaders/minerals/shattuckite.glsl
// SHATTUCKITE (The Fibrous Blue Vein)
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    float r = length(uv);
    float theta = atan(uv.y, uv.x);

    // Multiple radiation centers
    vec2 centers[3];
    centers[0] = vec2(0.0, 0.0);
    centers[1] = vec2(0.4, -0.3);
    centers[2] = vec2(-0.3, 0.4);

    vec3 final = vec3(0.02, 0.05, 0.1); // Dark matrix

    for(int i = 0; i < 3; i++) {
        vec2 local = uv - centers[i];
        float lr = length(local);
        float ltheta = atan(local.y, local.x);

        // Radiating fibers
        float fibers = 0.0;
        for(int f = 1; f < 6; f++) {
            float freq = float(f) * 15.0;
            fibers += sin(ltheta * freq + u_time * 0.2) * (1.0 / float(f));
        }

        // Fiber mask
        float mask = smoothstep(0.5, 0.0, lr) * smoothstep(-0.5, 0.5, fibers);

        // Shattuckite blue: intense, slightly violet
        vec3 blue = vec3(0.0, 0.2, 0.5) * mask;
        vec3 silk = vec3(0.3, 0.4, 0.7) * pow(mask, 4.0) * 2.0; // Silky highlight

        final += blue + silk;
    }

    // Matrix texture
    float matrix_noise = fbm(uv * 4.0);
    final += vec3(0.1, 0.08, 0.05) * matrix_noise * 0.2;

    gl_FragColor = vec4(final, 1.0);
}
