#!/usr/bin/env python3
"""
build_indexes.py
----------------
Reads all YAML files in data/minerals/ and rebuilds all 10 index files
in indexes/.

Index files generated:
  - minerals_master.yml
  - minerals_by_chemistry.yml
  - minerals_by_color.yml
  - minerals_by_crystal_system.yml
  - minerals_by_birthstone.yml
  - minerals_by_mood.yml
  - minerals_by_species_status.yml
  - minerals_by_genesis.yml
  - minerals_by_priority.yml
  - aliases.yml (extended from existing; adds new entries)

Usage:
    python scripts/build_indexes.py

Requires: pyyaml
"""

import os
import sys
import yaml
from pathlib import Path
from collections import defaultdict

# ─── Path Setup ─────────────────────────────────────────────────────────────
REPO_ROOT = Path(__file__).parent.parent
MINERALS_DIR = REPO_ROOT / "data" / "minerals"
INDEXES_DIR = REPO_ROOT / "indexes"

# ─── Color → color keywords mapping ─────────────────────────────────────────
# Maps canonical color buckets to color keywords found in baseline_colors / color_profiles
COLOR_BUCKET_KEYWORDS = {
    "red":       {"red", "deep-red", "vivid-red", "pinkish-red", "scarlet", "raspberry-red",
                  "pigeon-blood-red", "cherry-red", "red-orange", "burnt-red"},
    "orange":    {"orange", "red-orange", "amber-orange", "peach", "salmon", "copper-orange",
                  "orange-pink", "golden-orange", "pale-orange"},
    "yellow":    {"yellow", "pale-yellow", "lemon-yellow", "golden-yellow", "amber-yellow",
                  "honey-yellow", "canary-yellow", "brassy-yellow", "metallic-yellow"},
    "green":     {"green", "pale-green", "apple-green", "vivid-green", "deep-green",
                  "emerald-green", "forest-green", "yellow-green", "bluish-green", "celadon",
                  "olive-green", "blue-green", "teal", "teal-green", "teal-blue", "sea-green"},
    "blue":      {"blue", "pale-blue", "sky-blue", "robin-egg-blue", "cornflower-blue",
                  "royal-blue", "deep-blue", "navy", "azure-blue", "vivid-blue", "ice-blue",
                  "cerulean", "sea-blue", "steel-blue", "blue-green"},
    "purple":    {"purple", "violet", "lavender", "deep-purple", "pale-lavender", "lilac",
                  "red-purple", "periwinkle"},
    "pink":      {"pink", "pale-pink", "rose-pink", "deep-pink", "hot-pink", "baby-pink",
                  "dusty-rose", "salmon", "peach", "morganite-rose"},
    "white":     {"white", "colorless", "cream", "off-white", "ivory"},
    "gray":      {"gray", "silver-gray", "dark-gray", "smoky-gray", "brown-gray"},
    "brown":     {"brown", "pale-brown", "tan", "reddish-brown", "dark-brown", "golden-brown",
                  "cognac", "mahogany", "honey", "amber"},
    "black":     {"black", "jet-black", "near-black", "dark-brown"},
    "colorless": {"colorless", "water-clear", "transparent"},
    "multicolor": {"multicolor", "iridescent", "spectral"},
    "metallic":  {"brassy-yellow", "metallic-yellow", "golden-yellow", "metallic-gold-yellow",
                  "bronze-yellow"},
}


def load_yaml(filepath):
    """Load YAML file. Returns dict or None on error."""
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            return yaml.safe_load(f)
    except Exception:
        return None


def collect_minerals(minerals_dir):
    """Load all mineral YAML files. Returns list of (filepath, data) tuples."""
    minerals = []
    for root, dirs, files in os.walk(minerals_dir):
        for fname in sorted(files):
            if fname.endswith(".yml"):
                fp = Path(root) / fname
                data = load_yaml(fp)
                if data and "id" in data:
                    rel = fp.relative_to(minerals_dir.parent.parent)
                    minerals.append((str(rel), data))
    return sorted(minerals, key=lambda x: x[1].get("id", ""))


