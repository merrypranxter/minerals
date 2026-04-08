# CONTRIBUTING GUIDE

Welcome to the minerals repository contributing guide.
This document explains how to add new mineral entries, maintain quality,
and keep the database consistent.

---

## Repository Structure Overview

```
minerals/
├── data/
│   └── minerals/
│       ├── carbonates/        # Carbonate minerals (calcite, malachite, etc.)
│       ├── halides/           # Halide minerals (fluorite, etc.)
│       ├── mineraloids/       # Non-crystalline mineral-like materials (opal, amber, obsidian)
│       ├── native-elements/   # Native element minerals (gold, diamond, etc.)
│       ├── oxides/            # Oxide minerals (corundum, chrysoberyl, etc.)
│       ├── phosphates/        # Phosphate minerals (turquoise, apatite, etc.)
│       ├── silicates/         # Silicate minerals (quartz, beryl, feldspar, etc.)
│       ├── sulfates/          # Sulfate minerals (celestite, gypsum, etc.)
│       └── sulfides/          # Sulfide minerals (pyrite, galena, etc.)
├── docs/
│   ├── DATA_MODEL.md          # Field-by-field schema reference
│   ├── CONTROLLED_VOCAB.md    # All controlled vocabulary tables
│   └── CONTRIBUTING.md        # This file
├── exports/                   # Auto-generated app payload exports
├── indexes/                   # Index YAML files (auto-generated + manual)
├── schemas/                   # Schema templates and validation rules
├── scripts/
│   ├── validate_entries.py    # Validates all YAML entries
│   ├── build_indexes.py       # Rebuilds all index files
│   └── export_app_payloads.py # Exports JSON payloads for app use
└── taxonomies/                # Taxonomy and vocabulary files
```

---

## How to Add a New Mineral Entry

### Step 1: Determine the correct chemistry class folder

Check `docs/CONTROLLED_VOCAB.md` → `chemistry_class` table.

- Silicates → `data/minerals/silicates/`
- Oxides → `data/minerals/oxides/`
- Carbonates → `data/minerals/carbonates/`
- Native elements → `data/minerals/native-elements/`
- Sulfides → `data/minerals/sulfides/`
- etc.

If the folder doesn't exist, create it.

### Step 2: Create the new YAML file

**File naming rules:**
- Lowercase only
- Hyphens instead of spaces
- No special characters
- Extension: `.yml`

Examples:
- `calcite.yml` → species
- `rose-quartz.yml` → variety
- `fire-opal.yml` → variety

### Step 3: Copy the schema template

Use `schemas/mineral_template.yml` as your starting point.

### Step 4: Fill in fields

Follow the field-by-field guide in `docs/DATA_MODEL.md`.

**Priority order for data completion:**
1. `id`, `slug`, `display_name` — required, fill first
2. `classification` block — required
3. `identifiers` — especially `mindat_id` (verify at mindat.org)
4. `chemical_profile` — formula and essential elements required; never invent
5. `crystallography` — crystal system required
6. `physical_properties` — mohs and SG at minimum
7. `appearance` — baseline colors and habits
8. `cultural_and_historical` — birthstone, symbolism, history
9. `interpretive_vibe` — mood, palette, aesthetic roles
10. `app_metadata` — tags, search terms, prompt fragments, priority_score

### Step 5: Verify scientific data

Check these sources for accuracy:
- **Mindat.org** — primary mineralogical database; get mindat_id here
- **GIA Gem Encyclopedia** — gem varieties
- **WebMineral** — formula and properties
- **RRUFF Project** — structure and spectroscopy

**NEVER INVENT:**
- Chemical formulas
- Crystal systems
- Mohs hardness values
- Specific gravity values
- Mindat IDs

If uncertain, use `null` or add a `# TODO: verify` comment.

### Step 6: Run validation

```bash
python scripts/validate_entries.py
```

Fix all errors before committing.

### Step 7: Update indexes

```bash
python scripts/build_indexes.py
```

Or manually add the new entry to the relevant index files in `indexes/`.

### Step 8: Commit

```bash
git add -A
git commit -m "Add <mineral-name> entry"
```

---

## Field-by-Field Checklist

Use this checklist when reviewing or creating an entry:

### Identity
- [ ] `id` is unique, lowercase, hyphenated
- [ ] `slug` matches `id`
- [ ] `display_name` is title case

### Classification
- [ ] `chemistry_class` uses controlled vocabulary value
- [ ] `species_status` uses controlled vocabulary value
- [ ] `parent_species` set correctly for varieties (to parent `id`)
- [ ] `parent_species: null` for species-level entries

### Identifiers
- [ ] `ima_status` uses controlled vocabulary value
- [ ] `mindat_id` verified at mindat.org (not invented)

### Chemical Profile
- [ ] `ideal_formula` is correct (verified, not invented)
- [ ] `essential_elements` lists correct chemical symbols
- [ ] No invented chemical data

### Crystallography
- [ ] `crystal_system` uses controlled vocabulary value
- [ ] Amorphous minerals (opal, obsidian, amber) use `crystal_system: amorphous`

