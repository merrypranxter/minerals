# GitHub Copilot Instructions for the MINERALS Repo

You are building a structured mineral knowledge base for creative apps, visual systems, and scientific-aesthetic exploration.

Your job is NOT to dump random geology text.
Your job is to create a clean, scalable, app-friendly repository.

---

## Core Mission

For every mineral entry, combine:

1. **Verified scientific information**
2. **Structured visual metadata**
3. **Cultural / symbolic metadata**
4. **Interpretive vibe tags for creative software**

Keep these clearly separated.

---

## Non-Negotiable Rules

### 1. One mineral species per file
Create one YAML file per mineral species under:
- `data/minerals/<chemistry-class>/<slug>.yml`

### 2. Varieties can be separate files
Create separate variety files only when the variety has:
- a commonly used distinct name
- distinct color logic
- distinct cultural meaning
- distinct artistic usefulness

Examples:
- amethyst
- citrine
- rose-quartz
- smoky-quartz

### 3. Never mix hard facts and vibes without labeling them
Scientific fields go into scientific sections.
Interpretive or mood-based fields go into `interpretive_vibe`.

### 4. Never hallucinate sources
If a claim is factual, add a source.
If uncertain, either:
- leave it blank
- mark it TODO
- set lower confidence

Do not invent locality claims, cultural claims, or physical-property values.

### 5. Use controlled vocabulary
Prefer existing controlled terms from `taxonomies/` wherever possible.

### 6. Keep formatting consistent
Use the schema in `schemas/mineral-entry.template.yml`.

---

## Required Sections for Every Mineral Entry

Every mineral file should try to include:

- identity
- classification
- identifiers
- chemical profile
- crystallography
- physical properties
- appearance
- optical / special effects
- formation / occurrence
- cultural / historical
- interpretive vibe
- practical notes
- relationships
- app metadata
- provenance

---

## Field Behavior Rules

### Scientific fields
Must be conservative and sourced.

### Cultural fields
Only include if reasonably sourced or widely established.
If unclear, leave an empty list.

### Mood / vibe fields
These are allowed to be interpretive.
They should still be specific and useful.
Bad:
- pretty
- cool
- magical

Better:
- cathedral-green
- venom-luxury
- electric-lattice
- cave-milk softness
- regal poison
- solar amber fossil warmth

### Color fields
Do not just list colors.
For each color profile, try to explain:
- what colors occur
- what causes them
- under what conditions they appear
- whether the color corresponds to a named variety

### Habit / texture fields
Track both:
- crystallographic habit
- surface / macro texture language

Examples:
- cubic
- prismatic
- fibrous
- acicular
- botryoidal
- mammillary
- massive
- drusy
- banded
- stalactitic

---

## Repo Construction Plan

### Phase 1
Create the folder structure and core docs.

### Phase 2
Create:
- schema template
- controlled vocabulary files
- 10-25 starter mineral entries across major classes

### Phase 3
Create index files:
- by color
- by chemistry
- by habit
- by crystal system
- by mood
- by locality
- by birthstone

### Phase 4
Add variety files for important varieties.

### Phase 5
Generate JSON exports in `build/json/`.

---

## Quality Standard

A good mineral entry should feel like:
- a geology reference
- a visual design ingredient
- a symbolic object
- a queryable data record

A bad mineral entry feels like:
- a Wikipedia paste
- a vague paragraph blob
- unsourced crystal-healer nonsense
- generic filler adjectives

---

## What to do when information is incomplete

If information is missing:
- keep the field present
- use empty arrays, nulls, or TODO notes
- lower confidence if needed
- never fabricate

---

## Preferred Output Style

- YAML for source-of-truth records
- clean keys
- short notes
- searchable metadata
- future-friendly structure

Keep the repo modular, not monolithic.