def get_colors(data):
    """Extract all color keywords from a mineral entry."""
    colors = set()
    appearance = data.get("appearance", {}) or {}
    for c in appearance.get("baseline_colors", []) or []:
        colors.add(str(c).lower().replace(" ", "-"))
    for cp in appearance.get("color_profiles", []) or []:
        if isinstance(cp, dict):
            for c in cp.get("colors", []) or []:
                colors.add(str(c).lower().replace(" ", "-"))
    return colors


def get_color_buckets(data):
    """Map a mineral's colors to canonical color buckets."""
    colors = get_colors(data)
    buckets = set()
    for bucket, keywords in COLOR_BUCKET_KEYWORDS.items():
        if colors & keywords:
            buckets.add(bucket)
    return buckets


def format_yaml_block(obj, indent=0):
    """Custom YAML formatting helper for clean output."""
    return yaml.dump(obj, allow_unicode=True, default_flow_style=False,
                     sort_keys=False, indent=2)


def write_yaml_with_header(filepath, header_comment, data_dict):
    """Write a YAML index file with a header comment."""
    with open(filepath, "w", encoding="utf-8") as f:
        for line in header_comment.strip().splitlines():
            f.write(f"# {line}\n")
        f.write("\n")
        yaml.dump(data_dict, f, allow_unicode=True, default_flow_style=False,
                  sort_keys=False, indent=2)
    print(f"  Written: {filepath.relative_to(REPO_ROOT)}")


def build_master_index(minerals, indexes_dir):
    """Build minerals_master.yml."""
    # Group by chemistry class
    by_class = defaultdict(list)
    for rel_path, data in minerals:
        chem_class = (data.get("classification") or {}).get("chemistry_class", "unknown")
        by_class[chem_class].append((rel_path, data))

    class_order = [
        "silicate", "oxide", "carbonate", "phosphate", "sulfate",
        "sulfide", "native-element", "halide", "mineraloid", "organic", "unknown"
    ]

    lines = []
    lines.append("# Mineral Master Index\n"
                 "# Lists all mineral entries in the database with key metadata for quick lookup.\n"
                 "# Auto-generated by scripts/build_indexes.py\n"
                 "\nminerals:\n")

    for cls in class_order:
        if cls not in by_class:
            continue
        lines.append(f"\n  # ─── {cls.upper()} {'─' * (50 - len(cls))}\n")
        for rel_path, data in sorted(by_class[cls], key=lambda x: x[1].get("display_name", "")):
            entry_id = data.get("id", "")
            display_name = data.get("display_name", "")
            classification = data.get("classification", {}) or {}
            species_status = classification.get("species_status", "")
            parent_species = classification.get("parent_species")
            app_meta = data.get("app_metadata", {}) or {}
            priority = app_meta.get("priority_score")

            lines.append(f"  - id: {entry_id}\n")
            lines.append(f"    display_name: {display_name}\n")
            lines.append(f"    chemistry_class: {cls}\n")
            lines.append(f"    species_status: {species_status}\n")
            if parent_species:
                lines.append(f"    parent_species: {parent_species}\n")
            else:
                lines.append(f"    parent_species: null\n")
            lines.append(f"    file: {rel_path}\n")
            if priority is not None:
                lines.append(f"    priority_score: {priority}\n")
            else:
                lines.append(f"    priority_score: null\n")

    outpath = indexes_dir / "minerals_master.yml"
    with open(outpath, "w", encoding="utf-8") as f:
        f.writelines(lines)
    print(f"  Written: {outpath.relative_to(REPO_ROOT)}")


