# COPILOT FIRST PASS MINERALS

This file defines the **first major build pass** for the MINERALS repo.

The goal of this pass is to create a **broad, sturdy, high-value starter database** of mineral species and major named varieties that are:
- visually distinctive
- scientifically important
- culturally relevant
- useful for art / prompt / app systems
- diverse across chemistry classes, colors, habits, textures, and symbolic roles

This is **not** the full mineral kingdom.
This is the first large foundational sweep.

---

## FIRST PASS GOALS

Copilot should create:

1. folder structure
2. taxonomy files
3. schema/template files
4. one mineral file per listed mineral species
5. separate variety files for major named varieties where useful
6. indexes by color / chemistry / crystal system / habit / mood / locality / birthstone
7. basic validation-ready formatting
8. JSON export-ready consistency

---

## FOR EVERY MINERAL ENTRY, INCLUDE ALL OF THIS STUFF

Every mineral file should attempt to include the following sections.

If data is uncertain, do **not** make shit up.
Leave empty arrays, nulls, TODO notes, or lower confidence.

---

## REQUIRED SECTIONS PER MINERAL

### 1. Identity
- id
- slug
- display_name
- common aliases
- pronunciation if useful
- species / variety / mineraloid / group / trade name

### 2. Classification
- chemistry_class
- mineral_group
- parent_species if applicable
- related_varieties
- related_species
- polymorphs
- pseudomorph relationships

### 3. Identifiers
- IMA status
- Mindat ID if available
- other reference IDs if used

### 4. Chemical Profile
- ideal_formula
- simplified_formula
- essential_elements
- trace_elements_common
- oxidation-relevant notes if useful
- structural_units
- atomic_structure_notes
- chemistry_notes

### 5. Crystallography
- crystal_system
- crystal_class if available
- space_group if available
- unit_cell_notes if useful
- twinning
- crystallography_notes

### 6. Physical Properties
- Mohs hardness
- specific_gravity
- luster
- streak
- transparency
- cleavage
- fracture
- tenacity
- magnetism if relevant
- radioactivity if relevant
- solubility if relevant
- physical_notes

### 7. Appearance
- baseline_colors
- color_profiles
  - profile name
  - colors
  - cause
  - conditions
  - variety_name if applicable
- habits
- textures
- macro_patterns
- common_forms
- visual_notes

### 8. Optical / Special Effects
- fluorescence
- phosphorescence
- chatoyancy
- asterism
- iridescence
- aventurescence
- adularescence
- schiller
- pleochroism
- color_change if relevant
- optical_notes

### 9. Formation / Occurrence
- genesis
- geologic_environments
- host_rocks
- associated_minerals
- alteration_products
- weathering_relationships
- locality_scope
- notable_localities
- occurrence_notes

### 10. Cultural / Historical / Symbolic
- birthstone_status
- zodiac_associations
- historical_uses
- cultural_associations
- religious_associations
- trade_or_decorative_uses
- symbolism
- folklore_notes

### 11. Interpretive / Creative Metadata
- mood_keywords
- sensory_keywords
- palette_keywords
- aesthetic_roles
- visual_energy
- prompt_fragments
- app tags
- search boost terms
- UI color hints
- vibe_notes

### 12. Practical / Safety / Market
- toxicity
- handling_notes
- care_notes
- stability notes
- treatments_or_synthetics
- common_confusions
- common_fakes
- lapidary_notes
- specimen_notes
- market_notes
- ethical_sourcing_notes if available

### 13. Provenance
- source_status
- completeness
- confidence
- last_updated
- sources
- notes

---

## EXTRA FIELDS TO INCLUDE WHEN RELEVANT

These are optional but strongly encouraged when useful:

- fluorescence color under UV
- phosphorescent persistence
- thermochromism
- triboluminescence
- piezoelectric / pyroelectric behavior
- fibrous/asbestiform risk notes
- acid reaction
- cleavage danger in cutting
- common polished appearance
- cabochon behavior
- translucency zones
- inclusions commonly seen
- zoning behavior
- growth bands
- botryoidal layering
- druzy tendencies
- geode occurrence
- nodules / concretions
- replacement habits
- fossil replacement / petrification relevance
- specimen prep notes
- famous museum specimens
- historical pigment use
- industrial use
- ore-mineral relevance
- whether the “gem name” differs from mineral species name

---

## COLOR PROFILE RULES

Do **not** just say “green” or “purple” and call it a day.

For each mineral, create useful color profiles:
- actual color
- why that color happens
- under what conditions it appears
- whether it corresponds to a named variety
- whether it is common, uncommon, or rare

