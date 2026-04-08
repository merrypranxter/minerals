# DATA MODEL: Mineral Entry Field Reference

This document describes every field in the mineral YAML entry schema.
Each field is explained with its purpose, valid values, and examples.

---

## Top-Level Identity Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Machine-readable unique identifier. Lowercase, hyphenated. Must be unique across all entries. Examples: `gold`, `rose-quartz`, `fire-opal` |
| `slug` | string | URL-safe slug. Usually identical to `id`. Lowercase, hyphenated. |
| `display_name` | string | Human-readable display name. Title case. Examples: `Gold`, `Rose Quartz`, `Fire Opal` |

---

## `classification` Block

Describes what the mineral is and how it fits into the taxonomy.

| Field | Type | Valid Values | Description |
|-------|------|--------------|-------------|
| `chemistry_class` | string | See controlled vocab | Primary chemistry classification. Examples: `silicate`, `oxide`, `carbonate`, `sulfide`, `phosphate`, `sulfate`, `native-element`, `mineraloid`, `organic`, `halide` |
| `mineral_group` | string | Free text | Named mineral group or series. Examples: `calcite-group`, `beryl-group`, `pyrite-group`. Use `null` if no named group. |
| `species_status` | string | See controlled vocab | What this entry represents. `species` = valid IMA species. `variety` = named variety/variety of a species. `mineraloid` = non-crystalline mineral-like material. `rock/gem material` = rock or multi-mineral gem. `trade name` = commercial trade name only. |
| `parent_species` | string or null | Valid mineral `id` | For varieties, the id of the parent species. Example: `quartz`, `corundum`, `beryl`. `null` for species-level entries. |
| `related_varieties` | list of strings | Valid variety names | Named varieties or related forms. May reference ids of variety files or variety names not yet in the database. |

---

## `identifiers` Block

External identifier links for cross-referencing.

| Field | Type | Valid Values | Description |
|-------|------|--------------|-------------|
| `ima_status` | string | See controlled vocab | IMA (International Mineralogical Association) status. `approved` = currently approved IMA species. `grandfathered_approved` = pre-IMA approval, now grandfathered. `not_ima` = variety, trade name, or informal name not formally approved. `n/a` = not applicable (mineraloid, organic). |
| `mindat_id` | integer | Valid mindat ID | Mindat.org numeric ID. Verify at mindat.org. Never invent. Leave as `null` if uncertain. |
| `other_ids` | object | Key-value pairs | Additional identifiers: `webmineral_id`, `rruff_id`, etc. Empty object `{}` if none. |

---

## `chemical_profile` Block

Chemical composition and structural information.

| Field | Type | Description |
|-------|------|-------------|
| `ideal_formula` | string | Standard chemical formula in quotes. Use crystallographic notation with subscripts where needed. Examples: `"Au"`, `"SiO2"`, `"Be3Al2Si6O18"`. NEVER invent formulas. |
| `simplified_formula` | string | Shorter or informal formula for display. Often identical to `ideal_formula`. |
| `essential_elements` | list of strings | Chemical symbols of elements required for the mineral. Examples: `[Fe, S]`, `[Si, O, H]` |
| `trace_elements_common` | list of strings | Common trace/impurity elements. Examples: `[Cr, Fe, Ti, V]` |
| `structural_units` | list of strings | Named structural building blocks. Examples: `"SiO4 tetrahedra in 3D framework"`, `"CO3 triangular planar groups"` |
| `atomic_structure_notes` | string | Description of crystal structure at atomic level. |
| `chemistry_notes` | string | Notes on color causes, solid solutions, impurities, chemical behavior. |

---

## `crystallography` Block

Crystal structure and form data.

| Field | Type | Valid Values | Description |
|-------|------|--------------|-------------|
| `crystal_system` | string | See controlled vocab | One of: `triclinic`, `monoclinic`, `orthorhombic`, `tetragonal`, `trigonal`, `hexagonal`, `isometric`, `amorphous` |
| `crystal_class` | string | Hermann-Mauguin notation | Point group / crystal class. Examples: `"hexoctahedral"`, `"3 2/m hexagonal scalenohedral"` |
| `space_group` | string | International space group | Examples: `"Fm3̄m"`, `"P6/mcc"`, `"R-3c"` |
| `unit_cell_notes` | string | | Unit cell parameters if known. Example: `"a ≈ 9.21 Å, c ≈ 9.19 Å; Z = 2"` |
| `twinning` | string | | Description of common twin types and laws. |
| `crystallography_notes` | string | | Habit descriptions, morphology notes, special features. |

---

## `physical_properties` Block

Measurable physical properties.