def build_chemistry_index(minerals, indexes_dir):
    """Build minerals_by_chemistry.yml."""
    by_class = defaultdict(list)
    for _, data in minerals:
        chem_class = (data.get("classification") or {}).get("chemistry_class", "unknown")
        by_class[chem_class].append(data.get("id"))

    class_order = [
        "silicate", "oxide", "carbonate", "phosphate", "sulfate",
        "sulfide", "native-element", "halide", "mineraloid", "organic", "unknown"
    ]

    result = {}
    for cls in class_order:
        if cls in by_class:
            result[cls] = sorted([x for x in by_class[cls] if x])

    write_yaml_with_header(
        indexes_dir / "minerals_by_chemistry.yml",
        "Minerals by Chemistry Class\nIndex organizing all mineral entries by their chemistry_class.\n"
        "Auto-generated by scripts/build_indexes.py",
        result
    )


def build_color_index(minerals, indexes_dir):
    """Build minerals_by_color.yml."""
    by_color = defaultdict(list)
    for _, data in minerals:
        entry_id = data.get("id")
        if not entry_id:
            continue
        buckets = get_color_buckets(data)
        for bucket in buckets:
            by_color[bucket].append(entry_id)

    color_order = ["red", "orange", "yellow", "green", "blue", "purple", "pink",
                   "white", "gray", "brown", "black", "colorless", "multicolor", "metallic"]

    result = {}
    for color in color_order:
        if color in by_color:
            result[color] = sorted(set(by_color[color]))

    write_yaml_with_header(
        indexes_dir / "minerals_by_color.yml",
        "Minerals by Color\nIndex mapping color categories to minerals displaying that color.\n"
        "A mineral may appear under multiple color headings.\n"
        "Auto-generated by scripts/build_indexes.py",
        result
    )


def build_crystal_system_index(minerals, indexes_dir):
    """Build minerals_by_crystal_system.yml."""
    by_system = defaultdict(list)
    for _, data in minerals:
        entry_id = data.get("id")
        if not entry_id:
            continue
        crystal_system = ((data.get("crystallography") or {})
                          .get("crystal_system", "unknown"))
        by_system[crystal_system].append(entry_id)

    system_order = ["isometric", "hexagonal", "trigonal", "tetragonal",
                    "orthorhombic", "monoclinic", "triclinic", "amorphous", "unknown"]

    result = {}
    for system in system_order:
        if system in by_system:
            result[system] = sorted(set(by_system[system]))

    write_yaml_with_header(
        indexes_dir / "minerals_by_crystal_system.yml",
        "Minerals by Crystal System\nAuto-generated by scripts/build_indexes.py",
        result
    )


def build_birthstone_index(minerals, indexes_dir):
    """Build minerals_by_birthstone.yml."""
    month_names = [
        "january", "february", "march", "april", "may", "june",
        "july", "august", "september", "october", "november", "december"
    ]

    month_traditional = {
        "january": ["garnet"],
        "february": ["amethyst"],
        "march": ["bloodstone", "aquamarine"],
        "april": ["diamond"],
        "may": ["emerald"],
        "june": ["pearl", "moonstone"],
        "july": ["ruby"],
        "august": ["sardonyx", "peridot"],
        "september": ["sapphire"],
        "october": ["opal", "tourmaline"],
        "november": ["topaz", "citrine"],
        "december": ["turquoise", "zircon"],
    }

    month_modern = {
        "january": ["garnet"],
        "february": ["amethyst"],
        "march": ["aquamarine"],
        "april": ["diamond"],
        "may": ["emerald"],
        "june": ["pearl", "moonstone", "alexandrite"],
        "july": ["ruby"],
        "august": ["peridot", "spinel"],
        "september": ["sapphire"],
        "october": ["opal", "tourmaline"],
        "november": ["topaz", "citrine"],
        "december": ["tanzanite", "zircon", "turquoise"],
    }

    # Build month → minerals_in_db mapping
    month_minerals = defaultdict(list)
    for _, data in minerals:
        entry_id = data.get("id")
        if not entry_id:
            continue
        cultural = data.get("cultural_and_historical", {}) or {}
        birthstone_list = cultural.get("birthstone_status", []) or []
        for bs in birthstone_list:
            bs_lower = str(bs).lower()
            for month in month_names:
                if month in bs_lower:
                    month_minerals[month].append(entry_id)

    result = {}
    for month in month_names:
        result[month] = {
            "traditional": month_traditional.get(month, []),
            "modern": month_modern.get(month, []),
            "minerals_in_db": sorted(set(month_minerals.get(month, [])))
        }

    write_yaml_with_header(
        indexes_dir / "minerals_by_birthstone.yml",
        "Minerals by Birthstone\nIndex mapping birthstone months to minerals in this database.\n"
        "Auto-generated by scripts/build_indexes.py",
        result
    )


