// shaders/minerals/moldavite.glsl
// MOLDAVITE (Tektite / Impact Glass)
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

// Aerodynamic teardrop SDF
float sdTeardrop(vec2 p, float scale) {
    p *= scale;
    float r = length(p);
    float theta = atan(p.y, p.x);
    // Teardrop: round front, pointed back
    float shape = r - (1.0 - cos(theta) * 0.3) * smoothstep(3.14, 0.0, theta);
    return shape;
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Rotate to show aerodynamic form
    float a = u_time * 0.1;
    vec2 p = uv * rot(a);

    // Main teardrop body
    float body = sdTeardrop(p, 1.5);
    float inside = smoothstep(0.02, -0.02, body);
    float edge = smoothstep(0.05, 0.0, abs(body));

    // Moldavite green: olive to forest
    vec3 green = vec3(0.2, 0.4, 0.15);
    vec3 dark_green = vec3(0.1, 0.25, 0.08);

    // Surface texture: wrinkled from flight
    float wrinkles = fbm(p * 5.0 + vec2(100.0, 50.0)) * 0.3;
    vec3 color = mix(dark_green, green, 0.5 + wrinkles);

    // Bubble inclusions (lechatelierite)
    float bubbles = 0.0;
    for(int i = 0; i < 8; i++) {
        vec2 b_pos = vec2(
            sin(float(i) * 3.1 + 1.0) * 0.4,
            cos(float(i) * 2.7 + 2.0) * 0.3
        );
        float b = smoothstep(0.08, 0.0, length(p - b_pos));
        bubbles += b;
    }

    // Bubbles = lighter, with internal reflection
    vec3 bubble_color = vec3(0.5, 0.6, 0.4) * bubbles;
    color += bubble_color * inside;

    // Edge highlight (molten glass sheen)
    color += vec3(0.3, 0.4, 0.2) * edge * 2.0;

    // Translucency
    float alpha = 0.85 + edge * 0.15;

    gl_FragColor = vec4(color * inside, alpha);
}


// In amethyst KIFS loop, add:
vec3 crystal_normal = normalize(pc);
float interference = dot(viewDir, crystal_normal);
float flash = pow(abs(interference), 20.0);
vec3 spectral = pal(interference * 2.0, ...);
// Add to violet glow: violet + spectral * flash


// In Tiger's Eye tangent loop:
float fiber_curvature = sin(uv.x * 5.0) * 0.5 + 0.5;
float phase = dot(view, tangent) * 2.0 + fiber_curvature * 3.0;
vec3 fiber_color = spectral_palette(phase);
// Replace tiger_palette with this


// In opal Voronoi loop, replace sphere distance with needle distance:
float needle_d = sdNeedle(f - point, vec3(0.0, 0.0, 1.0), 0.3, 0.02);
if(needle_d < min_dist) {
    domain_normal = normalize(point - f);
    min_dist = needle_d;
}


// Use exposure buffer to shift spectrolite's phase:
float phase_shift = exposure * 3.14; // Permanent phase offset
float schiller = pow(max(0.0, alignment + phase_shift), 64.0);


// In cummingtonite radial loop:
float manhattan_r = abs(local.x) + abs(local.y);
float square_needle = step(0.5, sin(theta * freq)) * step(manhattan_r, 0.5);


precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform float u_temperature; // Colder = more complex