| Field | Type | Valid Values | Description |
|-------|------|--------------|-------------|
| `mohs_hardness` | number or string | 1–10, or range like `"7.5–8"` | Mohs hardness. Use integer for single values, quoted string for ranges. |
| `specific_gravity` | number or string | Decimal or range like `"2.63–2.80"` | Specific gravity (density relative to water). |
| `luster` | list of strings | See controlled vocab | Surface optical quality. Multiple allowed. Examples: `[metallic]`, `[vitreous, adamantine]`, `[silky, earthy]` |
| `streak` | string | Color name | Color of powdered mineral on streak plate. Example: `white`, `greenish-black`, `golden-yellow` |
| `transparency` | list of strings | See controlled vocab | Light transmission: `transparent`, `translucent`, `opaque`. Multiple allowed. |
| `cleavage` | list of strings | Descriptors + directions | Cleavage descriptions. Example: `["perfect rhombohedral {10-14}"]`, `[none]` |
| `fracture` | list of strings | See controlled vocab | Fracture type: `conchoidal`, `uneven`, `hackly`, `irregular`, `subconchoidal`, `stepped` |
| `tenacity` | string | | Tenacity descriptor. Examples: `brittle`, `malleable, ductile`, `sectile`, `flexible` |
| `physical_notes` | string | | Additional physical property notes. |

---

## `appearance` Block

Visual and morphological description.

| Field | Type | Description |
|-------|------|-------------|
| `baseline_colors` | list of strings | Primary color(s) of the mineral in typical specimens. Use descriptive color names from controlled vocab. |
| `color_profiles` | list of objects | Named color variants, each with: `name` (string), `colors` (list), `cause` (string), `conditions` (string), `variety_name` (string or null) |
| `habits` | list of strings | Crystal habits and aggregate forms. Examples: `prismatic`, `botryoidal`, `massive`, `dendritic`, `tabular` |
| `textures` | list of strings | Surface and bulk texture descriptors. Examples: `glassy`, `velvety`, `fibrous`, `concentric`, `sugary` |
| `macro_patterns` | list of strings | Recognizable visual patterns at hand-specimen scale. Examples: `banded`, `botryoidal domes`, `radiating` |
| `common_forms` | list of strings | Most commonly encountered specimen forms. Examples: `geode clusters`, `polished slabs`, `alluvial pebbles` |
| `visual_notes` | string | Narrative visual description notes. |

---

## `optical_and_special_effects` Block

Optical phenomena beyond basic color and luster.

| Field | Type | Description |
|-------|------|-------------|
| `fluorescence` | string | UV fluorescence behavior. Note: SW = shortwave UV, LW = longwave UV. Describe color and conditions. `none` if absent. |
| `phosphorescence` | string | Post-UV glow behavior. Leave empty string if absent. |
| `chatoyancy` | string | Cat's-eye effect description. Cause and conditions. Empty string if absent. |
| `asterism` | string | Star effect description. Number of rays, cause, conditions. Empty string if absent. |
| `iridescence` | string | Iridescence type and cause. Empty string if absent. |
| `pleochroism` | string | Pleochroism behavior: `none (isometric)`, or direction+color descriptions. |
| `optical_notes` | string | RI values, birefringence, optical sign, other notes. |

---

## `formation_and_occurrence` Block

Geological context.

| Field | Type | Description |
|-------|------|-------------|
| `genesis` | list of strings | Geological formation processes. Examples: `hydrothermal`, `sedimentary`, `metamorphic`, `magmatic`, `placer`, `secondary`, `volcanic`, `pegmatitic`, `biogenic` |
| `geologic_environments` | list of strings | Specific geological settings. Examples: `granitic pegmatites`, `oxidized copper deposits`, `alpine fissure veins` |
| `host_rocks` | list of strings | Common host rock types. Examples: `marble`, `limestone`, `granite`, `schist` |
| `associated_minerals` | list of strings | Minerals commonly found with this species. Use common names (ids). |
| `locality_scope` | string | Geographic distribution: `worldwide`, `uncommon`, `rare`, `widespread`, `deposit-linked`, etc. |
| `notable_localities` | list of strings | Important localities with location context. Format: `"Name, Region, Country (notes)"` |
| `occurrence_notes` | string | Narrative notes on geological occurrence. |

---

## `cultural_and_historical` Block

Human history and cultural context.

| Field | Type | Description |
|-------|------|-------------|
| `birthstone_status` | list of strings | Birthstone designations. Format: `"Month birthstone (tradition)"`. Example: `"April birthstone (modern and traditional)"` |
| `zodiac_associations` | list of strings | Zodiac sign associations. Example: `"Aries"`, `"Pisces (some traditions)"` |
| `historical_uses` | list of strings | Documented historical uses, chronologically if possible. |
| `cultural_associations` | list of strings | Cultural connections, myths, famous specimens, historical events. |
| `symbolism` | list of strings | Documented symbolic meanings. |
| `folklore_notes` | string | Narrative folklore and legend information. |

---