Examples:
- amethyst-purple from impurity/defect behavior
- smoky quartz from irradiation-related color centers
- malachite green from copper chemistry
- fluorite purple/green from impurities or defects
- corundum red = ruby, other colors = sapphire
- beryl emerald green vs aquamarine blue vs morganite pink

---

## HABIT / TEXTURE RULES

Track both:
1. crystal habit / growth form
2. macro visual texture / surface pattern language

Examples of habits:
- cubic
- octahedral
- prismatic
- tabular
- bladed
- fibrous
- acicular
- platy
- dendritic
- massive
- granular
- drusy
- reniform
- botryoidal
- mammillary
- stalactitic
- nodular

Examples of macro patterns:
- banded
- concentric
- radiating
- color-zoned
- brecciated
- orbicular
- eye-like
- plume-like
- mossy
- webbed
- included
- layered
- chatoyant
- fibrous-satin

---

## SOURCING RULES

Use real sources for factual claims.
Do not fabricate.

Good types of sources:
- Mindat
- Handbook of Mineralogy
- Webmineral
- museum collections
- university mineralogy sources
- gemological institutions for gem varieties
- reputable geology/mineral databases

For cultural/symbolic claims:
- use caution
- include only widely established or reasonably sourced claims
- do not just inhale crystal-shop nonsense and fart it into the repo as fact

Interpretive vibe tags are allowed to be creative, but they should still be useful.

---

## FIRST PASS MINERAL LIST

Build files for the following minerals in the first pass.

Organize them by chemistry class.

---

# NATIVE ELEMENTS

1. Gold
2. Silver
3. Copper
4. Sulfur
5. Graphite
6. Diamond

---

# SILICATES

## Quartz / silica family
7. Quartz
8. Chalcedony
9. Agate
10. Jasper
11. Amethyst
12. Citrine
13. Rose Quartz
14. Smoky Quartz
15. Aventurine Quartz
16. Tiger’s Eye
17. Petrified Wood

## Feldspars
18. Orthoclase
19. Microcline
20. Amazonite
21. Moonstone
22. Labradorite
23. Sunstone
24. Albite

## Garnets
25. Almandine
26. Pyrope
27. Spessartine
28. Grossular
29. Andradite
30. Uvarovite

## Beryl family
31. Beryl
32. Emerald
33. Aquamarine
34. Morganite
35. Heliodor

## Micas and sheet silicates
36. Muscovite
37. Biotite
38. Lepidolite
39. Phlogopite
40. Serpentine
41. Chrysotile
42. Talc
43. Kaolinite

## Pyroxenes / amphiboles / related
44. Jadeite
45. Nephrite
46. Rhodonite
47. Spodumene
48. Kunzite
49. Hiddenite
50. Diopside
51. Enstatite
52. Actinolite
53. Tremolite
54. Hornblende

## Other important silicates
55. Olivine
56. Peridot
57. Kyanite
58. Andalusite
59. Sillimanite
60. Topaz
61. Zircon
62. Tourmaline
63. Rubellite
64. Indicolite
65. Schorl
66. Prehnite
67. Epidote
68. Vesuvianite
69. Staurolite
70. Dumortierite
71. Hemimorphite
72. Smithsonite? NO, carbonate, do not place here
73. Chrysocolla
74. Larimar
75. Charoite

---

# OXIDES / HYDROXIDES

76. Corundum
77. Ruby
78. Sapphire
79. Hematite
80. Magnetite
81. Goethite
82. Limonite
83. Spinel
84. Chrysoberyl
85. Alexandrite
86. Rutile
87. Ilmenite
88. Cassiterite
89. Pyrolusite
90. Opal
91. Fire Opal
92. Hyalite

---

# CARBONATES

93. Calcite
94. Aragonite
95. Dolomite
96. Malachite
97. Azurite
98. Rhodochrosite
99. Smithsonite
100. Siderite

---

# HALIDES

101. Fluorite
102. Halite
103. Sylvite

---

# SULFIDES / SULFOSALTS

104. Pyrite
105. Marcasite
106. Galena
107. Sphalerite
108. Chalcopyrite
109. Bornite
110. Cinnabar
111. Realgar
112. Orpiment
113. Arsenopyrite
114. Stibnite

---

# SULFATES

115. Gypsum
116. Selenite
117. Desert Rose
118. Celestite
119. Barite
120. Anglesite

---

# PHOSPHATES / ARSENATES / VANADATES

121. Apatite
122. Turquoise
123. Variscite
124. Wavellite
125. Vivianite
126. Pyromorphite
127. Vanadinite

---

# BORATES

128. Ulexite

---

# ORGANIC / BIOMINERAL / MINERALOID-ADJACENT / SPECIAL CASES

