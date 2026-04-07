# MINERALS REPO STRUCTURE

This repo is a structured mineral knowledge base for creative apps, visual systems, prompt engines, shader tools, educational toys, and weird beautiful data experiments.

The goal is not just "facts about rocks."
The goal is:
- scientific mineral data
- visual descriptions
- color variation logic
- crystal habit / structure logic
- cultural and symbolic associations
- mood / vibe tags
- locality and formation data
- app-friendly indexing

---

## Folder Tree

minerals/
├─ README.md
├─ REPO_STRUCTURE.md
├─ .github/
│  └─ copilot-instructions.md
├─ docs/
│  ├─ DATA_MODEL.md
│  ├─ CONTROLLED_VOCAB.md
│  └─ CONTRIBUTING.md
├─ schemas/
│  ├─ mineral-entry.template.yml
│  └─ mineral.schema.json
├─ taxonomies/
│  ├─ chemistry_classes.yml
│  ├─ crystal_systems.yml
│  ├─ habits.yml
│  ├─ lusters.yml
│  ├─ fractures.yml
│  ├─ cleavages.yml
│  ├─ transparency.yml
│  ├─ optical_effects.yml
│  ├─ color_causes.yml
│  ├─ mood_tags.yml
│  ├─ cultural_tags.yml
│  └─ geologic_environments.yml
├─ data/
│  ├─ minerals/
│  │  ├─ silicates/
│  │  │  └─ quartz.yml
│  │  ├─ carbonates/
│  │  │  └─ malachite.yml
│  │  └─ halides/
│  │     └─ fluorite.yml
│  ├─ varieties/
│  │  └─ quartz/
│  │     ├─ amethyst.yml
│  │     ├─ citrine.yml
│  │     ├─ smoky-quartz.yml
│  │     └─ rose-quartz.yml
│  ├─ localities/
│  │  ├─ countries.yml
│  │  └─ famous_localities.yml
│  └─ cultural/
│     ├─ birthstones.yml
│     ├─ zodiac_associations.yml
│     ├─ historical_uses.yml
│     └─ mythic_associations.yml
├─ indexes/
│  ├─ aliases.yml
│  ├─ minerals_by_color.yml
│  ├─ minerals_by_chemistry.yml
│  ├─ minerals_by_crystal_system.yml
│  ├─ minerals_by_habit.yml
│  ├─ minerals_by_mood.yml
│  ├─ minerals_by_locality.yml
│  └─ minerals_by_birthstone.yml
├─ build/
│  ├─ json/
│  └─ ndjson/
├─ scripts/
│  ├─ validate_entries.py
│  ├─ build_indexes.py
│  └─ export_app_payloads.py
└─ assets/
   ├─ images/
   └─ palettes/

---

## Design Rules

### 1. One mineral species = one file
Examples:
- quartz.yml
- malachite.yml
- fluorite.yml

### 2. Varieties get separate files only when useful
Use separate variety files when:
- color logic is distinct
- cultural meaning is distinct
- artistic/aesthetic use differs
- the variety is commonly searched by name

Examples:
- amethyst
- rose quartz
- smoky quartz
- tiger’s eye
- chrysoprase

### 3. Keep canonical data and vibe data together but clearly separated
Each entry should include both:
- hard data (formula, crystal system, locality, habit, etc.)
- interpretive data (mood tags, palette tags, aesthetic roles, symbolism)

### 4. Use controlled vocab where possible
Do not freestyle 900 different spellings of the same thing.
Prefer controlled terms for:
- crystal systems
- habits
- luster
- cleavage
- fracture
- optical effects
- formation environment

### 5. Sources must be stored in every entry
Even if the entry also contains interpretive fields, the science fields need traceable sources.

---

## Why this structure works

This structure lets the repo function as:
- a scientific mineral reference
- a visual design library
- a prompt-engine ingredient repo
- a searchable app database
- a thing that scales without turning into spaghetti
