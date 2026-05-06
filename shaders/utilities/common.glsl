// shaders/utilities/common.glsl
// Shared GLSL utility functions for the minerals shader library
// Source: Weird Guy Mineral Shader Corpus (Pass 1 + Lesson 40)


vec3 pal(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}


float hash21(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 hash33(vec3 p) {
    p = fract(p * vec3(443.897, 441.423, 437.195));
    p += dot(p, p.yxz + 19.19);
    return fract((p.xxy + p.yzz) * p.zyx);
}


mat2 rot(float a) {
    float s = sin(a), c = cos(a);
    return mat2(c, -s, s, c);
}


float smin(float a, float b, float k) {
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}


float sdSphere(vec3 p, float r) { return length(p) - r; }

float sdBox(vec3 p, vec3 b) {
    vec3 q = abs(p) - b;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

float sdHexPrism(vec3 p, vec2 h) {
    const vec3 k = vec3(-0.8660254, 0.5, 0.57735);
    p = abs(p);
    p.xy -= 2.0 * min(dot(k.xy, p.xy), 0.0) * k.xy;
    vec2 d = vec2(
        length(p.xy - vec2(clamp(p.x, -k.z*h.x, k.z*h.x), h.x)) * sign(p.y - h.x),
        p.z - h.y
    );
    return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
}


// Additional infrastructure from Lesson 40

// THE GOLDEN PALETTE FUNCTION (used everywhere)
vec3 pal(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
  return a + b * cos(6.28318 * (c * t + d));
}

// HASH FUNCTIONS
float hash11(float n) { return fract(sin(n) * 43758.5453123); }
vec2 hash22(vec2 p) { p = fract(p * vec2(443.897, 441.423)); p += dot(p, p.yx + 19.19); return fract((p.xxy + p.yzz) * p.zyx); }
vec3 hash33(vec3 p) { p = fract(p * vec3(443.897, 441.423, 437.195)); p += dot(p, p.yxz + 19.19); return fract((p.xxy + p.yzz) * p.zyx); }

// SMOOTH MINIMUM (Polynomial, k=blend radius)
float smin(float a, float b, float k) {
  float h = clamp(0.5 + 0.5*(b-a)/k, 0.0, 1.0);
  return mix(b, a, h) - k*h*(1.0-h);
}

// ROTATION MATRIX
mat2 rot2(float a) { float s=sin(a), c=cos(a); return mat2(c,-s,s,c); }
mat3 rot3X(float a) { float s=sin(a), c=cos(a); return mat3(1,0,0, 0,c,-s, 0,s,c); }

// RIDGE NOISE (for dendrites, veins)
float ridge(float n) { return 1.0 - abs(n); }

// FRACTAL BROWNIAN MOTION (standard + ridge variant)
float fbm(vec2 p) {
  float v=0.0, amp=0.5;
  for(int i=0; i<6; i++) { v += fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453) * amp; p *= 2.1; amp *= 0.5; }
  return v;
}


float sdHexPrism(vec3 p, vec2 h) { /* from LESSON 35 */ }
float sdNeedle(vec3 p, vec3 a, vec3 b, float r) { vec3 pa=p-a, ba=b-a; float t=clamp(dot(pa,ba)/dot(ba,ba),0.,1.); return length(pa-ba*t)-r; }
float sdRhombohedron(vec3 p, float r) { return (abs(p.x)+abs(p.y)+abs(p.z)-r)/sqrt(3.0); }  // L1 sphere
float sdOctahedron(vec3 p, float s) { p=abs(p); return (p.x+p.y+p.z-s)*0.57735027; }


vec3 braggColor(float d, float cosTheta, float time_offset) {
  // d = lattice spacing (0.1 to 0.3), cosTheta = angle term
  float lambda = d * cosTheta;  // Effective reflected wavelength
  return pal(lambda + time_offset * 0.05,
    vec3(0.5), vec3(0.5), vec3(1.0, 1.0, 1.0), vec3(0.0, 0.33, 0.67));
}

// Ridge noise (for dendrites and veins)
float ridge(float n) { return 1.0 - abs(n); }

// Fractal Brownian Motion
float fbm(vec2 p) {
    float v = 0.0, amp = 0.5;
    for(int i = 0; i < 6; i++) {
        v += fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453) * amp;
        p *= 2.1;
        amp *= 0.5;
    }
    return v;
}

// Bragg-diffraction palette
vec3 braggColor(float d, float cosTheta, float time_offset) {
    float lambda = d * cosTheta;
    return pal(lambda + time_offset * 0.05,
        vec3(0.5), vec3(0.5), vec3(1.0, 1.0, 1.0), vec3(0.0, 0.33, 0.67));
}

// sdNeedle (capsule SDF)
float sdNeedle(vec3 p, vec3 a, vec3 b, float r) {
    vec3 pa = p - a, ba = b - a;
    float t = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * t) - r;
}

// sdOctahedron
float sdOctahedron(vec3 p, float s) {
    p = abs(p);
    return (p.x + p.y + p.z - s) * 0.57735027;
}

// sdRhombohedron (L1 sphere)
float sdRhombohedron(vec3 p, float r) {
    return (abs(p.x) + abs(p.y) + abs(p.z) - r) / sqrt(3.0);
}