129. Amber
130. Jet
131. Obsidian
132. Moldavite
133. Tektite
134. Shungite
135. Pearl
136. Ammolite

---

## NOTES ON THE LIST

Some entries are true mineral species.
Some are named gem/material varieties.
Some are mineraloids or special materials that are worth including because users will absolutely search for them.

That is intentional.

Mark `species_status` clearly as one of:
- species
- variety
- mineraloid
- rock/gem material
- trade name
- organic biomaterial

Do not pretend everything is a formal mineral species when it is not.

---

## PRIORITY TIERS

### Tier 1: must do first
These are the heavy hitters and should be done first if Copilot is chunking the work:

- Quartz
- Amethyst
- Citrine
- Rose Quartz
- Smoky Quartz
- Agate
- Jasper
- Calcite
- Fluorite
- Malachite
- Azurite
- Pyrite
- Hematite
- Corundum
- Ruby
- Sapphire
- Beryl
- Emerald
- Aquamarine
- Tourmaline
- Labradorite
- Moonstone
- Sunstone
- Obsidian
- Amber
- Turquoise
- Rhodochrosite
- Smithsonite
- Chrysocolla
- Opal
- Fire Opal
- Diamond
- Gold
- Silver
- Copper
- Jadeite
- Nephrite
- Tiger’s Eye
- Lepidolite
- Celestite

### Tier 2: next sweep
Do the rest of the major species and common collector stones.

### Tier 3: special weirdos
Do niche, hazardous, rare, locality-favorite, and collector-obsession entries after the foundation is stable.

---

## VARIETY FILE RULES

Create separate files for major named varieties when:
- the variety is commonly searched by name
- it has strong cultural recognition
- it has distinct color logic
- it is visually or symbolically important

At minimum, create separate variety files for:

- Amethyst
- Citrine
- Rose Quartz
- Smoky Quartz
- Aventurine Quartz
- Tiger’s Eye
- Amazonite
- Moonstone
- Labradorite
- Sunstone
- Emerald
- Aquamarine
- Morganite
- Heliodor
- Ruby
- Sapphire
- Alexandrite
- Peridot
- Kunzite
- Hiddenite
- Rubellite
- Indicolite
- Schorl
- Fire Opal
- Selenite
- Desert Rose
- Larimar

---

## INDEX FILES TO GENERATE

After creating mineral entries, Copilot should build or scaffold:

- indexes/minerals_by_color.yml
- indexes/minerals_by_chemistry.yml
- indexes/minerals_by_crystal_system.yml
- indexes/minerals_by_habit.yml
- indexes/minerals_by_mood.yml
- indexes/minerals_by_locality.yml
- indexes/minerals_by_birthstone.yml
- indexes/minerals_by_optical_effect.yml
- indexes/minerals_by_toxicity.yml
- indexes/minerals_by_species_status.yml

---

## TAXONOMY FILES TO CREATE OR EXPAND

Copilot should create or expand:

- taxonomies/chemistry_classes.yml
- taxonomies/crystal_systems.yml
- taxonomies/habits.yml
- taxonomies/lusters.yml
- taxonomies/fractures.yml
- taxonomies/cleavages.yml
- taxonomies/transparency.yml
- taxonomies/optical_effects.yml
- taxonomies/color_causes.yml
- taxonomies/mood_tags.yml
- taxonomies/cultural_tags.yml
- taxonomies/geologic_environments.yml
- taxonomies/species_status.yml
- taxonomies/toxicity_levels.yml

---

## QUALITY RULES

A good mineral file should feel like:
- geology reference
- visual dictionary
- texture library
- symbolism archive
- app-ready data object

A bad mineral file feels like:
- vague paragraph sludge
- unsourced trivia goo
- a crystal shop on too much ketamine
- a Wikipedia copy-paste corpse

---

## OUTPUT EXPECTATIONS

Copilot should:
- create the files cleanly
- use YAML consistently
- preserve field order where possible
- keep notes concise
- avoid giant prose blobs
- keep scientific claims conservative
- keep creative tags sharp and useful
- mark uncertain data honestly

---

## IF TIME / TOKEN / CONTEXT GETS TIGHT

Do not half-ass with invented facts.
Instead:
- complete Tier 1 first
- leave placeholders for later
- preserve schema consistency
- keep source fields present
- mark TODOs clearly

---

## FINAL DELIVERABLE FOR THIS PASS

By the end of first pass, the repo should have:
- core repo structure
- schema/template files
- taxonomy files
- starter indexes
- first-pass mineral files
- major variety files
- consistent metadata suitable for future export into apps

This repo should become a **mineral brain for weird software**:
science + aesthetics + symbolism + queryable structure + visual usefulness.
