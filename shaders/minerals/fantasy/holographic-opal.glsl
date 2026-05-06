// shaders/minerals/fantasy/holographic-opal.glsl
// HOLOGRAPHIC OPAL (3D Image Storage)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Fantasy)

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform sampler2D u_recorded_image;

// Holographic reconstruction from interference pattern
vec3 hologram_reconstruct(vec2 uv, float depth, float wavelength) {
    // Reference beam interference
    float reference = sin(uv.x * 50.0 + depth * 10.0);

    // Object beam (encoded image)
    vec3 object = texture2D(u_recorded_image, uv * 0.5 + 0.25).rgb;

    // Reconstruct by interfering with reference
    float reconstruction = reference * (object.r + object.g + object.b) / 3.0;

    // Depth-dependent color (chromatic aberration of reconstruction)
    vec3 depth_color;
    depth_color.r = smoothstep(0.0, 0.3, abs(depth - 0.1));
    depth_color.g = smoothstep(0.0, 0.3, abs(depth - 0.2));
    depth_color.b = smoothstep(0.0, 0.3, abs(depth - 0.3));

    return object * reconstruction * depth_color * 3.0;
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Opal base
    float r = length(uv);
    float opal = smoothstep(0.7, 0.65, r);

    // Multiple depth planes
    vec3 hologram = vec3(0.0);
    for(int i = 0; i < 8; i++) {
        float fi = float(i);
        float depth = fi / 8.0;
        vec3 plane = hologram_reconstruct(uv, depth, 0.5 + fi * 0.1);
        hologram += plane * (1.0 - depth * 0.5);
    }

    // Opal fire from structure
    float fire = pow(abs(sin(uv.x * 20.0 + uv.y * 15.0)), 4.0);
    vec3 opal_fire = vec3(0.5, 0.3, 0.1) * fire;

    // Combine
    vec3 final = hologram * opal + opal_fire * opal;

    // Glassy surface
    float fresnel = pow(r, 4.0);
    final += vec3(0.9, 0.95, 1.0) * fresnel * 0.3;

    gl_FragColor = vec4(final, 1.0);
}
