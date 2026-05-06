# LESSONS FOR REPOSCRIPTER
_Distilled from: "The Shader Alchemist" Minerals PDF — a full progression of GLSL mineral rendering techniques from W-Coeff 6.5 to W-Coeff 99.9, covering ~35 mineral specimens plus meta/computational lithogenesis._
_Assumptions made: Target is Shader Forge / reposcripter GLSL pipeline with u_time, u_resolution, u_mouse uniforms. WebGL2 context assumed. Feedback buffer (u_buffer / sampler2D) available where noted. JS hybrid logic piped as uniforms/textures._

---

## LESSON 01 — AGATE / MALACHITE: RECURSIVE DOMAIN WARPING
**Category:** Structural Color / Sedimentary Banding
**Priority:** CORE
**Source:** "Recursive Frequency Folding — Instead of standard FBM, we use the atan2 of a noise field to drive the phase of another noise field."

The foundation move for all banded minerals. Use iterative loops where `p += cos(p.yx * freq + u_time) - sin(p.yx * freq2)`. The banding emerges from `sin(length(p) * scale + u_time)` after 3-6 distortion passes. High-contrast `smoothstep(-0.2, 0.2, strata)` sharpens the bands. Depth falloff via `col / (d*d + 0.5)` sells the "stone" weight.

**Original code key:** Loop 4x: `p += cos(p.yx * 3.0 + time) * 0.5; p -= sin(p.yx * 2.0 - time*0.5) * 0.5;` → band on `sin(length(p) * 15.0 + time)`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] ORBIT TRAP BANDING:** Instead of distance-to-center, use orbit traps during the loop. Track `min(length(p - trapPoint), orbitVal)` per iteration. Feed into palette. Creates "wound around an invisible obstacle" aesthetics that standard FBM can't touch.
```glsl
float trap = 1e10;
for(int i=0; i<5; i++) {
  p = abs(p) / dot(p,p) - 0.6;
  trap = min(trap, length(p - vec2(0.5, 0.0)));
}
vec3 col = pal(trap, ...);
```

**[ADD-B] POLAR AGATE (Circular Bands):** Convert to polar coordinates BEFORE warping. `float r = length(uv); float theta = atan(uv.y, uv.x);` then warp `r` with noise. Bands become concentric rings with organic wobble — malachite bulls-eye pattern.

**[ADD-C] FLOW FIELD DEPOSITION (Tectonic Advection):** Use a feedback buffer. Each frame, advect the previous frame's color along a curl-noise field before depositing new strata. `vec4 prev = texture2D(u_buffer, uv + flow(uv) * 0.001);` The bands accumulate like real geological time. Needs Buffer A.

**Applies when:** Any sedimentary banding mineral — Agate, Malachite, Banded Iron Formation, Jasper, Fordite.

---

## LESSON 02 — LABRADORITE: THIN-FILM INTERFERENCE (BRAGG SCATTERING GHOST)
**Category:** Structural Color / Anisotropic Interference
**Priority:** CORE
**Source:** "Lattice Phasing Error — dot product between view vector and high-frequency grid to trigger Spectral Leaks."

Labradorite is 90% black/grey, 10% neon flash. Critical rule: the flash mask must use `smoothstep(0.9, 0.98, phase)` — HIGH threshold so color only leaks through narrow bands. Base stone is `vec3(0.05, 0.06, 0.08)` with micro-noise. Flash color uses `pal()` with the stone_noise seeding the offset. `4.0` multiplier on the spectral color after masking creates the "holy shit, blue!" moment.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] SCHLICK FRESNEL + WARD ANISOTROPIC:** Upgrade from fake dot-product interference to a proper Schlick Fresnel: `float F = F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);` where F0 ≈ 0.04 for feldspar. Combine with Ward anisotropic specular for the elongated highlight along the twinning planes: `exp(-(dotHX*dotHX/ax + dotHY*dotHY/ay) / (dotNH*dotNH))`.

**[ADD-B] BLUE NOISE TEMPORAL DITHERING:** The flash edge is too sharp for a real stone. Apply a blue-noise dither: sample a 64x64 blue noise texture, add it to the `phase` value before the smoothstep threshold. Eliminates aliasing and adds the micro-grain of the feldspar matrix.

**[ADD-C] MULTI-ORDER BRAGG (N=1,2,3):** Real Labradorescence fires multiple spectral orders simultaneously. Loop over `n in {1, 2, 3}`: `float lambda_n = 2.0 * d * cosTheta / float(n);` Map each order to a different spectral band (blue, orange, violet). Combine with different weights. First order dominates; second order creates subtle orange halos at oblique angles — this is what separates "Spectrolite" from standard Canadian labradorite.

**Applies when:** Labradorite, Spectrolite, any thin-film interference mineral (Covellite, Muscovite, Iridescent Goethite).

---

## LESSON 03 — BOTRYOIDAL / HEMATITE: SMOOTH-MIN SPHERE PACKING
**Category:** Organic Growth / Merging Geometry
**Priority:** CORE
**Source:** "Exponential Smooth-Minimums on a field of jittered spheres — growth competing for space."

`smin(a, b, k)` is the foundational move. Use Polynomial smin (IQ's version): `float h = clamp(0.5 + 0.5*(b-a)/k, 0.0, 1.0); return mix(b, a, h) - k*h*(1.0-h);` for predictable blending radius. Jitter sphere centers with `sin(vec3(i*1.5, i*2.2, i*3.1) + u_time*0.1) * 0.3`. Fresnel rim glow with hue pushed toward UV spectrum = "radioactive decay" vibe.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] THREE FLAVORS OF SMIN:** Each creates a different "melt" character.
- **Polynomial (IQ):** Predictable blend radius. Best for organic orbs.
- **Exponential:** `return -log2(exp2(-k*a) + exp2(-k*b)) / k;` — infinitely differentiable, rounder, more biological.
- **Power:** `(a^n + b^n)^(1/n)` for n=8-16 — creates "blobby" joins with sharper transitions. Hematite = power smin. Chalcedony = exponential.

**[ADD-B] GROWTH ANIMATION VIA SMIN-K DRIVE:** Animate the `k` parameter with `u_time`. Low k = touching spheres with sharp seams (fresh growth). High k = fully merged blob (mature botryoidal). `float k = 0.05 + 0.15 * sin(u_time * 0.3);`

**[ADD-C] CURVATURE-DEPENDENT TARNISH:** Compute fake curvature from the SDF gradient: `vec2 e = vec2(0.001, 0.0); float curv = 2.0*d - sdBotryoid(p+e.xyy) - sdBotryoid(p-e.xyy);` Map curvature to iridescence intensity. Concave joints (high curvature) collect the thickest oxide layer → strongest color shift.

**Applies when:** Botryoidal Hematite, Malachite grape clusters, Uraninite, Smithsonite, Goethite.

---

## LESSON 04 — PRECIOUS OPAL: VORONOI DOMAINS + BRAGG DIFFRACTION
**Category:** Photonic Crystal / Domain-Based Color
**Priority:** CORE
**Source:** "3D Voronoi Field where each cell is a domain with a local lattice direction — the color only flashes when dot(view, latticeNormal) > threshold."

Each Voronoi cell = one silica sphere domain with random `lattice_seed` orientation. `fire_mask = pow(abs(interference), 20.0)` — the exponent controls "blink" sharpness. Base is milky `vec3(0.1, 0.12, 0.15)`. Fire palette: `0.5 + 0.5 * cos(6.28318 * (vec3(1.0, 0.0, 0.5) * t + vec3(0.0, 0.33, 0.67)))`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] SPHERE SIZE DOMAIN VARIATION:** Real opal fire color depends on silica sphere diameter `d`. Vary `d` per Voronoi cell: `float sphere_d = 0.1 + 0.15 * hash33(cellID).x;` Then `lambda = 2.0 * sphere_d * cosTheta;` map to palette. Smaller spheres = blue fire. Larger = red/orange fire. Mix domains = full-spectrum play-of-color.

**[ADD-B] PARALLAX OPAL (Water/Jelly Opal):** Sample the noise field multiple times with view-direction offset to push fire "inside" the stone. For each depth layer `z += step`: `vec3 p_layer = p + viewDir * z * 0.5;` accumulate fire contribution scaled by `exp(-z)`. Creates that "floating inches deep inside" look that standard surface shaders cannot replicate.

**[ADD-C] PERLIN PATCHES WITH BRAGG BLINK (Full Spectral):** Run three separate Bragg computations at wavelengths λ=450nm (blue), λ=550nm (green), λ=650nm (red). Each fires at a slightly different angle. Result: as the camera moves, the fire transitions through spectral colors instead of jumping directly between hues. This is what makes Boulder Opal look different from Mexican Fire Opal.

**Applies when:** Precious Opal, Boulder Opal, Fire Opal, opalized fossils.

---

## LESSON 05 — TIGER'S EYE: ANISOTROPIC FIBER SHADING (CHATOYANCY)
**Category:** Anisotropic Specularity / Fiber Optics
**Priority:** CORE
**Source:** "We treat the fragment as a surface of infinite parallel cylinders. The highlight exists on the plane perpendicular to the fibers — the Schiff-Kay Brute."

Core formula: `float dotLT = dot(L, T); float dotVT = dot(V, T); float chatoyancy = pow(sqrt(1.0-dotLT*dotLT) * sqrt(1.0-dotVT*dotVT) - dotLT*dotVT, 32.0);` This is the Ward-Duer anisotropic model stripped to its essence. The tangent `T` = fiber direction, warped with low-frequency sine for "wavy fibers." Mouse drives light direction for interactive roll.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] PROPER KAJIYA-KAY HAIR SHADING:** More physically correct for very thin fibers (Stibnite, acicular crystals): `float sinTH = sqrt(max(0.0, 1.0 - dot(T,H)*dot(T,H))); float spec = pow(sinTH, N);` Separate into diffuse `sqrt(1.0 - dot(T,L)*dot(T,L))` and specular. Gives "metallic silk" vs "matte silk" via N control.

**[ADD-B] DUAL-LOBE CHATOYANCY:** Real chatoyant stones have a primary highlight AND a secondary contra-highlight 90° away (due to the cylindrical geometry diffracting in both lateral directions). Add a secondary lobe with `T_perp = normalize(cross(T, vec3(0,0,1)))` and blend at 15% intensity. The second lobe makes the stone look "rounder."

**[ADD-C] FIBER DEPTH MAP (Depth-Peeled Chatoyancy):** Render multiple fiber layers at different depths. Layer 0 (surface): sharp highlight. Layer 1 (1mm deep): slightly blurred. Layer 2 (2mm deep): very soft. Composite front-to-back with increasing softness. The "silk" quality emerges from the depth stack — Tigers Eye has this because crocidolite fibers are preserved in 3D, not just on the surface.

**Applies when:** Tiger's Eye, Hawk's Eye, Seraphinite, Chrysotile, any chatoyant gem.

---

## LESSON 06 — BISMUTH: MANHATTAN DISTANCE HOPPER CRYSTALS
**Category:** Non-Euclidean Geometry / Recursive Voids
**Priority:** ELEVATED
**Source:** "L1 Norm (Manhattan Distance) — l1_norm(p) = abs(p.x) + abs(p.y) + abs(p.z). Combined with abs(p) folding to create the staircase recession."

Six-iteration loop: `p = abs(p) - 0.5; p *= 1.5; scale *= 1.5; float step_d = l1_norm(p) / scale; d = max(d, step_d);` Iridescence via `0.5 + 0.5 * cos(time + d * 50.0 + vec3(0,2,4))` — the `d * 50` creates the rainbow step-bands. Edge detection via `smoothstep(0.01, 0.02, fract(d * 10.0))`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] L-INFINITY NORM (CHEBYSHEV DISTANCE):** `float linf_norm(vec3 p) { return max(abs(p.x), max(abs(p.y), abs(p.z))); }` Produces SQUARE-edged stairs vs the rounded L1 stairs. Mix between L1 and L∞ with `mix(l1_norm(p), linf_norm(p), 0.5)` for an intermediate "stepped cube" aesthetic. Pure L∞ looks like a city skyline made of bismuth.

**[ADD-B] THIN-FILM OXIDE THICKNESS MAP:** Real bismuth iridescence is caused by an oxide layer of varying thickness — thinnest at crystal faces, thickest at edges. Approximate with `float thickness = fract(d * frequency) * edge_proximity;` where `edge_proximity = smoothstep(0.0, 0.1, fract(d * 5.0));`. Drive the palette with thickness: thin = gold, medium = magenta, thick = cyan.

