// shaders/minerals/fantasy/snowflake.glsl
// SNOWFLAKE (Hexagonal Crystal)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Atmospheric)

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

// Snowflake arm
float snowflake_arm(vec2 p, float length, float width, float branches) {
    vec2 local = p;
    float r = length(local);
    float theta = atan(local.y, local.x);

    // Main stem
    float stem = smoothstep(width, 0.0, abs(local.y)) * step(0.0, local.x) * step(local.x, length);

    // Side branches at 60°
    float side = 0.0;
    for(float i = 1.0; i < branches; i++) {
        float fi = i / branches;
        vec2 branch_pos = vec2(fi * length, 0.0);
        float branch = smoothstep(width * 0.5, 0.0, length(local - branch_pos) - fi * width * 2.0);
        side += branch * step(0.0, local.x);
    }

    return stem + side;
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    float r = length(uv);
    float theta = atan(uv.y, uv.x);

    // 6 arms
    float snowflake = 0.0;
    for(int i = 0; i < 6; i++) {
        float angle = float(i) * 1.0472; // 60°
        vec2 arm_uv = uv * rot(-angle);

        // Each arm slightly different (natural variation)
        float length = 0.5 + sin(float(i) * 2.3) * 0.1;
        float branches = 3.0 + floor(sin(float(i) * 1.7) * 2.0);

        snowflake += snowflake_arm(arm_uv, length, 0.02, branches);
    }

    // Ice crystal: transparent with slight color
    vec3 ice = vec3(0.9, 0.95, 1.0) * snowflake;

    // Central hexagon
    float center = smoothstep(0.08, 0.0, r);
    ice += vec3(1.0, 1.0, 1.1) * center;

    // Background: winter sky
    vec3 sky = vec3(0.7, 0.8, 0.9) * (1.0 - r * 0.3);

    gl_FragColor = vec4(sky + ice, 1.0);
}
