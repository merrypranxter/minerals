// shaders/minerals/syntax-quartz.glsl
// SYNTAX QUARTZ
// Source: Weird Guy Mineral Shader Corpus

// Procedural character generator
float char(vec2 p, float seed) {
    p = floor(p * vec2(3.0, 5.0));
    if(p.x < 0.0 || p.x > 2.0 || p.y < 0.0 || p.y > 4.0) return 0.0;
    return step(0.5, fract(sin(dot(p + seed, vec2(12.98, 78.23))) * 43758.54));
}

// Syntax highlighting
float type = fract(sin(dot(grid, vec2(1.0, 12.0))) * 43.0);
vec3 color = vec3(0.1, 0.8, 1.0); // Cyan default
if(type > 0.8) color = vec3(1.0, 0.7, 0.1); // Gold keyword
if(type < 0.2) color = vec3(1.0, 0.2, 0.5); // Magenta operator