**[ADD-C] ANIMATED CRYSTAL GROWTH:** Use `u_time` to drive the `0.5` subtraction offset in the IFS loop: `p = abs(p) - (0.5 + 0.1 * sin(u_time * 0.3));` The crystal "breathes" — expanding and contracting its hopper structure. At extreme values it produces "anti-bismuth" (inverted stairs). Use carefully — goes psychedelic fast.

**Applies when:** Bismuth, other hopper crystals (Galena, Halite), any recursive staircase geometry.

---

## LESSON 07 — AMETHYST GEODE: INVERSION CAVITY KIFS
**Category:** Negative Space Rendering / Volumetric Raymarch
**Priority:** ELEVATED
**Source:** "We render a Void infected by a recursive spike-field — KIFS: p_crystal.xy *= rot(0.78 + u_time*0.05); p_crystal = abs(p_crystal) - 0.35; hexagonal quartz approximation."

The key move is SUBTRACTION: `d = max(d, -crystals)`. The outer sphere SDF is inverted (`d = -(length(p) - 1.2)`) to create the hollow. Inner KIFS spikes are subtracted from this void, creating the crystal lining. Color glow: `vec3(0.4, 0.1, 0.8) * (1.5 / (t*t))` — depth-dependent glow. The `1/t²` creates bright near-surfaces and dark backgrounds.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] VOLUMETRIC SUBSURFACE SCATTERING (SSS):** Track ray travel distance *inside* the void. `float inside_dist = max(0.0, prev_t - entry_t);` Apply exponential Beer-Lambert absorption: `vec3 absorption = exp(-inside_dist * vec3(0.5, 1.0, 0.3));` Blue-selective absorption makes the cavity interior glow violet-magenta. This is the difference between painted amethyst and real crystal SSS.

**[ADD-B] PIEZOELECTRIC EDGE GLOW:** Real quartz crystal tips glow when under mechanical stress (piezoelectric effect). Simulate with a proximity effect: if a ray exits near a crystal tip (high gradient divergence), add a bright white-to-violet burst. `float tip_proximity = exp(-length(p_crystal) * 10.0); finalColor += vec3(0.8, 0.5, 1.0) * tip_proximity * flash;`

**[ADD-C] DRUZY MICRO-TEXTURE:** Add a high-frequency noise layer on top of the KIFS surface: `float druzy = step(0.95, fract(sin(dot(p_crystal * 100.0, vec3(12.98, 78.23, 43.76))) * 43758.0));` Each "hit" = a micro-crystal face catching light. Transforms "smooth crystal" into "druzy quartz" with a million tiny sparkling faces.

**Applies when:** Amethyst, Quartz geodes, Citrine, Selenite cave interiors.

---

## LESSON 08 — PYRITE: BRUTALIST SDF TWINNING
**Category:** Metallic Geometry / Crystal Twinning
**Priority:** ELEVATED
**Source:** "Space-Folding Operator — 45-degree rotation + abs(p) folding. High-frequency sawtooth on surface normal for striations."

`pyriteSDF` loop: `p.xy *= mat2(cos(a), -sin(a), sin(a), cos(a)); p = abs(p) - 0.2; d = min(d, sdBox(p, vec3(0.4)));` where `a = 0.785398` (π/4). Striations via `float striations = sin(p.x * 100.0) * 0.5 + 0.5;` Golden color `vec3(0.8, 0.6, 0.2) * striations`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] GGX METALLIC BRDF:** Replace Blinn-Phong with proper metallic microfacet: `float D = (roughness*roughness) / (PI * pow(NdotH*NdotH*(roughness*roughness - 1.0) + 1.0, 2.0));` with Smith's G term. Pyrite IOR is complex: n≈1.6, k≈2.2 in the yellow band. Use Schlick with F0 = `vec3(0.95, 0.82, 0.38)` (metallic gold-bronze). Real pyrite lustre = metallic GGX, not Phong.

**[ADD-B] PENTAGON DODECAHEDRON TWINNING:** Actual pyrite forms Pentagon Dodecahedra and Pyritohedra — not plain cubes. SDF approximation: `float sdPyritohedron(vec3 p) { float c = dot(abs(p), normalize(vec3(1.618, 1.0, 0.0))); float d = dot(abs(p), normalize(vec3(0.0, 1.618, 1.0))); return max(c, max(d, max(abs(p.x), max(abs(p.y), abs(p.z))))) - r; }` (Golden ratio faces.)

**[ADD-C] STRIATION NORMAL PERTURBATION:** Instead of coloring striations, perturb the surface normal with them: `vec3 n_perturb = n + vec3(sin(p.x * 200.0) * 0.1, 0.0, 0.0);` This lets the striations affect lighting rather than just color — creates those fine, parallel "whisker" highlights that real pyrite shows at oblique angles.

**Applies when:** Pyrite, Galena, Arsenopyrite, any striated metallic crystal.

---

## LESSON 09 — URANINITE: STOCHASTIC DECAY ENGINE
**Category:** Radioactive Decay / Inverse-Square Physics
**Priority:** ELEVATED
**Source:** "Geiger-Müller Tube logic — Intensity via inverse-square law + half-life constant. Stochastic Grain Filter — RGB channels decouple and jitter as virtual sensor is bombarded."

`float intensity = 0.01 / (d*d + 0.001); intensity *= exp(-0.1 * u_time);` — the decay half-life. `float particle_hit = step(0.99, noise * intensity * 50.0)` — sparse, bright spikes = particle impacts. Color: NOT green. Pitchblende = sub-metallic black. Cherenkov glow = electric BLUE. Ionized air = sparse white spikes.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] CHERENKOV RADIATION CONE:** Real Cherenkov radiation forms at a specific cone angle around the particle track direction. Simulate: define a "particle velocity" vector `v = normalize(sin(vec3(u_time * 1.1, u_time * 0.7, u_time * 1.3)))`. The glow is strongest where `abs(dot(normalize(p), v) - cos(cherenkovAngle)) < epsilon`. Creates a cone of blue light around the decay center.

**[ADD-B] ALPHA PARTICLE TRACKS (Wilson Cloud Chamber Look):** Use a 3D Voronoi to generate "particle tracks" from the botryoidal center: random rays emanating outward, each leaving a thin column of ionized air. `float track = sdCapsule(p, origin, origin + dir * length, 0.02);` Each track = slight Cherenkov blue haze. Multiple tracks = radioactive cloud chamber aesthetic.

**[ADD-C] TEMPORAL CHROMATIC BREAKDOWN:** As `intensity` increases near the source, progressively decouple RGB channels with different spatial offsets: `vec2 r_offset = uv + vec2(intensity * 0.02, 0.0); vec2 b_offset = uv - vec2(intensity * 0.02, 0.0);` Sample color at offset UVs per channel. Near the source, the image "tears" into chromatic aberration — visual analog of sensor saturation from radiation.

**Applies when:** Uraninite, Thorianite, radioactive mineral contexts.

---

## LESSON 10 — CUMMINGTONITE: POLAR ENTROPY / RADIATING FIBER MANIFOLD
**Category:** Polar Coordinate Shading / Angular Anisotropy
**Priority:** ELEVATED
**Source:** "Operate entirely in Polar Coordinates (r, theta). Non-Harmonic Sine Waves on theta axis create Phase-Shifted Probability Peaks."

`float needles = 0.0; for(int i=1; i<=5; i++) { float f = float(i) * 20.0; needles += sin(theta * f + u_time * 0.5 + fiber_noise(theta)) * (1.0/float(i)); }` — stacked harmonics in angular domain. Mouse-driven highlight: `float mouse_theta = atan(mouse_pos); float highlight = pow(max(0.0, cos(theta - mouse_theta)), 16.0);`

**ADDITIONAL TECHNIQUES:**

**[ADD-A] GABOR NOISE FOR ORIENTED FIBERS:** Gabor noise is analytically oriented — it produces fibers at a specific angle with controllable frequency. For cummingtonite: multiple Gabor kernels all pointing radially outward from center. `float gabor(vec2 p, vec2 freq) { return exp(-dot(p,p) * 2.0) * cos(dot(p, freq)); }` Sum over a grid of kernel positions. Creates fibers that are statistically correct rather than procedurally approximate.

**[ADD-B] LISSAJOUS STARBURST:** For a more alien/geometric variety: replace the angular sine stack with Lissajous curves in polar space. `float lissajous = sin(theta * A + u_time * speed_a) * sin(theta * B + u_time * speed_b);` Where A and B are coprime integers (e.g., 3 and 5). Produces non-repeating, quasi-crystalline fiber patterns that look like evolved cummingtonite from another planet.

**[ADD-C] ANISOTROPIC ABSORPTION (Color-Dependent):** Amphibole fibers exhibit pleochroism — different colors absorbed depending on the polarization angle relative to the fiber. Simulate: `vec3 absorption = vec3(0.2, 0.1, 0.05) * (1.0 - cos(theta - fiber_theta));` The red channel absorbs more when light is perpendicular to fibers, producing the characteristic brown-gold-greenish transitions of real cummingtonite.

**Applies when:** Cummingtonite, Actinolite, Tremolite, Nephrite, Sillimanite, any fibrous amphibole.

---

## LESSON 11 — MUSCOVITE / MICA: ITERATIVE LAYER PEELING
**Category:** Dielectric Stacking / Sub-Atomic Cleavage
**Priority:** CORE
**Source:** "Non-Euclidean Book — march through N layers. Each layer has its own refractive index and Phase-Shifted Specular Glint. Deformation Hysteresis triggers Newton's Rings."

Interference per layer: `vec3 spectral_shift = vec3(0.1, 0.2, 0.3); return 0.5 + 0.5 * cos(6.28318 * (spectral_shift * d * cosTheta + u_time * 0.1));` Front-to-back compositing: `final_color += contribution * (1.0 - total_alpha); total_alpha += mask * 0.2;` The `step(0.4 + float(i)*0.05, flake_noise)` cleavage threshold creates irregular flake shapes.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] NEWTON'S RINGS (EXACT):** When mica sheets are bent, the air gap between them varies and creates Newton's Rings. Compute gap thickness from sheet curvature: `float gap = curvature * r * r;` (parabolic approximation). Then `float ring = sin(2.0 * PI * 2.0 * gap / lambda);` for each wavelength. Real Newton's Rings are concentric colored circles that shift outward as gap increases. Extremely recognizable and beautiful.

**[ADD-B] BIREFRINGENCE (DOUBLE REFRACTION):** Mica is birefringent — the extraordinary ray travels at a different speed than the ordinary ray. Simulate with two slightly offset UV samples: `vec2 uv_o = uv; vec2 uv_e = uv + viewDir.xy * 0.01 * birefringence;` Blend colors from both. The offset creates a subtle "double image" halo around high-contrast edges — the definitive visual signature of birefringent minerals.

**[ADD-C] PHYSICAL TEARING SIMULATION (Spring-Mass Peeler):** In a JS hybrid, simulate a spring-mass grid representing the mica sheet surface. When mouse proximity exceeds a tension threshold, "tear" the sheet: mark torn cells in a TypedArray, upload as texture. In shader, torn cells show the layer beneath with a fresh-cleavage specular spike at the tear boundary. The interaction of tearing and revealing new layers is viscerally satisfying.

**Applies when:** Muscovite, Phlogopite, Biotite, Lepidolite, any phyllosilicate.

---

## LESSON 12 — CHALCANTHITE: TRICLINIC SKEW MATRIX
**Category:** Non-Orthogonal Crystallography / Lattice Vandalism
**Priority:** ELEVATED
**Source:** "Apply a Shear Matrix to the raymarcher — we lean space. Distance field calculated in a space where 'up' is 78 degrees and 'forward' is 102 degrees."

`mat3 triclinic_skew() { return mat3(1.0, 0.2, 0.1, 0.3, 1.0, -0.2, 0.1, 0.1, 1.0); }` Apply before `sdBox()`. Recursive accretion: `p = abs(p) - 0.4; p.xy *= mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.5));` Deep vitriol: `vec3(0.0, 0.2, 0.8)` → electric cyan: `vec3(0.0, 1.0, 1.0)` driven by `exp(-t*0.5)`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] PHYSICALLY-BASED TRICLINIC PARAMETERS:** Chalcanthite real parameters: a=6.12Å, b=10.72Å, c=5.97Å, α=82.3°, β=107.4°, γ=102.7°. Convert to a proper metric tensor: `mat3 G = mat3(a*a, a*b*cos(gamma), a*c*cos(beta), ...)` Use this as the spatial metric for the SDF. The result is crystallographically accurate — the crystal faces are at the actual angles they appear in nature.

