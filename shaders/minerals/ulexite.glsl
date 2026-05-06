// shaders/minerals/ulexite.glsl
// ULEXITE (TV Rock / Fiber Optic Mineral)
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform sampler2D u_back_image; // Image behind the mineral

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Ulexite projects image from bottom to top surface
    // Simulate by sampling "back" image with slight distortion
    vec2 back_uv = uv * 0.8 + 0.1; // Slightly cropped

    // Fiber optic distortion: slight magnification and blur
    float fiber_noise = fbm(uv * 20.0) * 0.02;
    back_uv += fiber_noise;

    // Sample the "transmitted" image
    vec3 transmitted = texture2D(u_back_image, back_uv).rgb;

    // Ulexite has silky white fibers
    float fibers = pow(abs(sin(uv.x * 100.0)), 0.1) * 0.3;
    vec3 fiber_color = vec3(0.9, 0.9, 0.85) * fibers;

    // Combine: transmitted image + fiber texture
    vec3 final = transmitted * 0.8 + fiber_color;

    // Slight translucency
    float alpha = 0.9;

    gl_FragColor = vec4(final, alpha);
}