// 6-fold dendritic branch
float ice_branch(vec2 p, float angle, float scale, float depth) {
    if(depth <= 0.0) return 0.0;

    vec2 local = p * scale;
    local *= rot(-angle);

    // Main stem
    float stem = smoothstep(0.05, 0.0, abs(local.y)) * step(0.0, local.x) * step(local.x, 1.0);

    // Side branches at 60 degrees
    float branch1 = ice_branch(local - vec2(0.5, 0.0), 1.047, scale * 0.6, depth - 1.0);
    float branch2 = ice_branch(local - vec2(0.5, 0.0), -1.047, scale * 0.6, depth - 1.0);

    return stem + branch1 * 0.7 + branch2 * 0.7;
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Multiple seed points
    float frost = 0.0;
    for(int i = 0; i < 6; i++) {
        vec2 seed = vec2(
            sin(float(i) * 2.3) * 0.7,
            cos(float(i) * 1.9) * 0.7
        );
        float branch = ice_branch(uv - seed, atan(uv.y - seed.y, uv.x - seed.x), 2.0, 4.0);
        frost += branch;
    }

    // Ice colors: clear to milky white
    vec3 clear_ice = vec3(0.85, 0.9, 0.95);
    vec3 frosty = vec3(0.95, 0.97, 1.0);

    vec3 final = mix(clear_ice, frosty, frost);
    final += vec3(1.0, 1.0, 1.1) * frost * 0.5; // Bright edges

    // Glass background
    vec3 glass = vec3(0.7, 0.8, 0.9) * (1.0 - length(uv) * 0.2);
    final = mix(glass, final, smoothstep(0.0, 0.5, frost));

    gl_FragColor = vec4(final, 1.0);
}


precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

// Voronoi with hexagonal bias (salt polygons)
float salt_polygons(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float d = 1.0;

    for(int y = -1; y <= 1; y++) {
        for(int x = -1; x <= 1; x++) {
            vec2 b = vec2(float(x), float(y));
            // Hexagonal offset
            b.x += mod(i.y + b.y, 2.0) * 0.5;
            vec2 r = b + hash21(i + b) - f;
            d = min(d, dot(r, r));
        }
    }
    return sqrt(d);
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    float scale = 4.0;
    float poly = salt_polygons(uv * scale);

    // Polygon edges = raised salt ridges
    float ridge = smoothstep(0.1, 0.0, poly);
    float flat = smoothstep(0.3, 0.1, poly);

    // Salt colors: white crust, pink from algae, wet dark patches
    vec3 salt_white = vec3(0.95, 0.95, 0.92);
    vec3 salt_pink = vec3(0.9, 0.75, 0.7);
    vec3 wet = vec3(0.4, 0.4, 0.5);

    // Wet patches in polygon centers
    float wetness = hash21(floor(uv * scale));
    vec3 color = mix(salt_white, salt_pink, wetness);
    color = mix(color, wet, smoothstep(0.7, 0.9, wetness) * flat);

    // Raised ridges
    color += vec3(0.1, 0.1, 0.08) * ridge;

    // Specular from salt crystals
    float spec = pow(max(0.0, 1.0 - poly * 3.0), 32.0) * flat;
    color += vec3(1.0) * spec * 0.3;

    gl_FragColor = vec4(color, 1.0);
}


precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

// Stalactite SDF: cone with drip
float sdStalactite(vec2 p, vec2 tip, float length, float width) {
    vec2 local = p - tip;
    local.y = -local.y; // Point down
    float taper = smoothstep(0.0, length, local.y);
    float w = width * (1.0 - taper * 0.7);
    float body = length(vec2(local.x, 0.0)) - w * (1.0 - local.y / length);

    // Drip at tip
    float drip = length(p - (tip + vec2(sin(u_time) * 0.05, length))) - 0.03;

    return min(body, drip);
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Ceiling with multiple stalactites
    float cave = 1e10;
    for(int i = 0; i < 5; i++) {
        vec2 tip = vec2(
            sin(float(i) * 2.5) * 0.6,
            0.8 + cos(float(i) * 1.3) * 0.1
        );
        float stal = sdStalactite(uv, tip, 0.6 + sin(float(i)) * 0.2, 0.08);
        cave = min(cave, stal);
    }

    // Floor stalagmites (upside down)
    for(int i = 0; i < 4; i++) {
        vec2 tip = vec2(
            cos(float(i) * 2.1) * 0.5,
            -0.8 + sin(float(i) * 1.7) * 0.1
        );
        float stal = sdStalactite(vec2(uv.x, -uv.y), tip, 0.5, 0.1);
        cave = min(cave, stal);
    }

    float inside = smoothstep(0.02, -0.02, cave);
    float edge = smoothstep(0.05, 0.0, abs(cave));

    // Calcite colors: cream to orange (from iron)
    vec3 calcite = vec3(0.9, 0.85, 0.75);
    vec3 iron_stain = vec3(0.6, 0.4, 0.2);
    float stain = fbm(uv * 3.0) * 0.5;
    vec3 color = mix(calcite, iron_stain, stain);

    // Wet sheen
    color += vec3(0.2, 0.2, 0.15) * edge * 2.0;

    // Cave darkness
    float depth = 1.0 - abs(uv.y) * 0.5;
    color *= depth;

    gl_FragColor = vec4(color * inside, 1.0);
}


precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

// Bioluminescent "bacteria" colonies on mineral surface
float biolum_colony(vec2 p, vec2 center, float phase) {
    float d = length(p - center);
    // Pulsing glow
    float pulse = sin(u_time * 2.0 + phase) * 0.5 + 0.5;
    return exp(-d * d * 20.0) * pulse;
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Mineral base: rough calcite texture
    float rough = fbm(uv * 4.0);
    vec3 mineral = vec3(0.7, 0.75, 0.8) * (0.8 + rough * 0.4);

    // Bioluminescent colonies
    float glow = 0.0;
    vec3 glow_color = vec3(0.0, 0.0, 0.0);

    for(int i = 0; i < 12; i++) {
        vec2 center = vec2(
            sin(float(i) * 3.7 + 1.0) * 0.7,
            cos(float(i) * 2.3 + 2.0) * 0.6
        );
        float colony = biolum_colony(uv, center, float(i));
        glow += colony;

        // Different colonies = different colors (speciation)
        vec3 colors[3];
        colors[0] = vec3(0.0, 1.0, 0.5); // Cyan-green
        colors[1] = vec3(0.5, 0.0, 1.0); // Violet
        colors[2] = vec3(0.0, 0.5, 1.0); // Blue
        glow_color += colors[i % 3] * colony;
    }

    // Combine: mineral absorbs some glow, transmits rest
    vec3 final = mineral * (1.0 - glow * 0.3) + glow_color * 2.0;

    // Mouse disturbs colonies (scares them = dimmer)
    float mouse_dist = length(uv - (u_mouse / u_resolution - 0.5) * 2.0);
    float scare = smoothstep(0.3, 0.0, mouse_dist);
    final *= 1.0 - scare * 0.5;

    gl_FragColor = vec4(final, 1.0);
}


precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

// Caustic pattern from refracted light
float caustics(vec2 p, float time) {
    float c = 0.0;
    for(int i = 0; i < 3; i++) {
        float fi = float(i);
        vec2 q = p * (2.0 + fi);
        q += time * (0.5 + fi * 0.2);
        c += sin(q.x + sin(q.y + time)) * cos(q.y - sin(q.x));
    }
    return c * 0.5 + 0.5;
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Pool bottom
    vec3 pool = vec3(0.1, 0.3, 0.4);

    // Caustic intensity
    float caustic = caustics(uv * 3.0, u_time * 0.5);
    caustic = pow(caustic, 3.0); // Sharpen

    // Color shift from refraction (prism effect)
    vec3 caustic_color = vec3(
        caustics(uv * 3.0 + vec2(0.02, 0.0), u_time * 0.5),
        caustic,
        caustics(uv * 3.0 - vec2(0.02, 0.0), u_time * 0.5)
    );
    caustic_color = pow(caustic_color, vec3(3.0));

    // Combine
    vec3 final = pool + caustic_color * 2.0;

    // Water surface reflection
    float surface = pow(1.0 - abs(uv.y), 8.0) * 0.3;
    final += vec3(0.5, 0.7, 0.8) * surface;

    gl_FragColor = vec4(final, 1.0);
}


precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // White light source position
    vec2 light_pos = (u_mouse / u_resolution - 0.5) * 2.0;

    // Distance from light
    float d = length(uv - light_pos);

    // Dispersion: different wavelengths refract differently
    // Red bends least, violet bends most
    float dispersion_strength = 0.3 / (d + 0.1);

    vec3 color = vec3(0.0);
    for(int i = 0; i < 7; i++) {
        float wavelength = float(i) / 6.0; // 0=red, 1=violet
        float bend = (wavelength - 0.5) * dispersion_strength;

        vec2 refracted = normalize(uv - light_pos) * bend;
        float intensity = exp(-length(uv - light_pos - refracted) * 10.0);

        // Spectrum colors
        vec3 spectrum = vec3(
            smoothstep(0.5, 0.0, abs(wavelength - 0.0)), // Red
            smoothstep(0.5, 0.0, abs(wavelength - 0.3)), // Green
            smoothstep(0.5, 0.0, abs(wavelength - 0.6))  // Blue
        );
        color += spectrum * intensity;
    }

    // Background
    vec3 bg = vec3(0.05, 0.05, 0.08);
    float beam = exp(-d * d * 2.0) * 0.5;

    gl_FragColor = vec4(bg + color + vec3(1.0) * beam, 1.0);
}


precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform sampler2D u_scene; // Background scene

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;

    // Ordinary ray (no shift)
    vec3 ordinary = texture2D(u_scene, uv).rgb;

    // Extraordinary ray (shifted based on crystal orientation)
    float crystal_angle = u_time * 0.1;
    vec2 shift = vec2(cos(crystal_angle), sin(crystal_angle)) * 0.02;
    vec3 extraordinary = texture2D(u_scene, uv + shift).rgb;

    // Interference between the two (polarization effect)
    float phase = sin(u_time) * 0.5 + 0.5;
    vec3 combined = mix(ordinary, extraordinary, phase);

    // Rainbow fringes at edges (chromatic aberration from birefringence)
    float edge = length(shift) * 50.0;
    vec3 fringe = vec3(
        smoothstep(0.0, 0.3, edge),
        smoothstep(0.1, 0.4, edge),
        smoothstep(0.2, 0.5, edge)
    );

    gl_FragColor = vec4(combined + fringe * 0.2, 1.0);
}


precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

// Bragg peaks for cubic lattice
float bragg_peak(vec2 p, vec3 hkl, float wavelength) {
    // d-spacing for cubic: a / sqrt(h²+k²+l²)
    float d = 1.0 / sqrt(hkl.x*hkl.x + hkl.y*hkl.y + hkl.z*hkl.z);
    float theta = asin(wavelength / (2.0 * d));

    // Peak position on detector
    float peak_pos = tan(theta * 2.0) * 2.0;
    float dist = abs(length(p) - peak_pos);
    return exp(-dist * dist * 100.0);
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    float pattern = 0.0;
    vec3 color = vec3(0.0);

    // Miller indices for common peaks
    vec3 hkls[6];
    hkls[0] = vec3(1,0,0); hkls[1] = vec3(1,1,0);
    hkls[2] = vec3(1,1,1); hkls[3] = vec3(2,0,0);
    hkls[4] = vec3(2,1,0); hkls[5] = vec3(2,1,1);

    float wavelength = 0.15; // Cu K-alpha in nm-ish units

    for(int i = 0; i < 6; i++) {
        float peak = bragg_peak(uv, hkls[i], wavelength);
        pattern += peak;

        // Color by intensity (structure factor)
        float intensity = 1.0;
        if(int(hkls[i].x + hkls[i].y + hkls[i].z) % 2 == 1) intensity = 0.0; // Systematic absence

        color += vec3(0.5 + float(i) * 0.1, 0.8, 1.0) * peak * intensity;
    }

    // Direct beam (center)
    float direct = exp(-length(uv) * length(uv) * 50.0);

    // Film background
    vec3 film = vec3(0.1, 0.15, 0.2);
    vec3 final = film + color * 2.0 + vec3(1.0) * direct * 0.5;

    gl_FragColor = vec4(final, 1.0);
}


float conchoidal_fracture(vec2 p, vec2 center, float scale, float roughness) {
    vec2 local = (p - center) * scale;
    float r = length(local);
    float theta = atan(local.y, local.x);

    // Shell-like curves with roughness
    float shell = r - sin(theta * 3.0 + r * 5.0 + fbm(local * 3.0) * roughness) * 0.1;
    return smoothstep(0.5, 0.0, shell);
}