**[ADD-B] DEHYDRATION ANIMATION:** Chalcanthite loses water molecules when heated, transitioning through pentahydrate → trihydrate → monohydrate → anhydrous. Each state has different color (deep blue → pale blue → white). Animate `u_time` driving a `hydration = 1.0 - smoothstep(0.3, 0.7, u_time * 0.01)` uniform. The skew matrix parameters also change (anhydrous chalcocyanite has different lattice). The crystal visibly "shrinks and pales" as it dehydrates.

**[ADD-C] SUBSURFACE TOXIC GLOW (SSS):** Real chalcanthite has a translucent quality — the toxic blue feels like it comes from INSIDE. Implement simplified SSS: sample color at `p + viewDir * 0.05 * thickness` for multiple thickness steps, weight by `exp(-step * extinction)`. The electric blue bleeds through the faces giving a "wet neon" quality that standard rasterization completely misses.

**Applies when:** Chalcanthite, any hydrated copper/iron sulfate, Melanterite.

---

## LESSON 13 — FORDITE: STOCHASTIC MATERIAL ID STRATIFICATION
**Category:** Industrial Deposition / Polymer Hysteresis
**Priority:** ELEVATED
**Source:** "Step-Quantized Noise Field — each layer gets Material DNA: Roughness from hash(L).x, Glitter Density from hash(L).y, Metallic from hash(L).z."

`float layer_idx = floor(n * num_layers);` — quantization creates hard band boundaries. `vec3 dna = material_hash(layer_idx)` — per-layer physical properties. Glitter: `step(0.99, sparkle) * step(0.7, glitter_prob)` — stochastic sparkle only in glitter layers. Sanded-edge darkening: `1.0 - smoothstep(0.45, 0.5, abs(layer_fract - 0.5)) * 0.3`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] MARKOV CHAIN COLOR SEQUENCING:** Real Fordite has color eras — 1960s colors cluster together (candy apple red, turquoise, seafoam), 1970s cluster together (avocado, harvest gold, burnt orange), 1980s cluster together (burgundy, charcoal, silver). Model this with a Markov chain in JS: `color = sampleNextColor(prevColor, era_weights)` where transition probabilities favor staying in the same era. Feeds as a 1D color texture. Produces historically authentic layering.

**[ADD-B] LACQUER SWELL / SOLVENT BLEED:** When paint layers are stacked on a hot surface and then polished, the top layers sometimes "bleed" pigment into adjacent layers. Simulate with domain warping at layer boundaries: `vec2 p_warped = p + boundary_proximity * fbm(p * 50.0) * 0.02;` — only warp near `layer_fract` close to 0 or 1. Creates the characteristic "bleed" look at color transitions.

**[ADD-C] REALISTIC METALLIC FLAKE (GGX MICRO-FACETS):** The glitter particles in metallic paint are actual aluminum flake micro-mirrors with random orientations. Rather than `step(0.99, sparkle)`, implement each flake as a tiny GGX lobe with a random normal: `vec3 flake_n = normalize(hash33(flake_id) * 2.0 - 1.0); float flake_spec = GGX(flake_n, viewDir, lightDir, 0.01);` Low roughness = mirror-sharp glitter. The randomness of `hash33` means each flake catches light at a different angle.

**Applies when:** Fordite, layered paint stratigraphy, any industrial sedimentary material.

---

## LESSON 14 — VIVIANITE: TEMPORAL OXIDATION BUFFERS
**Category:** Reactive / Photochromic Minerals
**Priority:** ELEVATED
**Source:** "Photonic Memory — Exposure Constant E per pixel. Feedback buffer tracks how long a fragment has been exposed. Mineral starts as ghost glass, bleeds to dark indigo where light has touched it."

`float current_exposure = clamp(prev_exposure + light_hit * 0.01, 0.0, 1.0)` — cumulative, irreversible. Ghost state: `vec3(0.8, 0.9, 0.8) * d`. Bruised state: `vec3(0.0, 0.05, 0.15) * d`. Mix: `mix(ghost_state, bruised_state, current_exposure)`. Refractive glint DECREASES with exposure — the crystal loses its sparkle as it oxidizes.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] DIFFUSION-REACTION OXIDATION FRONT:** Real oxidation doesn't just accumulate — it forms a moving front that spreads from the surface inward. Model with a cellular automaton in the feedback buffer: `float spread = max(max(texture2D(u_buffer, uv + e.xy).r, texture2D(u_buffer, uv - e.xy).r), max(texture2D(u_buffer, uv + e.yx).r, texture2D(u_buffer, uv - e.yx).r));` The oxidation spreads outward from mouse-exposed areas like ink in water.

**[ADD-B] SPECTRAL OXIDATION STAGES:** Fe²⁺ (clear) → Fe²·⁵⁺ (pale green) → Fe³⁺ (deep indigo) → fully oxidized (black). Four discrete color stages via `floor(exposure * 4.0)`. Transition bands between stages use `fract(exposure * 4.0)` for smooth blending. Adds geological authenticity — the color doesn't just go from clear to blue, it cycles through a visible green intermediate.

**[ADD-C] OXIDATION MEMORY PERSISTENCE (Non-Euclidean Time):** Override the standard accumulation: instead of linear `+= 0.01`, use a sigmoid approach: `current_exposure = prev_exposure + light_hit * (1.0 - prev_exposure) * 0.05;` — oxidation accelerates when fresh but slows as the surface approaches full oxidation (rate-limiting product layer). This matches the kinetics of real Fe²⁺ → Fe³⁺ oxidation in air.

**Applies when:** Vivianite, Siderite, any Fe²⁺/Fe³⁺ redox mineral. Also: Alexandrite (color change), Realgar (photodegradation).

---

## LESSON 15 — STIBNITE: ACICULAR LANCE / HIGH-ASPECT ANISOTROPIC HOSTILITY
**Category:** Ballistic Geometry / Longitudinal Striation
**Priority:** ELEVATED
**Source:** "Non-Uniform Raymarcher — stretch Z-axis by 10. High-frequency Sawtooth Wave to surface normal along longitudinal axis. Kajiya-Kay specular: Specular = sin^n(acos(dot(T,H)))."

`sdNeedle(q, 3.0, 0.05)` — h=3.0, r=0.05 gives aspect ratio 60:1. Starburst: loop 8 needles each rotated by `float(j) * 0.785` (π/4 increments). Striations: `sin(p_final.x * 200.0)`. Leaden palette: `mix(vec3(0.1,0.11,0.13), vec3(0.8,0.85,0.9), spec + grooves*0.2)`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] TRUE KAJIYA-KAY FULL IMPLEMENTATION:**
```glsl
// Full Kajiya-Kay with diffuse + specular
float dotLT = dot(L, T);
float dotVT = dot(V, T);
float sinLT = sqrt(max(0.0, 1.0 - dotLT*dotLT));
float sinVT = sqrt(max(0.0, 1.0 - dotVT*dotVT));
float diffuse = sinLT;  // Diffuse component
float spec_arg = sinLT * sinVT - dotLT * dotVT;  // cos(alpha_r - alpha_i)
float specular = pow(max(0.0, spec_arg), 64.0);
vec3 color = base * diffuse + highlight * specular;
```
The full version includes the diffuse `sin(θ_L)` term which gives stibnite its dark flanks and bright front face correctly.

**[ADD-B] LEAD-GREY PBR METAL (COMPLEX IOR):** Stibnite (Sb₂S₃) has complex IOR: n≈4.0, k≈1.5. Use full Fresnel with complex IOR: `vec3 F = complexFresnel(n, k, cosTheta)` where `complexFresnel` computes Rs and Rp separately. The high n gives brilliant near-mirror reflectivity; the k gives the characteristic grey/steel color. Do NOT use simplified Schlick for this mineral — the error is visible.

**[ADD-C] CRYSTALLOGRAPHIC TERMINATION:** Real stibnite crystals have specific termination forms at their tips — not sharp points but slightly squared "pinacoidal" faces. Implement by capping the needle SDF: `float capPlane = dot(normalize(q - tip_pos), tip_normal) - 0.0;` and taking `max(needle, capPlane)`. The tiny flat tip catches specular differently from the shaft — the flash "breaks" at the terminus in a distinctive way.

**Applies when:** Stibnite, Bismuthinite, Boulangerite, any acicular sulfosalt.

---

## LESSON 16 — CROCOITE: HOLLOW PRISMATIC SKELETON (MONOCLINIC SIPHON)
**Category:** Skeletal Crystallography / Hollow SDF Subtraction
**Priority:** ELEVATED
**Source:** "SDF Subtraction — take a large prism, subtract a smaller, slightly longer prism from its core. Monoclinic Shear Matrix: p.x += p.y * 0.4 (the beta angle tilt)."

`sdHollowPrism`: outer prism minus `length(p.xz) - (h.x * 0.8)` inner core. Neon orange overdrive: `vec3(1.5, 0.5, 0.0)` — values > 1.0 for bloom effect. Sub-surface glow via `exp(-t * 0.3)` based on raymarching depth. Chromate flash on skeletal edges via `pow(1.0 - d * 20.0, 16.0)`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] DISPERSION RENDERING (CHROMATIC PRISMATIC):** Lead chromate has high dispersion — the refractive index varies significantly across the spectrum (dn/dλ ≈ high). Simulate by rendering three separate ray-paths for R, G, B: each ray bends slightly differently on entry and exit. `float ior_r = 2.31; float ior_g = 2.36; float ior_b = 2.42;` The resulting color fringing inside the hollow core looks like a tiny prism separating sunlight — appropriate given Crocoite's lead chromate chemistry.

**[ADD-B] L-SYSTEM CRYSTAL GROWTH:** Monoclinic crystals grow via rules analogous to L-systems. In JS: define production rules `F → F[+F][-F]FF` applied to a crystal growth axiom. Pass resulting branch endpoints as a uniform array. In GLSL: render each branch segment as a `sdHollowPrism` with decreasing radius per generation. Cluster grows fractally, each sub-generation at 90° to its parent (monoclinic law).

**[ADD-C] OVERDRIVE SATURATION + OKLCH COLOR SPACE:** Crocoite's color exceeds sRGB gamut. Work in OKLab/OKLCH: `vec3 oklch_color = vec3(0.7, 0.25, 30.0);` (L=lightness, C=chroma, H=hue in degrees). Chroma of 0.25 is beyond sRGB clipping. `toLinearRGB(oklch_to_linear(oklch_color))` gives the correct out-of-gamut signal for HDR monitors. On SDR, it just clamps to the most saturated possible orange-red — still more vivid than standard RGB approaches.

**Applies when:** Crocoite, Wulfenite, Vanadinite, any hypersaturated prismatic mineral.

---

## LESSON 17 — REALGAR: PHOTONIC DECAY HYSTERESIS
**Category:** Temporal Morphogenesis / Photodegradation
**Priority:** ELEVATED
**Source:** "Molecular Guillotine — State-Variable Field with Integrity value per pixel. As Integrity drops, Domain Warping shreds UV space. Sharp prisms replaced by Granular Noise Field (pararealgar)."

Monoclinic skew: `p.xy *= mat2(1.1, 0.4, -0.1, 1.0)`. Decay: `current_decay = clamp(prev_decay + light_exposure * 0.005 + 0.0001, 0.0, 1.0)` — passive ambient decay `+ 0.0001` means it ALWAYS degrades even without mouse. Geometry morph: `mix(d, d + (powder_noise - 0.5) * 0.5, current_decay)`. Color: `mix(realgar_red, pararealgar_yellow, current_decay)`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] VORONOI FRAGMENTATION FRONT:** Instead of noise-based dissolution, use Voronoi cracking. As `decay` increases, Voronoi cell boundaries become visible: `float crack = 1.0 - smoothstep(0.02, 0.05, voronoiEdge * (1.0 - current_decay));` The crystal literally fractures along crystallographic cleavage planes before turning to powder. Adds a visible "cracking stage" between intact crystal and dust.

**[ADD-B] PARTICLE EMISSION (POWDER PHASE):** When `current_decay > 0.5`, emit particle sprites in JS: `if (decayMap[pixel] > 0.5) spawnParticle(pixel, { velocity: up + random() * spread, color: pararealgar_yellow })` Each particle = tiny yellow powder grain drifting downward. GLSL renders the particle field as a separate pass, composited over the decaying crystal. The powder visually accumulates below the crystal.