### Physical Properties
- [ ] `mohs_hardness` is correct (number or quoted range string)
- [ ] `specific_gravity` is correct
- [ ] `luster` values from controlled vocabulary
- [ ] `transparency` values from controlled vocabulary

### Appearance
- [ ] `baseline_colors` populated
- [ ] At least one `color_profiles` entry
- [ ] `habits` list populated

### Cultural / Historical
- [ ] `birthstone_status` filled if applicable
- [ ] `historical_uses` has at least 2–3 entries for major minerals
- [ ] `symbolism` populated

### Interpretive Vibe
- [ ] `mood_keywords` are specific and unique (not generic)
- [ ] `prompt_fragments` are usable in AI prompts

### App Metadata
- [ ] `tags` include chemistry class, crystal system, key features
- [ ] `search_boost_terms` include alternative names and key identifiers
- [ ] `priority_score` set appropriately (see CONTROLLED_VOCAB.md)
- [ ] `ui_color_hint` has at least one hex color

### Provenance
- [ ] `source_status` set (`draft` for new entries)
- [ ] `completeness` estimated realistically
- [ ] `last_updated` is today's date in ISO format
- [ ] At least one source URL in `sources`

---

## Quality Standards

### Scientific accuracy (critical)
The minerals database is used by apps and tools. Incorrect scientific data
will propagate. When in doubt: use null, leave a TODO, or lower confidence.

**Rules:**
- Only use documented chemical formulas from authoritative mineralogical sources
- Crystal system must match IMA/mindat classification
- Hardness and SG values must be within published ranges
- Locality claims must be accurate (no invented localities)

### Controlled vocabulary compliance
Use only values from `docs/CONTROLLED_VOCAB.md` for:
- `chemistry_class`
- `species_status`
- `ima_status`
- `crystal_system`
- `luster` values
- `transparency` values
- `fracture` values
- `tenacity` values
- `source_status`

### Completeness targets
- New species entries: aim for `completeness: 0.80` minimum
- Variety entries: aim for `completeness: 0.75` minimum
- `priority_score >= 90` entries: aim for `completeness: 0.90`

### Variety entries
Variety entries (amethyst, ruby, emerald, etc.) must:
- Set `species_status: variety`
- Set `parent_species` to the correct species id
- Set `ima_status: not_ima` (varieties are not IMA species)
- Not duplicate scientific data already in the parent species file unnecessarily
  (but should be self-contained and usable without the parent)

### Mineraloid entries
Mineraloid entries (opal, obsidian, amber) must:
- Set `species_status: mineraloid`
- Set `crystal_system: amorphous`
- Set `ima_status: n/a` or `not_ima` as appropriate
- Explain why they are mineraloids in `chemistry_notes`

---

## How to Run Validation

```bash
# Validate all entries
python scripts/validate_entries.py

# Build all indexes
python scripts/build_indexes.py

# Export app payloads
python scripts/export_app_payloads.py
```

Requirements: Python 3.8+, PyYAML (`pip install pyyaml`)

The validation script will:
- Report missing required fields
- Report invalid controlled vocabulary values
- Report invalid data types
- Exit with code 1 if errors found

---

## Commit Conventions

Follow these commit message patterns:

```
Add <mineral-name> entry
```
For new single mineral entries.

```
Add <N> mineral entries: <comma-separated names>
```
For multiple new entries in one commit.

```
Update <mineral-name>: <what changed>
```
For updates to existing entries.

```
Rebuild indexes: <brief reason>
```
For index regeneration commits.

```
Fix <mineral-name>: correct <field-name>
```
For scientific or data corrections.

```
Docs: update <document-name>
```
For documentation changes.

```
Scripts: <what changed>
```
For script changes.

---

## File Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Mineral species | `<name>.yml` | `calcite.yml`, `pyrite.yml` |
| Mineral variety | `<variety-name>.yml` | `amethyst.yml`, `rose-quartz.yml` |
| Hyphenated variety | `<word1>-<word2>.yml` | `smoky-quartz.yml`, `fire-opal.yml` |
| Index files | `minerals_by_<criterion>.yml` | `minerals_by_color.yml` |
| Taxonomy files | `<taxonomy-name>.yml` | `chemistry_classes.yml` |

---

## What NOT to Include

Do NOT include in mineral entries:
- Crystal healing claims presented as fact
- Metaphysical claims without appropriate framing (folklore/symbolism sections are OK)
- Invented formulas or invented mineralogical data
- Wikipedia-prose style paragraphs in structured fields
- Copyright-protected content
- Personal opinions

The database is for **creative apps and educational tools** — it must be
scientifically grounded, culturally rich, and machine-readable.
Structure is more important than prose.

---

## Getting Help

- **Field definitions:** `docs/DATA_MODEL.md`
- **Vocabulary rules:** `docs/CONTROLLED_VOCAB.md`
- **Schema template:** `schemas/mineral_template.yml`
- **Existing examples:** Any file in `data/minerals/`
- **Validation errors:** Run `python scripts/validate_entries.py`
