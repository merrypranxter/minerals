// shaders/minerals/tourmaline.glsl
// TOURMALINE (The Piezoelectric Rainbow)
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Tourmaline crystal: long prismatic with triangular cross-section
    float r = length(uv);
    float theta = atan(uv.y, uv.x);

    // Triangular cross-section (3-fold symmetry)
    float tri = abs(sin(theta * 3.0)) * r;
    float crystal = smoothstep(0.7, 0.68, tri);

    // C-axis color (lengthwise): usually dark
    vec3 c_axis = vec3(0.1, 0.05, 0.08);

    // A-axis color (crosswise): the famous watermelon tourmaline
    float axis_angle = theta + u_time * 0.2;
    vec3 a_axis = vec3(
        0.5 + 0.5 * sin(axis_angle),
        0.2 + 0.3 * cos(axis_angle * 2.0),
        0.1
    );

    // Mix based on viewing angle relative to crystal axis
    float view_angle = dot(normalize(uv), vec2(1.0, 0.0));
    vec3 color = mix(c_axis, a_axis, abs(view_angle));

    // Watermelon effect: green outside, pink inside
    float center = smoothstep(0.3, 0.0, r);
    vec3 green_rind = vec3(0.1, 0.4, 0.1);
    vec3 pink_core = vec3(0.6, 0.2, 0.3);
    color = mix(color, mix(green_rind, pink_core, center), crystal);

    // Piezoelectric flash on click
    float pressure = smoothstep(0.2, 0.0, length(uv - (u_mouse / u_resolution - 0.5) * 2.0));
    color += vec3(0.5, 0.5, 1.0) * pressure * 2.0;

    gl_FragColor = vec4(color * crystal, 1.0);
}