**[ADD-C] UV SPECTRUM PHOTON FLUX:** Real realgar photodegrades fastest under UV light (short wavelength). Add a UV-wavelength sensitivity: `float uv_intensity = pow(max(0.0, 1.0 - wavelength_normalized), 3.0);` where `wavelength_normalized` comes from a u_light_spectrum uniform. Point a "UV flashlight" (blue-shifted mouse area) to accelerate decay; "red light" barely affects it. Scientifically accurate — red light photography is used by museums to photograph realgar without degrading it.

**Applies when:** Realgar, Orpiment (similar chemistry), any photosensitive arsenic/sulfur mineral.

---

## LESSON 18 — PETRIFIED WOOD: LITHIFIED CELLULAR AUTOMATA
**Category:** Dual-Lattice Replacement / Paleobotany
**Priority:** ELEVATED
**Source:** "Dual-Lattice System: Voronoi for tracheid cells (biological), domain-warped FBM for silicate intrusion. Strata-quantization via floor(r*15 + noise*2)."

Ring quantization: `float rings = floor(r * 15.0 + cell_noise(uv * 0.1) * 2.0)` gives ~15 growth rings, each offset by cellular noise. Silica sparkle: `pores = step(0.95, cell_noise(uv * 50.0 + rings))` — Voronoi cell flash at high frequency (50x UV scale). Vitrification sheen: `final *= pow(1.0 - r * 0.5, 8.0)` — radial falloff giving the glassy dome appearance.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] PALEOBOTANICAL SPECIES DIFFERENTIATION:** Different tree species have anatomically distinct wood structure. Conifer (Araucaria) = circular tracheids in radial files. Cycad = large scattered tracheids with thick walls. Dicot = vessels + rays. Model via Voronoi scale and anisotropy: `float anisotropy = species_param;` — stretches Voronoi cells radially (conifer) vs randomly (dicot). Change species with a uniform and watch the pattern transform.

**[ADD-B] MINERAL SPECIES FILL:** Petrified wood isn't always silica. It can be Chalcedony (banded), Jasper (red iron), Opalized (play-of-color), or even Pyritized (metallic gold). Add a `fill_type` uniform that switches the "geological attack" texture between: FBM bands (chalcedony), Voronoi fire (opal), striated GGX (pyrite), or plain quartz. The "biological ghost" layer stays constant; only the fill changes.

**[ADD-C] ANNUAL RING CLIMATE DATA:** Each growth ring records that year's climate. Map ring thickness to a climate data array: `float ring_thickness = climate_data[int(rings)];` — thin rings = drought year (narrow, dark). Thick rings = good rainfall (wide, pale). Upload a real dendrochronology dataset as a uniform float array. The resulting petrified wood encodes actual historical climate data in its visual structure.

**Applies when:** Petrified Wood, Silicified fossils, any biologically-replaced mineral structure.

---

## LESSON 19 — WIDMANSTÄTTEN PATTERNS: OCTAHEDRAL HYPER-PLANAR SLICING
**Category:** Extra-Terrestrial / 4D Geometry
**Priority:** ELEVATED
**Source:** "Four normal vectors of an octahedron: (±1, ±1, ±1). For each point p, calculate distance to nearest set of parallel planes defined by these normals. fwidth() for razor-sharp etched edges."

Plane sets: `float s1 = abs(fract(dot(p, n1) * 4.0) - 0.5);` for n1=normalize(1,1,1), n2=normalize(-1,1,1), n3=normalize(1,-1,1), n4=normalize(1,1,-1). `pattern = min(min(s1,s2), min(s3,s4))`. `edge = smoothstep(0.02, 0.0, pattern - 0.01)` — `fwidth(pattern)` makes edges crisp at any resolution.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] TRUE KAMACITE / TAENITE BANDS:** Real Widmanstätten patterns alternate between kamacite (BCC iron, ≈6% Ni) and taenite (FCC iron, ≈30% Ni) lamellae. The bands have different metallic colors: kamacite = slightly warm grey (iron-dominant), taenite = slightly cool grey (nickel-lustre). `vec3 kamacite = vec3(0.35, 0.34, 0.32); vec3 taenite = vec3(0.42, 0.43, 0.45);` The subtle color difference, multiplied by anisotropic specular, gives the authentic two-tone "etch" appearance.

**[ADD-B] 4D CRYSTAL SLICING:** The true Widmanstätten geometry is a 3D slice through a 4D hypercubic crystal that cooled in the vacuum of space. Extend to 4D: `vec4 p4 = vec4(p, u_time * 0.01);` — the time axis is the 4th dimension of the crystal. `float h4 = abs(fract(dot(p4, normalize(vec4(1,1,1,1))) * 4.0) - 0.5);` The slowly-changing 4th dimension makes the Widmanstätten pattern appear to shift and breathe as new "slices" of the 4D crystal are revealed.

**[ADD-C] SCHREIBERSITE INCLUSIONS:** Meteoritic iron contains Schreibersite (Fe,Ni)₃P inclusions — small, dark, needle-like phosphide crystals. Scatter them stochastically: `float schreibersite = step(0.98, fract(sin(dot(p, n1+n2)) * 10.0));` where the needle direction aligns with n1+n2 (an octahedral face normal). Each inclusion `darken = schreibersite * 0.5` — darkens local metal. Adds micro-texture that immediately reads as "meteorite" rather than "brushed steel."

**Applies when:** Iron meteorites (Ataxite, Hexahedrite, Octahedrite), Troilite nodules.

---

## LESSON 20 — COVELLITE: SUBTRACTIVE INTERFERENCE MAPPING
**Category:** Quantum Electrodynamics Approximation / Dielectric Loss
**Priority:** ELEVATED
**Source:** "Antimatter Palette — start with White Hole, use Fresnel Angle to subtract specific wavelengths. 'Brass' color at edges = where blue absorption fails."

`covellite_palette(t)`: `base = vec3(0.02, 0.05, 0.2) + vec3(0.1, 0.8, 1.0) * pow(sin(t * 6.28 + vec3(0, 1.2, 2.5)), vec3(4.0))` — high-exponent sine creates tight color bands. Brass edge leak: `float edge_leak = pow(1.0 - abs(d), 8.0); vec3 brass = vec3(0.8, 0.6, 0.2) * edge_leak`. Sub-metallic lustre spec: `pow(max(0.0, 1.0 - length(p * 0.1)), 64.0)`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] COMPLEX FRESNEL (TRUE CuS OPTICS):** Covellite's IOR is highly anisotropic and complex: ordinary ray: n=1.45, k=0.21; extraordinary ray: n=?, k=? (strongly absorbing). Implement full vector Fresnel equations with complex n: `vec2 ior_o = vec2(1.45, 0.21); vec2 ior_e = vec2(4.0, 2.5);` For Rs: `Fs = abs((ni - nt) / (ni + nt))^2` with complex arithmetic. The extraordinary ray is near-opaque — combine ordinary (purple transmission) with extraordinary (black absorption) based on polarization angle relative to c-axis.

**[ADD-B] TARNISH GRADIENT OVER TIME:** Covellite in a collection slowly tarnishes from neon indigo → brassy bronze → matte brown-black. Drive with `float age = mod(u_time * 0.01, 1.0)`: young (0-0.3) = electric purple-blue peak intensity; maturing (0.3-0.7) = brass begins encroaching from edges; old (0.7-1.0) = deep tarnished bronze dominates, indigo only persists in protected crevices (inverse of edge_leak logic).

**[ADD-C] CLEAVAGE PLANE HEXAGONAL TILING:** Covellite's perfect basal cleavage creates hexagonal platelets. Render cleavage structure via hexagonal Voronoi: `vec2 hex_uv = hexToGrid(uv); vec2 cell = floor(hex_uv); float hex_d = hexDist(fract(hex_uv) - 0.5);` Each hexagonal cell is a separate cleavage face with slightly randomized orientation — so each face catches interference light at a different angle, creating a mosaic of shifting iridescent tiles.

**Applies when:** Covellite, Molybdenite, Graphite, any strongly anisotropic metallic sulfide.

---

## LESSON 21 — MANGANESE DENDRITES: RIDGE NOISE / CAPILLARY FRACTAL STAIN
**Category:** Diffusion-Limited Growth / Pseudo-Fossil
**Priority:** ELEVATED
**Source:** "Ridge Noise — return 1.0 - abs(n); — forces output into Ridges rather than Blobs. abs() of noise at each octave creates branch patterns."

`fbm_dendrite`: sum `ridge(sin(dot(p, vec2(1.0, 1.7)))) * amp` over 6 octaves with domain warp `p += cos(p.yx * 2.0 + u_time * 0.1)`. Crack source: `smoothstep(0.1, 0.0, abs(uv.y + sin(uv.x*2.0)*0.2))`. Temporal growth: `smoothstep(growth_limit, growth_limit + 0.1, d)` with animated `growth_limit`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] ACTUAL DLA SIMULATION (GPU COMPUTE):** Run DLA in a WebGPU compute shader: initialize a grid of particles diffusing from random positions. Any particle that touches the "crystal seed" sticks. Output crystal positions as a texture. The resulting pattern is not approximated ridge noise — it IS diffusion-limited aggregation, statistically indistinguishable from real dendrites. Cache the result since DLA convergence = expensive.

**[ADD-B] LAPLACIAN GROWTH (L-SYSTEM HYBRID):** Solve the Laplace equation ∇²φ = 0 on a grid with the growing crystal as a boundary condition. Growth rate at surface ∝ |∇φ| (electric field analogy). In practice: iterative Jacobi relaxation of a 2D grid texture, then grow toward high-gradient boundary cells. Produces the "shielding" effect where inner branches starve outer branches — exactly the dendritic geometry that DLA approximates.

**[ADD-C] BIRNESSITE PSEUDOMORPH:** Manganese dendrites sometimes replace calcite along cleavage planes, leaving a "pseudomorph" where the calcite shape is still visible but filled with MnO₂. Render a background calcite rhombohedron SDF, then fill its interior with the dendritic pattern: `float interior = step(sdRhombohedron(p), 0.0); float dendrite_fill = fbm_dendrite(p) * interior;` The dendrites are constrained within the calcite geometry — looks like a fractal was grown inside a diamond.

**Applies when:** Manganese Dendrites, Pyrolusite, any DLA-growth mineral.

---

## LESSON 22 — SERAPHINITE: CURL-NOISE CHATOYANCY (FEATHERED TANGENT)
**Category:** Vector Field Specularity / Curl-Noise Flow
**Priority:** ELEVATED
**Source:** "Gradient of 2D noise rotated 90° gives Flow Field. Silver Flash = where light and view are perpendicular to this flow. Because the flow is curly, highlight breaks into feathery plumes."

`get_feather_tangent(p)`: compute gradient `(noise(p+eps) - noise(p-eps)) / (2*eps)` in both axes, return rotated 90° = curl. Stack 3 octaves of curl with halving amplitude. Chatoyancy: `pow(1.0 - abs(dot(light_dir.xy, tangent)), 16.0)`. Base: deep green `vec3(0.02, 0.1, 0.05)`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] 3D CURL NOISE FOR VOLUMETRIC FEATHERS:** Real seraphinite feathers have 3D structure — they curve in depth as well as in the 2D plane. True 3D curl: `curlField = vec3(dFz/dy - dFy/dz, dFx/dz - dFz/dx, dFy/dx - dFx/dy)` where F = 3D noise gradient. The tangent becomes a 3D vector, and chatoyancy uses the full 3D view vector. Feathers now shift differently as the stone is tilted toward or away from you (not just rotated).

**[ADD-B] STREAMLINE INTEGRATION FOR FEATHER PATHS:** Instead of sampling curl noise at a point, integrate along streamlines. Start at `p`, step along `tangent(p)` for N steps, accumulate `chatoyancy += pow(1.0 - abs(dot(L.xy, tangent(pos))), 16.0) * exp(-stepN * 0.3);` per step. The result is that the specular highlight smears along the actual path of the feather fiber — not just the local direction — giving a "stroke" quality to each highlight.

**[ADD-C] AUDIO-REACTIVE PLUME DENSITY:** Drive plume density with FFT magnitude bands: `float density = mix(0.3, 1.5, audio_band_3);` — bass frequencies control the low spatial frequency of the feathers; treble controls the micro-fiber density. Stone appears to "breathe feathers" to the music. Bind `audio_spectrum` as a 1D texture uniform from a Web Audio API analyser node in JS.

**Applies when:** Seraphinite, Chrysotile Serpentine, any chatoyant fibrous silicate.

---