def build_mood_index(minerals, indexes_dir):
    """Build minerals_by_mood.yml."""
    by_mood = defaultdict(list)
    for _, data in minerals:
        entry_id = data.get("id")
        if not entry_id:
            continue
        vibe = data.get("interpretive_vibe", {}) or {}
        for mood in vibe.get("mood_keywords", []) or []:
            by_mood[str(mood)].append(entry_id)

    result = {k: sorted(set(v)) for k, v in sorted(by_mood.items())}

    write_yaml_with_header(
        indexes_dir / "minerals_by_mood.yml",
        "Minerals by Mood Tag\nIndex mapping creative/interpretive mood keywords to minerals.\n"
        "These tags are from the interpretive_vibe.mood_keywords fields.\n"
        "Auto-generated by scripts/build_indexes.py",
        result
    )


def build_species_status_index(minerals, indexes_dir):
    """Build minerals_by_species_status.yml."""
    by_status = defaultdict(list)
    for _, data in minerals:
        entry_id = data.get("id")
        if not entry_id:
            continue
        status = (data.get("classification") or {}).get("species_status", "unknown")
        by_status[status].append(entry_id)

    status_order = ["species", "variety", "mineraloid", "rock/gem material", "trade name", "unknown"]

    result = {}
    for status in status_order:
        if status in by_status:
            result[status] = sorted(set(by_status[status]))

    write_yaml_with_header(
        indexes_dir / "minerals_by_species_status.yml",
        "Minerals by Species Status\n"
        "Index organizing entries by species_status (species, variety, mineraloid, etc.)\n"
        "Auto-generated by scripts/build_indexes.py",
        result
    )


def build_genesis_index(minerals, indexes_dir):
    """Build minerals_by_genesis.yml."""
    by_genesis = defaultdict(list)
    for _, data in minerals:
        entry_id = data.get("id")
        if not entry_id:
            continue
        formation = data.get("formation_and_occurrence", {}) or {}
        for genesis in formation.get("genesis", []) or []:
            by_genesis[str(genesis)].append(entry_id)

    result = {k: sorted(set(v)) for k, v in sorted(by_genesis.items())}

    write_yaml_with_header(
        indexes_dir / "minerals_by_genesis.yml",
        "Minerals by Formation Genesis\nIndex mapping formation process types to minerals.\n"
        "Auto-generated by scripts/build_indexes.py",
        result
    )