## `interpretive_vibe` Block

Creative / app-facing metadata for mood, palette, and aesthetic use.

| Field | Type | Description |
|-------|------|-------------|
| `mood_keywords` | list of strings | Creative mood descriptors. Unique to this mineral. Lowercase-hyphenated. Examples: `pigeon-blood-fire`, `cave-architecture`, `fool's-gold` |
| `sensory_keywords` | list of strings | Physical sensory descriptors. Examples: `heavy in the hand`, `warm gleam`, `razor edge` |
| `palette_keywords` | list of strings | Color palette descriptors for design use. Examples: `Baltic-gold`, `cornflower-blue`, `madeira-cognac-orange` |
| `aesthetic_roles` | list of strings | App/design roles this mineral can fill. Examples: `luxury accent`, `sky-color anchor`, `ancient-sacred material` |
| `vibe_notes` | string | Narrative creative/interpretive notes. Free prose. |

---

## `practical_notes` Block

Safety, market, and care information.

| Field | Type | Description |
|-------|------|-------------|
| `toxicity` | string | Toxicity and safety information. Describe conditions of concern. `Non-toxic.` for safe materials. |
| `handling_notes` | string | Physical handling precautions. |
| `care_notes` | string | Cleaning and storage advice. |
| `treatments_or_synthetics` | list of strings | Known treatments, enhancements, and synthetic versions. |
| `common_confusions` | list of strings | Minerals/materials frequently confused with this one. Include distinguishing notes. |
| `market_notes` | string | Market value, availability, pricing context. |

---

## `relationships` Block

Mineralogical relationships to other species.

| Field | Type | Description |
|-------|------|-------------|
| `polymorphs` | list of strings | Same composition, different structure. Examples: `[aragonite, vaterite]` for calcite. |
| `pseudomorphs_after` | list of strings | Minerals this species replaces pseudomorphically. |
| `pseudomorphed_by` | list of strings | Minerals that replace this species pseudomorphically. |
| `lookalikes` | list of strings | Visually similar minerals (lookalikes/confusions). Use mineral ids. |
| `related_species` | list of strings | Chemically or structurally related species. |

---

## `app_metadata` Block

Search, indexing, and app-specific metadata.

| Field | Type | Description |
|-------|------|-------------|
| `tags` | list of strings | Flat tag list for search and filtering. Lowercase, hyphenated. See controlled vocab for examples. |
| `search_boost_terms` | list of strings | Alternative names, chemical symbols, trade names, famous specimens — boost search recall. |
| `prompt_fragments` | list of strings | 2–4 sentence fragments for use in AI prompts, image generation, or creative descriptions. |
| `ui_color_hint` | list of strings | Hex color codes or named colors representing the mineral for UI/palette use. Examples: `["#FFD700", "#C8960C"]` |
| `priority_score` | integer | 0–100. Importance in the database: 90+ = Tier 1 (must-have gem/major mineral), 80–89 = Tier 2, 70–79 = Tier 3. |

---

## `provenance` Block

Data quality and sourcing metadata.

| Field | Type | Valid Values | Description |
|-------|------|--------------|-------------|
| `source_status` | string | See controlled vocab | `draft` = initial entry, may have gaps. `reviewed` = human-reviewed for accuracy. `verified` = cross-referenced against primary sources. |
| `completeness` | float | 0.0–1.0 | Estimated data completeness. 0.9+ = nearly complete. 0.7–0.89 = good. <0.7 = significant gaps. |
| `confidence` | string | `high`, `medium`, `low` | Overall confidence in data accuracy. |
| `last_updated` | string | ISO date `"YYYY-MM-DD"` | Date of last significant update. |
| `sources` | list of strings | URLs or citation strings | Sources used. Prefer mindat.org, GIA, peer-reviewed. |
| `notes` | string | | Internal notes about this entry — caveats, TODOs, data gaps. |

---

## Color Profile Sub-Object Schema

Each item in `color_profiles` has:

```yaml
- name: "Profile Name"           # Human-readable name for this color variant
  colors: [list-of-color-names]  # Color keywords (see controlled vocab)
  cause: "..."                   # Scientific explanation of color origin
  conditions: "..."              # Geological/mineralogical conditions for this color
  variety_name: null or string   # Named variety (if this color has a variety name)
```

---

## Notes on Data Integrity

- **Never invent** chemical formulas, crystal systems, mindat IDs, or specific gravity values
- **Verify** mindat IDs by checking mindat.org before adding
- **Use `null`** for unknown values; use empty strings `""` or empty arrays `[]` for absent data
- **Variety entries** must reference their parent species via `parent_species`
- **Mineraloids** (opal, amber, obsidian) use `crystal_system: amorphous` and `ima_status: n/a` or `not_ima`
- **Color causes** must be scientifically accurate (chromophore, impurity, structural color, etc.)