## LESSON 23 — OKENITE: POLAR NEEDLE FUZZ / SUB-RESOLUTION DENSITY
**Category:** High-Frequency Visual Softness / Volumetric Fuzz
**Priority:** ELEVATED
**Source:** "Ten thousand lines then let GPU sampling jitter them into a soft haze. fwidth() to blur needles at center, keep distinct at edges. Core glow: exp(-r*4.0)."

`float freq = 800.0` — this high frequency triggers GPU anti-aliasing as intentional blur. `float needles = sin(theta * freq + hash(theta) * 10.0)` — random phase per theta prevents Moiré. `float hair_mask = pow(needles, 2.0) * edge_mask`. Alpha transition: `smoothstep(0.65, 0.55, r + needles * 0.05)` — needles extend the edge silhouette.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] STRAND-BASED VOLUME RENDERING:** Each Okenite needle is a 3D fiber. Instead of 2D polar noise, raymarch a 3D field of `sdCapsule(p, root, tip, radius)` with radius=0.001. Use cone-marching for efficiency at such small radii. The fibers are genuinely 3D — occlude each other, cast self-shadows, show proper depth recession. The puffball reads as 3D rather than a "disc with fuzz."

**[ADD-B] MIE SCATTERING FOR THE PUFF:** Okenite fibers are thin enough that Mie scattering is significant (fiber diameter ≈ light wavelength). Forward-scatter phase function: `float mie = (1.0 - g*g) / pow(1.0 + g*g - 2.0*g*cosTheta, 1.5);` where g≈0.8 (strongly forward-scattering). Light shining *through* the puffball: `transmitted = base_glow * mie_phase * exp(-density * extinction)`. Result: backlit Okenite glows with an otherworldly internal halo; front-lit shows surface needles more clearly.

**[ADD-C] POISSON-DISK DISTRIBUTED PUFF CLUSTER:** Real Okenite grows in geode-like cavities as multiple spherical puffs. Use Poisson Disk sampling in JS to place 20-40 puff centers within a bounded region, with minimum separation distance = 2× average radius. In GLSL: sum `fuzz_intensity(uv, center[i], radius[i])` for the 5 nearest centers (BVH acceleration). Each puff is an independent fuzz field with slight animation phase offset — they appear to breathe and sway out of sync.

**Applies when:** Okenite, Mesolite, fine-fibrous zeolites, any acicular mineral forming cottony aggregates.

---

## LESSON 24 — IRIDESCENT GOETHITE (TURGITE): BOTRYOIDAL SPECTRAL MAP
**Category:** Metallic Phase-Shifting / Curvature-Dependent Color
**Priority:** ELEVATED
**Source:** "Smooth-Min Sphere Field for botryoidal habit + Normal Variation drives high-frequency palette. 'Oil-Slick' rainbow that shatters across bubbling surface via curvature."

`smin(d1, d2, 0.1)` for grape cluster. Fake normal from SDF gradient: `vec3 norm = normalize(vec3(d - d_eps_x, d - d_eps_y, 0.1))`. Phase: `angle * 2.0 + curvature * 3.0 + u_time * 0.1` drives `spectral_palette`. Oily sheen: `spectral_palette(angle * 5.0) * 0.2 * (1.0 - smoothstep(0.0, 0.02, abs(d)))` — only on zero-crossing surface.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] PEEL INTERFERENCE EQUATIONS (EXACT):** Implement Fabry-Pérot thin-film interference exactly: `float phi = 4.0 * PI * n * thickness * cosTheta / lambda;` `float R = (r*r + r*r - 2.0*r*r*cos(phi)) / (1.0 + r*r*r*r - 2.0*r*r*cos(phi));` where r = single-surface reflectance, n = 2.8 (hematite/goethite). Compute for λ=450, 550, 650nm separately. Produces physically accurate iridescence that changes smoothly with incidence angle rather than jumping through palette lookups.

**[ADD-B] SURFACE CURVATURE FROM SDF HESSIAN:** More accurate than simple gradient difference: compute the full Hessian of the SDF to get principal curvatures. `float H = (d_xx + d_yy) * 0.5` (mean curvature). `float K = d_xx * d_yy - d_xy*d_xy` (Gaussian curvature). Map H to oxide layer thickness, K to oxide layer roughness. Concave valleys = thicker oxide = cyan/violet. Convex peaks = thinner oxide = gold. More geologically accurate than the simple curvature approximation.

**[ADD-C] CRACKED IRIDESCENCE (RUST ZONES):** Where the oxide layer cracks (high tensile stress = high curvature), the iridescence fractures into patches. Compute crack pattern: Voronoi cells with boundaries = crack lines. `float crack_mask = smoothstep(0.03, 0.0, voronoiEdge);` Iridescence is continuous WITHIN cells but jumps discontinuously AT cell boundaries (because the oxide layer thickness resets at each crack). The visual = patches of coherent color with sharp rainbow boundaries between them.

**Applies when:** Iridescent Goethite, Turgite, Peacock Ore (Chalcopyrite), Bornite, any tarnished metallic oxide.

---

## LESSON 25 — YOOPERLITE: UV-REACTIVE FLUORESCENCE TOGGLE
**Category:** Spectral Toggle / Emissive Reveal
**Priority:** ELEVATED
**Source:** "Spectral Toggle — grey stone base state, UV torch (mouse) triggers high-emissive Voronoi glow in orange-gold spectrum. uv_lens = smoothstep(0.5, 0.1, uv_dist)."

Stone base: `vec3(0.2, 0.21, 0.23)`. UV reveal via `smoothstep(0.5, 0.1, length(uv - mouse))`. Fire: `pow(1.0 - sodalite_cells(uv * 8.0), 4.0) * vec3(1.0, 0.4, 0.0) * 5.0`. UV haze: `vec3(0.1, 0.0, 0.4) * uv_lens * 0.5` — the torch glows faint violet.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] STOKES SHIFT FLUORESCENCE (PHYSICALLY BASED):** Real fluorescence absorbs shorter wavelengths and re-emits at longer wavelengths (Stokes shift). Model: the UV excitation is at ~365nm (invisible); emission peak at ~580nm (orange). The emitted light is *omnidirectional* regardless of view angle — unlike specular, fluorescence doesn't have a preferred viewing direction. Implement: `float fluor_intensity = excitation_flux * quantum_yield;` emission color always `vec3(1.0, 0.55, 0.0)` regardless of viewDir.

**[ADD-B] PHOSPHORESCENCE (AFTERGLOW):** Some fluorescent sodalites exhibit phosphorescence — they continue to glow after the UV light is removed. Implement with a slow-decay feedback buffer: `float glow = texture2D(u_buffer, uv).r * 0.995 + new_excitation;` The 0.995 factor creates exponential decay. After removing the UV torch (mouse), areas exposed longest continue glowing for several seconds. Phosphorescence color slightly different from fluorescence — shifted toward warmer orange as higher-energy pathways decay first.

**[ADD-C] QUANTUM YIELD MAP:** Not all sodalite patches fluoresce equally — some mineral inclusions quench the fluorescence (reduce quantum yield). Generate a Voronoi-based quenching map: `float quench = 1.0 - step(0.3, quench_noise(uv * 3.0));` Some Voronoi cells have nearly zero fluorescence — dark spots in the UV field. This is accurate to real Yooperlite which shows patchy, not uniform, fluorescence based on local chemistry.

**Applies when:** Yooperlite, Fluorite, Calcite, Willemite, Scheelite, any fluorescent mineral.

---

## LESSON 26 — RUTILATED QUARTZ: INTERNAL PARALLAX INCLUSIONS
**Category:** Volumetric Depth Deception / Nested Raymarching
**Priority:** ELEVATED
**Source:** "Dual-pass: Shell (outer crystal facets) + Inclusion Loop (3D field of infinite line segments inside). Parallax: internal_uv = uv + viewDir.xy * z_layer."

8 depth layers, each `z_layer = float(i) * 0.1`. `internal_uv = uv + viewDir.xy * z_layer`. Needle seed: `fract(sin(z_layer * 123.4) * 456.7)`. Needle presence: `smoothstep(0.98, 0.99, fract(sin(dot(internal_uv, vec2(12.9,78.2)) + seed)))`. Gold glint: `pow(max(0.0, dot(viewDir, lightDir)), 32.0) * needle_mask`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] TRUE 3D NEEDLE SDF WITH SNELL'S LAW REFRACTION:**
```glsl
// On entry to crystal surface, bend ray
vec3 refracted = refract(rd, surfaceNormal, 1.0/1.544);  // Quartz IOR
// March refracted ray through interior
for(int i=0; i<30; i++) {
  vec3 p = entry_pos + refracted * t_interior;
  float needle_d = sdNeedle(p, needle_a, needle_b, 0.003);
  // ...
}
```
The refracted ray shifts based on viewing angle — needles at steep incidence appear to lean toward you. This is what separates "internal parallax" from "internal parallax WITH refraction" — a visible and important difference.

**[ADD-B] SAGENITE SPRAY PATTERN:** Some rutilated quartz ("Sagenite") has needles arranged in radiating fans or V-shapes on cleavage planes. In JS, define fan origins as `vec2[]` array, generate needle endpoints at a specific angle spread ±15°. In GLSL, check closest fan needle: `float fan_d = sdNeedle(p, fanOrigin, fanOrigin + dir * length, 0.002);` The geometric regularity of fan patterns reads immediately as mineral character vs random needle placement.

**[ADD-C] TOTAL INTERNAL REFLECTION CONE:** When a ray inside the quartz hits the surface at too steep an angle, total internal reflection (TIR) occurs. Critical angle for quartz: `theta_c = arcsin(1.0 / 1.544) ≈ 40°`. Rays that would exit are reflected back inside: `if (dot(rd, surfaceNorm) > cosCriticalAngle) { rd = reflect(rd, surfaceNorm); }` The TIR creates bright "trapped light" patches that move dramatically as you rotate the crystal — a phenomenon impossible to fake with simple parallax mapping.

**Applies when:** Rutilated Quartz (Venus Hair Stone), Tourmaline in Quartz, any inclusion-bearing transparent crystal.

---

## LESSON 27 — ALEXANDRITE: KELVIN-DRIVEN SPECTRAL ABSORPTION
**Category:** Chromatic Adaptation / Electronic Transitions
**Priority:** ELEVATED
**Source:** "Spectral Pleochroism — chromium Cr³⁺ ions create absorption notch at ~580nm. As light temperature shifts, green collapses, red explodes."

`alexandrite_logic(temp, angle)`: `emerald = vec3(0.1, 0.6, 0.4)`, `ruby = vec3(0.6, 0.1, 0.3)`. Shift: `smoothstep(0.4, 0.6, temp + angle * 0.2)`. The `angle * 0.2` term adds pleochroism — different crystal faces show different hues even under the same light. Internal fire: `pow(max(0.0, 1.0 - length(f)), 16.0)` — high-exponent hexagonal facets.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] CIE COLOR MATCHING FUNCTIONS:** For true spectral simulation of the Alexandrite effect, compute the tristimulus values by integrating SPD × CMF: `for(float lambda = 380.0; lambda < 750.0; lambda += 10.0) { float transmittance = alexandriteTransmittance(lambda, temp); X += transmittance * cmf_x(lambda); Y += transmittance * cmf_y(lambda); Z += transmittance * cmf_z(lambda); }` Convert XYZ to sRGB. This IS the physically correct Alexandrite — it will shift between different shades of green and purple (not just "green" and "red") based on the actual chromium absorption spectrum.

**[ADD-B] METAMERISM VISUALIZATION:** Two light sources can make Alexandrite appear IDENTICAL in color even though its spectral response would make them appear different under daylight. Implement a "metamerism demo mode": show side-by-side views of the same crystal under different illuminants. `vec3 left_color = alexandriteUnderIlluminant(D65, viewDir);` vs `vec3 right_color = alexandriteUnderIlluminant(A_source, viewDir);` The dramatic color jump illustrates why Alexandrite is famous.

**[ADD-C] DIGITAL TWIN LIGHT TEMPERATURE SENSOR:** Pull real color temperature from the user's webcam in JS (sample a white area, compute CCT from RGB ratios using McCamy's formula: `CCT = -449*n³ + 3525*n² - 6823.3*n + 5520.33`). Pass as `u_lightTemp`. The Alexandrite shader NOW RESPONDS TO THE ACTUAL LIGHT IN THE ROOM. In fluorescent office light (5000K) → green. Under incandescent desk lamp (2800K) → raspberry red. A true ambient-reactive digital Alexandrite.

