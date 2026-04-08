# CONTROLLED VOCABULARY

All controlled vocabulary for mineral entries in this database.
Use exactly these values in YAML files to ensure consistency and validation.

---

## `chemistry_class` Values

| Value | Description |
|-------|-------------|
| `native-element` | Single element minerals (gold, diamond, sulfur, graphite) |
| `sulfide` | Metal sulfides (pyrite, chalcopyrite, galena) |
| `oxide` | Metal oxides including hydroxides (corundum, hematite, chrysoberyl) |
| `carbonate` | Carbonate minerals (calcite, malachite, rhodochrosite) |
| `sulfate` | Sulfate minerals (barite, celestite, gypsum) |
| `phosphate` | Phosphate minerals — includes arsenate and vanadate (turquoise, apatite) |
| `silicate` | Silicate minerals — the largest class (quartz, beryl, feldspar, tourmaline) |
| `halide` | Halide minerals (fluorite, halite) |
| `mineraloid` | Non-crystalline mineral-like materials (opal, obsidian, amber, jet) |
| `organic` | Organic minerals and materials (amber, jet, pearl) |

> Note: `organic` and `mineraloid` overlap for some materials (amber); use whichever is more specific.

---

## `species_status` Values

| Value | Description | Example |
|-------|-------------|---------|
| `species` | Valid IMA-approved mineral species | quartz, corundum, pyrite |
| `variety` | Named variety of a species | amethyst (quartz), ruby (corundum) |
| `mineraloid` | Non-crystalline mineral-like material | opal, obsidian, amber |
| `rock/gem material` | A rock or multi-mineral gem material | jasper, lapis lazuli |
| `trade name` | Commercial trade name without species status | prasiolite, tsavorite |

---

## `ima_status` Values

| Value | Description |
|-------|-------------|
| `approved` | Currently IMA-approved species |
| `grandfathered_approved` | Historical species accepted before IMA formal approval process |
| `not_ima` | Variety, trade name, or informal designation — not an IMA species |
| `n/a` | Not applicable — mineraloid or organic material outside IMA scope |

---

## `crystal_system` Values

| Value | Notes |
|-------|-------|
| `triclinic` | Least symmetric; a ≠ b ≠ c; α ≠ β ≠ γ ≠ 90° |
| `monoclinic` | One symmetry axis; α = γ = 90°, β ≠ 90° |
| `orthorhombic` | Three perpendicular axes; a ≠ b ≠ c; all 90° |
| `tetragonal` | One 4-fold axis; a = b ≠ c; all 90° |
| `trigonal` | Three-fold symmetry; often described in hexagonal setting |
| `hexagonal` | Six-fold symmetry; a = b ≠ c; 120° |
| `isometric` | Cubic; a = b = c; all 90°; highest symmetry |
| `amorphous` | No crystalline structure (mineraloids, glass, organic) |

---

## `luster` Values