float radiating_fibers(vec2 p, vec2 center, float num_fibers, float freq, float time) {
    vec2 local = p - center;
    float r = length(local);
    float theta = atan(local.y, local.x);

    float fibers = 0.0;
    for(float i = 0.0; i < num_fibers; i++) {
        float f = (i / num_fibers) * 6.28318;
        float fiber = sin(theta * freq + f + time) * exp(-r * 2.0);
        fibers += max(0.0, fiber);
    }
    return fibers;
}


float banded_layers(vec2 p, float direction, float frequency, float warp_strength) {
    // Domain warp for organic banding
    vec2 q = p;
    q += vec2(
        sin(q.y * 2.0 + p.x) * warp_strength,
        cos(q.x * 1.5 + p.y) * warp_strength
    );

    // Project to band direction
    float proj = q.x * cos(direction) + q.y * sin(direction);
    return sin(proj * frequency);
}


float crystal_faces(vec2 p, float symmetry, float size) {
    float r = length(p);
    float theta = atan(p.y, p.x);

    // Polygonal cross-section
    float polygon = cos(theta * symmetry) * size;
    float faces = smoothstep(polygon * 0.9, polygon, r);

    // Facet boundaries
    float facets = abs(sin(theta * symmetry));
    float edges = smoothstep(0.1, 0.0, facets);

    return faces + edges * 0.3;
}


float botryoidal_cluster(vec2 p, float num_spheres, float radius, float merge) {
    float d = 1e10;
    for(float i = 0.0; i < num_spheres; i++) {
        vec2 center = vec2(
            sin(i * 2.5 + 1.0) * 0.5,
            cos(i * 1.7 + 2.0) * 0.5
        );
        float sphere = length(p - center) - radius * (0.8 + sin(i) * 0.2);
        d = smin(d, sphere, merge);
    }
    return d;
}


// Seed → Nucleation → Growth → Coarsening → Equilibrium
float growth_stage(float time) {
    if(time < 0.2) return 0.0; // Seed
    if(time < 0.4) return smoothstep(0.2, 0.4, time); // Nucleation
    if(time < 0.7) return 1.0; // Growth
    if(time < 0.9) return 1.0 - smoothstep(0.7, 0.9, time) * 0.3; // Coarsening
    return 0.7; // Equilibrium
}

// Use growth_stage to control crystal size, facet sharpness, inclusion density


float weathering(float time, float hardness) {
    // Hardness 0-1: 0=dissolves fast, 1=resists
    float etch = smoothstep(0.0, 0.3 * hardness, time);
    float dissolve = smoothstep(0.3 * hardness, 1.0, time);
    float replacement = smoothstep(0.8, 1.0, time);
    return etch + dissolve * 2.0 + replacement * 3.0;
}

// Apply as surface roughness, edge rounding, color shift


// Paragenetic sequence: quartz → sulfides → carbonates → oxides
vec3 paragenesis(vec2 p, float depth) {
    float stage = fract(depth * 0.1);

    if(stage < 0.25) return quartz_color(p);      // Early: quartz vein
    if(stage < 0.5)  return sulfide_color(p);     // Middle: pyrite, galena
    if(stage < 0.75) return carbonate_color(p);   // Late: calcite, dolomite
    return oxide_color(p);                         // Supergene: goethite
}


// Thin section under crossed polars
vec3 thin_section(vec2 p, float birefringence, float thickness, float orientation) {
    // Interference color from retardation
    float retardation = birefringence * thickness;
    float phase = retardation * 6.28318;

    // Michel-Levy color chart approximation
    vec3 color = vec3(
        sin(phase) * 0.5 + 0.5,
        sin(phase + 2.09) * 0.5 + 0.5,
        sin(phase + 4.19) * 0.5 + 0.5
    );

    // Extinction when oriented
    float extinction = pow(abs(sin(orientation * 2.0)), 4.0);

    return color * extinction;
}