**Applies when:** Alexandrite, Color-change Garnet, Tanzanite, any pleochroic gemstone.

---

## LESSON 28 — ENHYDRO QUARTZ: GRAVITY-AWARE FLUID VOID
**Category:** Hydrostatics / Gravity-Aligned SDF
**Priority:** ELEVATED
**Source:** "Gravity Vector — driven by mouse. Bubble position: cavity_pos + gravity_up * (cavity_radius * 0.7). Wobble: sin(u_time * 2.0) * 0.02. Meniscus line: smoothstep(0.01, 0.0, abs(dot(uv - cavity_pos, gravity_up)))."

Crystal shell: `max(abs(uv.x), abs(uv.y)) - 0.7`. Bubble: radius 0.08, rim via `pow(1.0 - dist_to_bubble * 12.0, 2.0)` — rim Fresnel. State logic: crystal → water pocket → bubble, controlled by distance comparisons.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] SPH FLUID SIMULATION FOR WATER SLOSHING:** Use Smoothed Particle Hydrodynamics in JS (lightweight 2D version with ~50 particles). Particles = water molecules. Gravity vector drives acceleration. On mouse tilt: gravity rotates, particles respond with momentum. Pass particle positions and velocities as texture. In GLSL: `float water_level = sphWaterHeight(uv, particles);` The bubble rises to the top of the SPH surface rather than a fixed position — genuinely dynamic liquid with sloshing, surface tension, and momentum.

**[ADD-B] MENISCUS SDF (CONTACT ANGLE):** Water in quartz forms a concave meniscus — the water-air interface curves upward at the quartz walls (hydrophilic contact angle ≈ 0°). Implement: `float meniscus_curve = -exp(-dist_to_wall * 20.0) * 0.03;` — surface curves up near walls. The bubble ALSO shows a meniscus: `float bubble_meniscus = exp(-dist_to_bubble * 10.0) * curvature;` The contact lines are where light focuses and creates the characteristic bright ring around the bubble base in real Enhydros.

**[ADD-C] ANCIENT ATMOSPHERE SPECTRAL ANALYSIS:** If you know the geological age (say, 100 Ma for Cretaceous), you know the atmospheric composition. Cretaceous air: ~1500 ppm CO₂, ~30% O₂. These gases have different refractive indices: CO₂: n≈1.00045, O₂: n≈1.000271. The bubble's IOR is slightly different from modern air: `float ior_bubble = 1.0 + cretaceous_co2_ppm * co2_refractivity;` — produces a slightly different Fresnel sparkle than a "modern air" bubble. Geologically pedantic and aesthetically indistinguishable, but the idea is incredible.

**Applies when:** Enhydro Quartz, Fluid inclusions in any mineral, Halite with brine pockets.

---

## LESSON 29 — MOONSTONE: ADULARESCENCE / SUBSURFACE SCATTERING ANISOTROPY
**Category:** Mie Scattering / Internal Volume Glow
**Priority:** ELEVATED
**Source:** "Decouple glow from surface — light isn't on the stone, it's in the stone's memory. Billow cloud_noise + flash from dot(viewDir, lightDir) elevated to power 8."

Cloud billowing: 3 octaves of `cloud_noise(cloud_uv * float(i) + u_time * 0.05) * (1.0/float(i))`. Flash: `pow(max(0.0, dot(viewDir, normalize(vec3(mouse, 1.0)))), 8.0)`. Rim: `pow(dist, 4.0) * sphere_mask` — power glow at sphere silhouette.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] TRUE MIE SCATTERING PHASE FUNCTION:** Mie scattering (appropriate for particles ~λ in size) has a phase function with a strong forward peak. For Moonstone's micro-layers (spacing ≈ 100-300nm): `float g = 0.8;  // asymmetry parameter` `float mie_phase = (1.0 - g*g) / pow(4.0 * PI * (1.0 + g*g - 2.0*g*cosTheta), 1.5);` The strong forward scattering means the adularescence is brighter when the light is *behind* the stone, shining toward you through it — exactly what makes backlit Moonstone spectacular.

**[ADD-B] MULTI-LAYER SCHILLER INTERFERENCE:** The orthoclase/albite lamellae in Moonstone typically consist of ~15-30 alternating layers each ~10-100nm thick. Implement as multi-beam interference: `for(int k=0; k<N_LAYERS; k++) { float delta = 4.0*PI*n*layer_thickness[k]*cosTheta/lambda; R += r[k] * exp(2.0*PI*i * (sum_delta)); }` (complex amplitude addition, then take |R|²). N=20 layers with slight thickness variation produces the characteristic diffuse "shiller" glow rather than a sharp Bragg peak.

**[ADD-C] RAINBOW MOONSTONE (LABRADORITE CROSSOVER):** Some moonstones show spectral colors ("Rainbow Moonstone" = actually labradorite). Add a second "diffraction" component that triggers when `flash > 0.7`: `vec3 rainbow = 0.5 + 0.5 * cos(6.28 * (flash + vec3(0, 0.33, 0.67)));` blended with the blue adularescence at `mix(adularescence, rainbow, flash_strength - 0.7)`. The result: predominantly blue-white with spectral bursts at peak orientation — indistinguishable from museum-grade Rainbow Moonstone.

**Applies when:** Moonstone, Rainbow Moonstone (Labradorite), Oligoclase, any Adularia.

---

## LESSON 30 — CAVANSITE: RADIATING PRISMATIC VOIDS / ELECTRIC ROSETTES
**Category:** Saturated Geometric Rosettes / High-Contrast AO
**Priority:** ELEVATED
**Source:** "Spherical Harmonics Field approach — modulate sphere radius with needle_noise. Ambient Occlusion in needle cracks for Shadow-to-Neon transition. Blue channel B > 1.0 — overdriven."

`needle_noise(p)`: `pow(abs(sin(n.x*60.0)*sin(n.y*60.0)*sin(n.z*60.0)), 0.5)` on normalized p. `sdRosette(p, r)`: `length(p) - (r + needle_noise(p)*0.15)`. Overdrive: `neon_blue = vec3(0.0, 0.4, 2.5)` — raw blue channel = 2.5. Deep indigo in occlusion: `vec3(0.0, 0.05, 0.2)`. `mix(deep_indigo, neon_blue, ao)`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] SPHERICAL HARMONIC BASIS DECOMPOSITION:** For mathematically pristine rosette patterns, use SH basis functions instead of sin products. `float sh_l2_m2 = sqrt(15.0/PI) * n.x * n.y;` `float sh_l3_m3 = 0.25 * sqrt(35.0/(2.0*PI)) * (3*n.x*n.x - n.y*n.y) * n.y;` Linear combination of SH bands creates different rosette symmetries: l=2 → 4-fold, l=3 → 6-fold, l=4 → 8-fold. Cavansite = l=4 (vanadium octahedral coordination → 6-fold rosettes). Exact crystallographic symmetry from mathematics.

**[ADD-B] HEMIMORPHISM (ASYMMETRIC ROSETTE):** Real Cavansite has hemimorphic crystals — the two ends of the c-axis look different (orthorhombic point group mm2). One termination is wider, the other narrower. Model by applying different `needle_noise` parameters to the +z and -z hemispheres of each sphere: `float hemi_factor = 1.0 + 0.4 * sign(p.z);` `float r_modified = base_r * hemi_factor;` The rosette is subtly asymmetric — one side "opens" wider than the other.

**[ADD-C] STILBITE MATRIX SUBSTRATE:** Real Cavansite grows ON Stilbite — a pearly, white, bladed zeolite that looks like tiny book-pages. Render Stilbite as a background: thin `sdBox(p, vec3(0.3, 0.02, 0.4))` instances scattered at random orientations, each slightly translucent with a pearlescent Fresnel. The cobalt-blue Cavansite rosettes sitting on blinding-white Stilbite pages = one of mineralogy's most dramatic color contrasts. Include both in the same shader.

**Applies when:** Cavansite, Pentagonite (its polymorph), Wairauite, any intensely saturated blue secondary mineral.

---

## LESSON 31 — SPECTROLITE: LAMELLAR INTERFERENCE PLANES (BØGGILD TRAP)
**Category:** Full-Spectrum Feldspar Fire / Half-Vector Alignment
**Priority:** CORE
**Source:** "Half-Vector between Light and View aligned with internal flash plane — schiller_mask = pow(max(0.0, alignment), 128.0). Color based on exact angle of alignment * 5.0."

`flash_normal` warped with `0.1 * sin(uv * 10.0 + u_time * 0.1)` for organic layer wobble. `spectrolite_color(angle)`: `pow(0.5 + 0.5*cos(6.28*(angle + vec3(0.0, 0.33, 0.67))), vec3(2.0)) * 2.0` — power-2 compression + 2× brightness overdrive. Near-black base: `vec3(0.02, 0.02, 0.03)`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] MULTIPLE TWINNING PLANES (POLYSYNTHETIC TWINNING):** Real Spectrolite has 3-5 sets of twinning planes at different orientations (the Bøggild miscibility gap produces both albite and pericline twinning). Add multiple `flash_normals[]` and sum their schiller contributions: `for(int t=0; t<4; t++) { alignment[t] = dot(halfV, warpedNormal(flash_normal[t])); schiller += spectrolite_color(alignment[t] * freq_shift[t]) * pow(max(0.0, alignment[t]), sharpness[t]); }` Different planes produce different colors (blue from one orientation, orange from another) that overlap in characteristic "Finnish fire" patterns.

**[ADD-B] DEVICE ORIENTATION API (PHYSICAL TILT RESPONSE):** On mobile, bind to `DeviceOrientationEvent` in JS: `window.addEventListener('deviceorientation', (e) => { u_lightDir = quaternionFromEuler(e.alpha, e.beta, e.gamma) * baseLight; });` The schiller ONLY fires when you physically tilt your phone to the correct orientation. At all other angles, the stone is pitch-black. This is the defining experience of high-quality Spectrolite — the flash appears instantly and vanishes as you tilt.

**[ADD-C] SPECTRAL BAND ASSIGNMENT:** Different twinning planes in Spectrolite diffract different wavelengths (Bragg peaks at different λ based on lamellae spacing). Map each flash plane to a specific spectral color: plane 0 → violet (d=60nm), plane 1 → blue (d=80nm), plane 2 → cyan (d=100nm), plane 3 → orange (d=140nm). Color from each plane doesn't cycle through the rainbow as angle changes — it stays fixed to that plane's characteristic wavelength. More geologically authentic than the standard rotating-palette approach.

**Applies when:** Spectrolite, Labradorite, Anorthosite.

---

## LESSON 32 — AMBER: CHRONO-RESIN VOLUME
**Category:** Organic Chemistry / Paleontological Preservation
**Priority:** ELEVATED
**Source:** "Exponential decay for RGB channels — blue dies first, leaving Red/Gold glow. High-Viscosity Flow Noise. 3D Stochastic Inclusions with Parallax at different depths."

`honey = vec3(1.0, 0.7, 0.1)`, `cognac = vec3(0.4, 0.1, 0.0)`. Depth absorption: `mix(honey, cognac, pow(depth, 2.0))`. Parallax inclusions: 4 layers at `z = float(i)*0.15`, `p_z = uv + viewDir.xy * z`, `debris = step(0.98, flow_noise(p_z * 5.0)) * (1.0 - z)`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] BEER-LAMBERT VOLUMETRIC ABSORPTION (TRUE):** `vec3 extinction = vec3(0.1, 0.5, 2.0);` — high blue absorption (correct for Amber). March ray through volume: `vec3 transmittance = exp(-extinction * ray_length_through_amber);` Sample white light at entry, multiply by transmittance. The result: short amber paths = honey yellow. Long amber paths = deep cognac orange. Thin edges = nearly clear. Exact physical model of wavelength-selective absorption.

**[ADD-B] DOMINICAN BLUE FLUORESCENCE:** Dominican amber (Hymenaea resinite) fluoresces vivid sky-blue under UV. Implement as a second emission layer: `float surface_grazing = pow(max(0.0, 1.0 - abs(dot(viewDir, surfaceNormal))), 4.0);` — grazing-angle fluorescence. `vec3 blue_fluor = vec3(0.0, 0.4, 1.0) * surface_grazing * uv_proximity;` The result: transmitted light = golden amber; reflected surface at grazing angles = electric blue. Visually shocking and accurate.