def build_priority_index(minerals, indexes_dir):
    """Build minerals_by_priority.yml."""
    tier_s = []
    tier_1 = []
    tier_2 = []
    tier_3 = []
    tier_4 = []
    unscored = []

    for _, data in minerals:
        entry_id = data.get("id")
        if not entry_id:
            continue
        app_meta = data.get("app_metadata", {}) or {}
        priority = app_meta.get("priority_score")

        if priority is None:
            unscored.append(entry_id)
        elif priority >= 95:
            tier_s.append((entry_id, priority))
        elif priority >= 90:
            tier_1.append((entry_id, priority))
        elif priority >= 80:
            tier_2.append((entry_id, priority))
        elif priority >= 70:
            tier_3.append((entry_id, priority))
        else:
            tier_4.append((entry_id, priority))

    def sort_tier(lst):
        return [x[0] for x in sorted(lst, key=lambda x: -x[1])]

    result = {
        "tier_s_95_100": sort_tier(tier_s),
        "tier_1_90_94": sort_tier(tier_1),
        "tier_2_80_89": sort_tier(tier_2),
        "tier_3_70_79": sort_tier(tier_3),
        "tier_4_below_70": sort_tier(tier_4),
        "unscored": sorted(unscored),
    }

    write_yaml_with_header(
        indexes_dir / "minerals_by_priority.yml",
        "Minerals by Priority Score\n"
        "Tier S (95-100): Foundational gems and minerals\n"
        "Tier 1 (90-94): Major gemstones and important minerals\n"
        "Tier 2 (80-89): Important gems and collector minerals\n"
        "Tier 3 (70-79): Specialty minerals\n"
        "Auto-generated by scripts/build_indexes.py",
        result
    )


def build_aliases_index(minerals, indexes_dir):
    """Build/update aliases.yml with new entries."""
    # Load existing aliases to preserve hand-written content
    existing_path = indexes_dir / "aliases.yml"
    existing_aliases = {}
    if existing_path.exists():
        try:
            with open(existing_path, "r", encoding="utf-8") as f:
                content = yaml.safe_load(f)
                if isinstance(content, dict) and "aliases" in content:
                    existing_aliases = content["aliases"] or {}
        except Exception:
            pass

    # Collect all ids and display names from current entries
    new_aliases = dict(existing_aliases)
    for _, data in minerals:
        entry_id = data.get("id")
        if not entry_id:
            continue
        display_name = data.get("display_name", "")
        # Add display name (lowercase) → id if different from id
        if display_name and display_name.lower() != entry_id:
            dn_lower = display_name.lower()
            if dn_lower not in new_aliases:
                new_aliases[dn_lower] = entry_id
        # Add search boost terms as aliases
        app_meta = data.get("app_metadata", {}) or {}
        for term in app_meta.get("search_boost_terms", []) or []:
            term_lower = str(term).lower()
            if term_lower not in new_aliases and term_lower != entry_id:
                # Only add single-word or clearly mineral-name boost terms
                # (skip long phrases)
                if len(term_lower.split()) <= 3:
                    new_aliases[term_lower] = entry_id

    write_yaml_with_header(
        indexes_dir / "aliases.yml",
        "Mineral Aliases Index\n"
        "Maps common names, trade names, variety names, and search terms\n"
        "to their canonical mineral IDs in this database.\n"
        "Auto-generated by scripts/build_indexes.py — hand edits preserved on update.",
        {"aliases": new_aliases}
    )


def main():
    print("Index Builder")
    print(f"Scanning: {MINERALS_DIR}")
    print("=" * 60)

    if not MINERALS_DIR.exists():
        print(f"ERROR: Minerals directory not found: {MINERALS_DIR}")
        sys.exit(1)

    INDEXES_DIR.mkdir(parents=True, exist_ok=True)

    minerals = collect_minerals(MINERALS_DIR)
    print(f"Loaded {len(minerals)} mineral entries\n")

    print("Building indexes...")
    build_master_index(minerals, INDEXES_DIR)
    build_chemistry_index(minerals, INDEXES_DIR)
    build_color_index(minerals, INDEXES_DIR)
    build_crystal_system_index(minerals, INDEXES_DIR)
    build_birthstone_index(minerals, INDEXES_DIR)
    build_mood_index(minerals, INDEXES_DIR)
    build_species_status_index(minerals, INDEXES_DIR)
    build_genesis_index(minerals, INDEXES_DIR)
    build_priority_index(minerals, INDEXES_DIR)
    build_aliases_index(minerals, INDEXES_DIR)

    print(f"\n{'=' * 60}")
    print("All indexes built successfully ✓")


if __name__ == "__main__":
    main()