| Value | Description |
|-------|-------------|
| `metallic` | Mirror-like metal (gold, silver, pyrite) |
| `splendent` | Very bright metallic (galena) |
| `vitreous` | Glass-like (quartz, beryl, topaz) |
| `adamantine` | Diamond-like brilliance (diamond, cerussite) |
| `resinous` | Resin-like (amber, sphalerite) |
| `waxy` | Wax-like (turquoise, jade) |
| `pearly` | Pearl-like on cleavage surfaces (calcite, muscovite) |
| `silky` | Silk-like from fine fibers (satin spar, tiger's eye) |
| `earthy` | Matte and dull (kaolin, limonite) |
| `greasy` | Oily-looking (nephrite, diamond rough) |
| `submetallic` | Weakly metallic (cuprite) |

---

## `transparency` Values

| Value | Description |
|-------|-------------|
| `transparent` | Objects clearly visible through mineral |
| `translucent` | Light passes but objects not visible |
| `opaque` | No light transmission |

> Multiple values allowed: `[transparent, translucent]` for minerals that occur in both forms.

---

## `fracture` Values

| Value | Description |
|-------|-------------|
| `conchoidal` | Shell-like curved surfaces (quartz, obsidian, glass) |
| `uneven` | Irregular rough surfaces |
| `hackly` | Jagged metal-like (native metals) |
| `stepped` | Step-like along cleavage/parting |
| `subconchoidal` | Weakly conchoidal |
| `irregular` | General irregular |

---

## `tenacity` Values (common descriptors)

| Value | Description |
|-------|-------------|
| `brittle` | Breaks with little deformation (most minerals) |
| `malleable` | Can be hammered into sheets (gold, copper) |
| `ductile` | Can be drawn into wire (gold, silver) |
| `sectile` | Can be cut with a knife like wax (talc, gypsum) |
| `flexible` | Bends and stays bent (talc, micas) |
| `elastic` | Bends and springs back (mica flakes) |
| `tough` | Resists breakage (nephrite, jadeite) |

---

## `cleavage` Descriptor Prefixes

| Value | Description |
|-------|-------------|
| `perfect` | Very smooth, planar surfaces (calcite, fluorite) |
| `distinct` / `good` | Clear cleavage (chrysoberyl, orthoclase) |
| `imperfect` / `poor` | Visible but imperfect (beryl, apatite) |
| `indistinct` | Barely visible (quartz) |
| `none` | No cleavage (quartz, garnet) |

---

## `genesis` / Formation Process Values

| Value | Description |
|-------|-------------|
| `hydrothermal` | Deposited from hot aqueous fluids in veins/cavities |
| `magmatic` | Crystallized from magma (igneous) |
| `pegmatitic` | Crystallized from volatile-rich late-stage magmatic fluids |
| `metamorphic` | Formed by solid-state recrystallization under heat/pressure |
| `sedimentary` | Deposited from sedimentary processes |
| `biogenic` | Formed by biological organisms |
| `secondary` / `supergene` | Formed by weathering/oxidation of primary minerals |
| `placer` | Concentrated in sedimentary placers by weathering/transport |
| `volcanic` | Associated with volcanic processes (not strictly magmatic) |
| `diagenetic` | Formed during burial/compaction of sediments |
| `evaporitic` | Precipitated from evaporating brines |
| `speleothem` | Cave formation (stalactites, stalagmites) |
| `organic` | From organic processes (amber, coal, jet) |

---

## `source_status` Values

| Value | Description |
|-------|-------------|
| `draft` | Initial entry; may have missing or unverified fields |
| `reviewed` | Human-reviewed for scientific accuracy |
| `verified` | Cross-referenced against primary mineralogical sources |

---

## Baseline Color Names (for `baseline_colors` and `color_profiles`)

**Neutrals:**
colorless, white, cream, off-white, gray, silver-gray, dark-gray, black

**Yellows/Golds:**
pale-yellow, lemon-yellow, golden-yellow, amber-yellow, honey-yellow, canary-yellow, golden-orange

**Oranges:**
orange, pale-orange, red-orange, amber-orange, peach, salmon, copper-orange

**Reds:**
pale-pink, rose-pink, pink, deep-pink, pinkish-red, red, deep-red, scarlet, vivid-red, raspberry-red, pigeon-blood-red, cherry-red

**Purples:**
lavender, pale-lavender, lilac, violet, purple, deep-purple, red-purple

**Blues:**
pale-blue, sky-blue, robin-egg-blue, cornflower-blue, royal-blue, deep-blue, navy, steel-blue, vivid-blue, azure-blue

**Blue-Greens:**
teal, blue-green, turquoise-blue, sea-blue, aqua, mint

**Greens:**
pale-green, apple-green, celadon, vivid-green, deep-green, emerald-green, forest-green, yellow-green, bluish-green

**Browns:**
pale-brown, tan, brown, reddish-brown, dark-brown, golden-brown, cognac, mahogany

**Metallics:**
golden-yellow (metallic), brassy-yellow, silver-white (metallic), copper-metallic

---

## Mood Keyword Examples (from existing entries)

Mood keywords should be unique, evocative, and specific to the mineral.
They should NOT be generic (avoid: "beautiful", "magical", "healing").
Format: lowercase-hyphenated.

**Examples from existing entries:**
- `pigeon-blood-fire` (ruby)
- `velvety-Kashmir-blue` (sapphire)
- `inca-rose-banded` (rhodochrosite)
- `volcanic-void` (obsidian)
- `fossilized-sunlight` (amber)
- `color-change-duality` (alexandrite)
- `dogtooth-cathedral` (calcite)
- `fool's-gold` (pyrite)
- `sky-condensed` (turquoise)
- `prismatic-fire` (opal)
- `jungle-opulence` (malachite)
- `titan-gold` (gold)

---

## Aesthetic Role Examples

Aesthetic roles describe how a mineral functions in design, UI, or creative contexts.

**Examples:**
- `luxury accent`
- `warm metallic anchor`
- `ancient opulence reference`
- `solar motif`
- `sky-color anchor`
- `cave-architecture element`
- `clarity and light reference`
- `banded-pattern ornamental`
- `color-change archetype`
- `apex gemstone`
- `pearlescent texture reference`
- `ancient-sacred material`
- `deceptive-beauty archetype`
- `metallic-geometric form`

---

## Tag Examples

Tags are flat, lowercase, hyphenated keywords for filtering and search.

**Chemistry class tags:**
`carbonate`, `silicate`, `oxide`, `sulfide`, `phosphate`, `sulfate`, `native-element`, `mineraloid`, `organic`, `halide`

**Species status tags:**
`variety`, `species`, `mineraloid`

**Crystal system tags:**
`trigonal`, `isometric`, `hexagonal`, `monoclinic`, `orthorhombic`, `triclinic`, `amorphous`

**Color tags:**
`red`, `blue`, `green`, `purple`, `yellow`, `orange`, `pink`, `black`, `white`, `colorless`, `multicolor`

**Property tags:**
`metallic`, `fluorescent`, `chatoyant`, `iridescent`, `asterism`, `color-change`, `play-of-color`

**Formation tags:**
`hydrothermal`, `pegmatite`, `sedimentary`, `metamorphic`, `volcanic`, `secondary`, `placer`

**Use/significance tags:**
`gemstone`, `birthstone`, `jewelry`, `industrial`, `sacred`, `ancient-trade`, `currency`, `pigment-history`

**Priority tags:**
`high-priority`, `tier-1`, `tier-2`

**Special feature tags:**
`banded`, `botryoidal`, `geode`, `inclusion-rich`, `massive`, `color-variety`, `tool-stone`

---

## Priority Score Guide

| Range | Tier | Meaning |
|-------|------|---------|
| 95–100 | S-Tier | Diamond, gold, emerald, ruby, sapphire — foundational gems |
| 90–94 | Tier 1 | Major gemstones and minerals: opal, turquoise, amethyst, calcite, pyrite |
| 80–89 | Tier 2 | Important gems/minerals: morganite, celestite, citrine, smithsonite |
| 70–79 | Tier 3 | Collector minerals and secondary gems |
| 50–69 | Tier 4 | Specialty or technical minerals |
| <50 | Tier 5 | Rare, obscure, or reference-only entries |