**[ADD-C] BIOLOGICAL INCLUSION RENDERING (L-SYSTEM INSECT):** Generate a simplified "insect" inclusion using L-system geometry in JS: body = `sdCapsule` chain for thorax/abdomen, legs = 6 thin `sdCapsule` emanating from thorax, wings = `sdTriangle` pairs. All inclusions are internal to the amber SDF. Apply Beer-Lambert to light passing through amber to reach the inclusion. The inclusion itself uses a dark, matte color with micro-specular. Result: ancient insect permanently frozen in time-orange glass.

**Applies when:** Baltic Amber, Dominican Amber, Copal, any polymerized resin with inclusions.

---

## LESSON 33 — OPALIZED FOSSIL: BIOMORPHIC BRAGG DIFFRACTION
**Category:** Biological SDF + Photonic Crystal
**Priority:** ELEVATED
**Source:** "Logarithmic spiral for ammonite shape: fract(log(r)*1.5 - theta*0.159). 3D Voronoi domain → Bragg color per cell: spectral.r = smoothstep(0.4, 0.6, 1.0 - abs(lambda - 0.7))"

`shell_mask = step(r, 0.8) * step(0.1, r)`. Voronoi patches via `hash33(floor(p))` seeded sphere centers. Per-cell `interference = dot(viewDir, lightDir)`. `fire_color = bragg_color(domain * 1.5, cosTheta)`. Base opal: `vec3(0.1, 0.12, 0.15)`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] LOGARITHMIC SPIRAL CHAMBER INDICES:** Real ammonites have ≈14 chambers per whorl, each sealed by a septum. Model chamberization: `float whorl = log(r) / log(growth_rate); float chamber = fract(whorl * 14.0);` Each chamber is a separate color domain with its own silica sphere size (different opal fire color per chamber). The fire progresses through the spectrum as the spiral unwinds — like a rainbow encoded in geological history.

**[ADD-B] FIBROUS OPAL ORIENTATION (POTCH VS FIRE OPAL):** The opal can fill chambers in different ways. If silica settled along radial fibers: tangent vector = radial direction, domain normal = tangential. This produces fire that rolls AROUND the spiral. If settled from falling: domain normals = upward throughout. This produces fire that blinks in unison as you tilt in a single direction. Mix both based on `chamber_index` — some chambers show "common opal" (no fire), others show "precious opal" (fire), matching real botryoidal opal-in-fossil texture.

**[ADD-C] IRIDESCENT CEPHALOPOD NACRE (PRE-SILICIFICATION):** What did the ammonite shell look like when alive? Aragonite nacre (similar to modern Nautilus). Render a "before" mode using thin-film interference on `sdSpiral`: `float nacre_d = 0.0005; float nacre_n = 1.53;` — pearlescent white-pink-green iridescence. Blend between nacre (living) and opal (silicified) modes based on `u_time` or `u_mouse_x`. Watching the shell transition from living pearlescent nacre to dead opal fire over time = haunting and beautiful.

**Applies when:** Opalized Fossils, Ammolite (Ammonite nacre), Fire Agate, Boulder Opal with ironstone host.

---

## LESSON 34 — LUDWIGITE-VONSENITE: KAJIYA-KAY RADIATING ANISOTROPY
**Category:** Ferro-Borate / High-Aspect Fiber Specularity
**Priority:** ELEVATED
**Source:** "Radiating Tangent Field — tangent = normalize(uv) from center. Kajiya-Kay Specular: sinTH = sqrt(1 - dotTH²); spec = pow(sinTH, 128). High-frequency radial fibers: step(0.5, sin(theta * 500.0))."

Fibers: `sin(theta * 500.0 + sin(dist*10.0))` — angular oscillation modulated by radial oscillation (prevents concentric uniformity). Lead black: `vec3(0.02, 0.02, 0.03)`. Metallic glint: `vec3(0.6, 0.65, 0.8)` — cold silver-blue. Oil-slick tarnish: `vec3(0.1, 0.05, 0.2) * pow(1.0 - dist, 4.0)`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] MAGNETIC FIELD VISUALIZATION:** Vonsenite is magnetic. Visualize the magnetic field: define magnetic dipole at crystal center, compute `vec3 B = (3.0 * dot(m, r_hat) * r_hat - m) / pow(length(r), 3.0);` where `m = magnetization_vector`. The fibers ALIGN with the magnetic field lines at the surface — they point tangentially to B-field iso-surfaces. As you animate `m` rotating with `u_time`, fibers sweep across the surface following the rotating field. Scientifically correct for a magnetic mineral.

**[ADD-B] FIBER DENSITY FALLOFF (RADIAL EXHAUSTION):** Real crystal fibers aren't uniform in density — they're densest near the growth nucleus and sparser at the periphery (nutrient exhaustion during growth). `float fiber_density = exp(-dist * 3.0) * fiber_frequency;` — fibers pack tightly at center, spread toward edges. Specular highlight shape changes from "sharp starburst ring" (dense center) to "sparse whisker tips" (sparse edge). Captures the visual character of radiating-fibrous crystal aggregates far better than uniform density.

**[ADD-C] VOID-CORE CLUSTER (COCKADE TEXTURE):** Many radiating mineral clusters have a void in the center where the growth substrate was (e.g., a shell that dissolved). Add a spherical void SDF: `float void_hole = -(length(uv) - 0.15)` — carve out center. The fibers point toward and around this void. Light reflecting off the inner void walls creates a secondary glow that escapes through the fiber gaps — "lantern" effect looking into the cluster center.

**Applies when:** Ludwigite, Vonsenite, Chrysotile, Pectolite, any radiating fibrous aggregate.

---

## LESSON 35 — LONSDALEITE: HEXAGONAL IMPACT LATTICE / SHOCK LAMELLAE
**Category:** Extra-Terrestrial / Hexagonal Crystal System
**Priority:** ELEVATED
**Source:** "Hexagonal Prism SDF: sdHexPrism using the vec3 k = (-0.866, 0.5, 0.577) trick. Shock Lamellae: sin(p.z*100.0 + p.x*50.0). Specular N=512 for Impossible Hardness."

`const vec3 k = vec3(-0.8660254, 0.5, 0.57735)` — the hexagonal lattice basis vector. SDF: `p = abs(p); p.xy -= 2.0 * min(dot(k.xy, p.xy), 0.0) * k.xy;` Lamellae: parallel shock planes visible as `sin(p.z*100.0 + p.x*50.0) * 0.5 + 0.5`. Impact flicker: `vec3(1.0, 0.5, 0.0) * shock * 0.2` where shock = sparse stripe.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] 4D HEXAGONAL CRYSTAL SLICING:** Lonsdaleite's hexagonal diamond structure is most naturally described in 4D space (the 4D to 3D projection of the diamond cubic lattice). Define the 4D hexagonal lattice vectors, project to 3D: `vec3 proj = vec4_to_hex_3d(p_4d, u_time * 0.001);` The slow 4th-dimension rotation reveals different cross-sections of the same 4D crystal — each slice looks like a valid 3D Lonsdaleite sample but with different lamellae orientations.

**[ADD-B] HUGONIOT ELASTIC LIMIT (SHOCK WAVE PROPAGATION):** Model the impact shock wave that creates Lonsdaleite propagating through space. Define shock front as `float shockR = u_time * shockSpeed; float shock_intensity = exp(-pow(length(p) - shockR, 2.0) / shockWidth);` Behind the front: Lonsdaleite (hex diamond, stardust gold color). In front: ordinary graphite precursor (matte black). The shader literally shows the impact-metamorphism process in real-time.

**[ADD-C] CRATERED SURFACE DISTRIBUTION:** In actual impact craters, Lonsdaleite doesn't form uniformly — it's patchy, concentrated in "shocked zones" between breccia blocks. Use a Voronoi fragmentation: each cell = one breccia block with its own shock pressure. Cells above pressure threshold → Lonsdaleite. Cells below → graphite or ordinary diamond. Cell boundaries = cataclastic zones. The result looks like a hand sample of Canyon Diablo meteorite.

**Applies when:** Lonsdaleite, Shock-metamorphosed graphite, Impact diamonds, any ultra-high-pressure carbon polymorph.

---

## LESSON 36 — MAGMA: THERMAL-KINETIC ADVECTION / BLACKBODY RADIATION
**Category:** Pre-Lithic Fluid Dynamics / Emissive Source
**Priority:** CORE
**Source:** "Convection Cell — Curl-Noise Flow Field. CoolingFactor threshold → Crust texture. Blackbody approximation: Color = f(T) ≈ (T^1.5, T^4, T^8). Hot cracks exponentially brighter than cooling plates."

Flow: `vec2 flow(p) = vec2(sin(p.y + t), cos(p.x - t))`. Advect 4 iterations: `p += flow(p * 1.5) * 0.1`. Ridge noise for heat: `sum ridge(sin(dot(n_p, vec2(1.2, 0.8)))) * amp` over 5 octaves. `T = pow(heat, 2.5)` — nonlinear thermal. Emissive bloom: `hot * pow(T, 8.0) * 0.5`.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] WIEN'S DISPLACEMENT LAW (EXACT BLACKBODY):** `float T_kelvin = 400.0 + heat * 1600.0;` (400-2000K range). Wien's peak: `float lambda_peak = 2898000.0 / T_kelvin;` (in nm). Map to RGB: compute blackbody SPD at each wavelength, integrate against CIE CMFs. For 400K: deep IR-red glow. For 800K: cherry-red. For 1200K: orange. For 1600K: yellow-white. For 2000K: near-white incandescent. Matches real lava photography — molten rock really is this color.

**[ADD-B] NAVIER-STOKES PRESSURE TERM (COMPUTE SHADER):** For realistic lava advection, add the pressure-gradient correction: `vec2 vel_new = vel - grad(pressure) * dt;` where `pressure` is solved by the Poisson equation `∇²p = (ρ/dt) * ∇·vel`. Run as a WebGPU compute pass. The result has divergence-free flow — the lava "pushes" realistically around obstacles rather than compressing unnaturally. Pahoehoe ropy lava requires this because its surface tension prevents compressibility.

**[ADD-C] SULFUR DIOXIDE DEGASSING (VOLCANIC GAS PLUMES):** Add volcanic gas emission: at high-temperature zones, emit SO₂ gas columns. Simulate as Gaussian plumes: `float plume = exp(-pow(uv.x - vent_x, 2.0) / sigma_x) * exp(-uv.y / scale_height);` Tint: SO₂ = pale yellow-white. H₂S = slightly yellowish. Water vapor = white. Combine multiple plumes from different vent locations. The gas obscures the lava beneath in realistic ways and adds vertical structure to the otherwise horizontal flow.

**Applies when:** Lava flows (Pahoehoe, A'a), Magma chambers, Volcanic calderas, Pyroclastic flows.

---

## LESSON 37 — SYNTAX QUARTZ: ALPHANUMERIC CRYSTALLOGRAPHY (META-RENDER)
**Category:** Computational Ontogeny / Self-Referential Lattice
**Priority:** OPTIONAL
**Source:** "3x5 bit-font procedural character generator. Syntax Highlighting palette: Gold = keywords, Cyan = variables, Magenta = operators. Parallax layers of code at different depths."

`char(p, seed)`: maps `floor(p * vec2(3,5))` to `step(0.5, fract(sin(dot(p + seed, vec2(12.98, 78.23))) * 43758.54))`. Character color by type: `if(type > 0.8) color = gold; if(type < 0.2) color = magenta;` 5 depth layers with `view_parallax * z_layer` offset.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] ACTUAL GLSL PARSER IN JS → DATA TEXTURE:** Parse the current shader source code in JS using a simple tokenizer. Categorize tokens (keywords: vec2/vec3/float/etc., operators: +/-/*/dot/etc., literals: numeric). Assign each token a color and pack into a `Uint8Array` data texture. In GLSL: sample this "source code texture" for each code-glyph layer. The crystal literally contains the ACTUAL code that is drawing it — not random generated code, but the real source. True Syntax Quartz.

**[ADD-B] AST VISUALIZATION AS CRYSTAL STRUCTURE:** Parse the shader AST (Abstract Syntax Tree) in JS. Map AST node types to crystal habit: function declarations = large hexagonal prisms, for-loops = recursive hopper spirals, arithmetic ops = small rhombohedra. Lay out AST nodes in 3D space according to their depth in the tree. The crystal structure = the exact control flow graph of the program rendering it. Extreme meta-geological recursion.

**[ADD-C] SELF-MODIFYING SHADER (GLSL HOT-SWAP):** Track mouse path entropy in JS. When entropy exceeds threshold, recompile the shader with a mutated version of itself (swap a constant, change a loop bound, alter a palette). The crystal physically reshapes. The shader that renders the mutation IS the mutation. This is the W-Coeff 99.9 end state — code that writes code that renders the code that is writing it. Do not ship to production without a panic button.

**Applies when:** Syntax Quartz, Meta-render scenarios, live-coding performances.

---

## LESSON 38 — META-MINERAL: REACTION-DIFFUSION CALCIFICATION
**Category:** Morphogenetic / Gray-Scott Foundation
**Priority:** ELEVATED
**Source:** "Gray-Scott with luminance-gradient modulated feed/kill rates. Growth along paths of its own past failures. Pressure Term: if pixel too bright, diffusion slows → calcification."

Gray-Scott: `nextA = a + (Da * nabla2A - a*b*b + feed*(1-a))`. `nextB = b + (Db * nabla2G + a*b*b - (k+feed)*b)`. Dynamic kill rate: `float kill = 0.062 + pressure * 0.005` — more mineral = more kill = self-limiting growth. Output: `vec3(nextA, nextB, abs(nextA-nextB))` — third channel = stress visualization.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] ANISOTROPIC DIFFUSION (MINERAL-ALIGNED RD):** Standard RD uses isotropic Laplacian. Add a direction-dependent diffusion tensor: `mat2 D = mat2(da_x, 0.0, 0.0, da_y)` where `da_x ≠ da_y`. This forces the Gray-Scott patterns to align with a preferred axis — mimicking how minerals grow faster along crystal axes. For malachite: `da_c = 0.2` (along c-axis), `da_ab = 0.1` (perpendicular). The coral/spot patterns elongate along the c-axis, producing acicular rather than equant growth forms.

**[ADD-B] MULTI-SPECIES COMPETITION:** Run two separate Gray-Scott systems simultaneously, competing for the same UV-space "chemical substrate." Species A (malachite) grows with f₁/k₁; Species B (azurite) grows with f₂/k₂. Where A dominates → green palette; where B dominates → blue. Competition boundary zones → mixed green-blue = real malachite-azurite intergrowth. The Turing instability produces alternating bands or spots of two minerals in dynamic equilibrium.

**[ADD-C] GEOLOGICAL TIME ACCELERATION:** Each RD frame = one simulation "year." Accumulate a `geological_time` counter. At specific time thresholds, abruptly change feed/kill parameters: `t < 1000` (deposition phase) → coral-forming params; `t 1000-5000` (diagenesis) → different params; `t > 5000` (metamorphism) → high-temperature params that destroy earlier patterns and grow new ones. The mineral's visual history = a record of changing geological conditions.

**Applies when:** Malachite, Azurite, Turing-pattern minerals, any reaction-diffusion growth mineral.

---

## LESSON 39 — META-MINERAL: CELLULAR AUTOMATA UNCLAMPED ACCRETION
**Category:** MNCA / Floating-Point Logic Storm
**Priority:** OPTIONAL
**Source:** "Multiple Neighborhood CA with five concentric rings. Crystallization Band determines state increase. No clamp() — negative states become Subtractive Light Voids."

5-ring pressure: `r1=1.0, r2=3.0, r3=8.0`. Accretion: `if(r1 > 0.2 && r1 < 0.5) state += 0.05; if(r2 > 0.6) state -= 0.1; if(r3 < 0.1) state *= 1.01;` Color: `vec3(state*0.1, state*state, exp(state))` — no clamp, values overflow. Hardware artifact as aesthetic.

**ADDITIONAL TECHNIQUES:**

**[ADD-A] LENIA (SMOOTH LIFE) CRYSTALLIZATION:** Lenia is a continuous-state, continuous-time CA that produces truly life-like patterns. Growth kernel: `K(r) = exp(4.0 - 1.0/(r*(1.0-r) + eps))` (bell curve). `U(x) = convolve(A, K)(x);` `dA/dt = clamp(growth(U), -1, 1)` where `growth(u) = 2*exp(-pow((u-mu)/sigma, 2.0)) - 1;` By varying μ and σ, induce formation of mineral-like "creatures" — gliders that look like crystal dendrites, loops that look like ring silicates, standing waves that look like banded chert.

**[ADD-B] WOLFRAM CLASS IV → CRYSTAL EDGE:** Wolfram's Rule 110 (provably Turing-complete) runs at the boundary of order and chaos (Class IV). Implement as a 1D CA scan-line: `uint rule110(uint left, uint center, uint right) { return (rule & (1 << (left*4 + center*2 + right))) >> (left*4 + center*2 + right); }` Use each scanline as a texture row. Rule 110 output = complex, non-repeating patterns that look like mineral cross-sections — no two runs identical, patterns structurally reminiscent of chrysotile fiber bundles or fibrous zeolites.

**[ADD-C] SAND PILE MODEL (SELF-ORGANIZED CRITICALITY):** Abelian Sandpile Model: drop "grains" onto a grid, topple any cell with ≥4 grains by distributing 1 grain to each neighbor. The system self-organizes to the critical state. In shaders: implement as a feedback buffer CA. At criticality, the pile surface shows fractal power-law geometry. Color by grain density: 0 = void, 1 = loose sand, 2 = compressed, 3 = near-topple, ≥4 = actively toppling. The toppling zones look like crystal fracture fronts propagating through a grain aggregate.

**Applies when:** Abstract generative mineral contexts, W-Coeff > 10, any "what if the math became physical" scenario.

---

## LESSON 40 — UNIVERSAL SHADER INFRASTRUCTURE
**Category:** Pipeline / Utilities
**Priority:** CORE
**Source:** Synthesized from all specimens — universal utilities referenced throughout.

```glsl
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
```

**ADDITIONAL TECHNIQUES / UPGRADES:**

**[ADD-A] OKLAB COLOR SPACE FOR PERCEPTUALLY UNIFORM PALETTES:** All `pal()` calls work in linear RGB which creates perceptually uneven gradients. Convert to OKLab: `vec3 oklabPal(float t, ...)` — compute palette in OKLab, convert back. `vec3 srgbToOklab(vec3 c) { vec3 l = mat3(0.4122, 0.2119, 0.0883, 0.5363, 0.6770, 0.2817, 0.0514, 0.1111, 0.6300) * c; return mat3(0.2104, 1.9780, -2.4285, 0.7936, -2.4285, 7.9187, -0.0040, 0.4505, -5.4491) * (sign(l)*pow(abs(l), vec3(0.333))); }` Produces mineral colors that don't "grey out" in the middle of transitions.

**[ADD-B] COMMON MINERAL SDF PRIMITIVES:**
```glsl
float sdHexPrism(vec3 p, vec2 h) { /* from LESSON 35 */ }
float sdNeedle(vec3 p, vec3 a, vec3 b, float r) { vec3 pa=p-a, ba=b-a; float t=clamp(dot(pa,ba)/dot(ba,ba),0.,1.); return length(pa-ba*t)-r; }
float sdRhombohedron(vec3 p, float r) { return (abs(p.x)+abs(p.y)+abs(p.z)-r)/sqrt(3.0); }  // L1 sphere
float sdOctahedron(vec3 p, float s) { p=abs(p); return (p.x+p.y+p.z-s)*0.57735027; }
```

**[ADD-C] UNIVERSAL BRAGG PALETTE FUNCTION:**
```glsl
vec3 braggColor(float d, float cosTheta, float time_offset) {
  // d = lattice spacing (0.1 to 0.3), cosTheta = angle term
  float lambda = d * cosTheta;  // Effective reflected wavelength
  return pal(lambda + time_offset * 0.05,
    vec3(0.5), vec3(0.5), vec3(1.0, 1.0, 1.0), vec3(0.0, 0.33, 0.67));
}
```
Reusable across Labradorite, Opal, Muscovite, Spectrolite, Iridescent Goethite, Opalized Fossil.

**Applies when:** Every single mineral shader in this repo.

---

## LESSON CLUSTERS

### CLUSTER A: STRUCTURAL COLOR (Interference / Diffraction)
Lessons 02 (Labradorite), 04 (Opal), 11 (Muscovite), 20 (Covellite), 24 (Goethite), 31 (Spectrolite), 32 (Amber), 33 (Fossil)
— All rely on thin-film or Bragg interference logic. Always use high-contrast masks for "flash." Base color = dark/neutral. Color = interference only.

### CLUSTER B: ANISOTROPIC FIBER SHADING (Chatoyancy)
Lessons 05 (Tiger's Eye), 10 (Cummingtonite), 22 (Seraphinite), 34 (Ludwigite)
— All use tangent-vector specularity. Core formula = Kajiya-Kay or Ward-Duer. Mouse = light direction for interactive roll. Add curl/flow noise to tangent for non-straight fibers.

### CLUSTER C: SDF GEOMETRY (Signed Distance Fields)
Lessons 03 (Botryoidal), 06 (Bismuth), 07 (Amethyst), 08 (Pyrite), 15 (Stibnite), 16 (Crocoite), 35 (Lonsdaleite)
— Raymarch-based. Always test Smooth-Min variant selection before committing. KIFS for recursive geometry. Note hollow vs solid subtraction.

### CLUSTER D: TEMPORAL / REACTIVE
Lessons 14 (Vivianite), 17 (Realgar), 27 (Alexandrite), 28 (Enhydro), 25 (Yooperlite)
— All require either feedback buffer (Buffer A) or u_lightTemp/u_mouse-driven reactive state. Note: Realgar and Vivianite require irreversible accumulation (no reset).

### CLUSTER E: VOLUMETRIC / DEPTH
Lessons 04 (Opal parallax), 26 (Rutilated Quartz), 29 (Moonstone), 32 (Amber)
— All simulate depth inside a solid. Either parallax mapping (fast) or true refracted raymarch (correct). Beer-Lambert absorption essential for depth accuracy.

### CLUSTER F: POLAR / RADIAL
Lessons 01 (Agate polar variant), 10 (Cummingtonite), 23 (Okenite), 34 (Ludwigite)
— All operate in polar coordinates. `float theta = atan(uv.y, uv.x); float r = length(uv);` Core pattern lives in θ-space. Mouse = angular light direction.

### CLUSTER G: STOCHASTIC / DECAY
Lessons 09 (Uraninite), 13 (Fordite), 17 (Realgar), 38 (RD), 39 (MNCA)
— All use hash-noise for material-level stochasticity. Fordite uses per-layer DNA. Uraninite uses inverse-square particle hits. Realgar uses spatial + temporal decay. RD/MNCA use mathematical overflow deliberately.

### CLUSTER H: META / RECURSIVE
Lessons 06 (Bismuth KIFS), 07 (Amethyst KIFS), 37 (Syntax Quartz), 39 (MNCA unclamped)
— W-Coeff > 10 territory. Recursion on recursion. Use only when the geological vibe calls for "the shader is eating itself."

### CLUSTER I: SUBSTRATE + INCLUSION
Lessons 26 (Rutilated), 28 (Enhydro), 32 (Amber), 33 (Fossil), 30 (Cavansite on Stilbite)
— All render a "guest" material inside a "host" material. Host SDF defines boundary. Guest has independent shading rules inside that boundary. Parallax or full refraction depending on budget.

### CLUSTER J: UTILITY / INFRASTRUCTURE
Lesson 40 (Universal Infrastructure)
— Start here. Load palette function, hash functions, smin, rot2, before touching any mineral shader.

---

## FORGE REPORT
- Total lessons extracted: 40 (37 mineral specimens + 1 RD meta + 1 MNCA meta + 1 infrastructure)
- Lessons adapted [ADAPTED]: 0 — all content is GLSL-executable or JS-hybrid executable
- Redundant fragments merged: 3 — (Labradorite/Spectrolite merged into separate lessons sharing BRAGG foundation; Chalcanthite appears twice in PDF — merged; JS hybrid pattern recurring across 8+ minerals — unified in Cluster G)
- Assumptions made: WebGL2 with optional feedback buffer; u_time/u_resolution/u_mouse uniform convention; reposcripter operates in Shader Forge 3 context; JS hybrid = JavaScript passes data as uniforms or 1D/2D textures
- Fragments unclear but kept: "Lens 07 (Voronoi Infestation)" referenced in Opal section — assumed to refer to the 3D Voronoi technique in Lesson 04; "Episode 36 Verlet" reference assumed to be a prior session's physics engine lesson
- Fragments NOT neutralized: All W-Coeff > 10 content, all "remove clamp()" and "overflow into UV Specter Domain" content — these are intentional aesthetic choices, not errors. Hardware overflow-as-aesthetic is valid.

**TOTAL ADDITIONAL TECHNIQUES ADDED: 120 (3 per mineral × 40 lessons)**
