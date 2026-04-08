#!/usr/bin/env python3
"""
export_app_payloads.py
----------------------
Reads all YAML files in data/minerals/ and exports JSON payloads in 5 formats
for app consumption.

Export formats:
  - full:    Complete data for each mineral
  - card:    id, display_name, chemistry_class, colors, mohs, luster, tags
  - prompt:  id, display_name, prompt_fragments, mood_keywords, palette_keywords
  - palette: id, display_name, ui_color_hint, baseline_colors, color_profiles
  - search:  id, display_name, tags, search_boost_terms, chemistry_class

Each format is exported as:
  exports/<format>/<mineral-id>.json      (individual files)
  exports/<format>/all_<format>.json      (combined file — all minerals)

Usage:
    python scripts/export_app_payloads.py [--format FORMAT]

Options:
    --format FORMAT   Only export this format (full, card, prompt, palette, search)
                      Omit to export all formats.

Requires: pyyaml
"""

import argparse
import json
import os
import sys
import yaml
from pathlib import Path

# ─── Path Setup ─────────────────────────────────────────────────────────────
REPO_ROOT = Path(__file__).parent.parent
MINERALS_DIR = REPO_ROOT / "data" / "minerals"
EXPORTS_DIR = REPO_ROOT / "exports"

VALID_FORMATS = {"full", "card", "prompt", "palette", "search"}


def load_yaml(filepath):
    """Load YAML file. Returns dict or None on error."""
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            return yaml.safe_load(f)
    except Exception as e:
        print(f"  Warning: Could not load {filepath}: {e}")
        return None


def collect_minerals(minerals_dir):
    """Load all mineral YAML files. Returns list of data dicts."""
    minerals = []
    for root, dirs, files in os.walk(minerals_dir):
        for fname in sorted(files):
            if fname.endswith(".yml"):
                fp = Path(root) / fname
                data = load_yaml(fp)
                if data and "id" in data:
                    minerals.append(data)
    return sorted(minerals, key=lambda x: x.get("id", ""))


# ─── Payload Builders ────────────────────────────────────────────────────────

def build_full(data):
    """Full payload — complete mineral data as-is (JSON-converted)."""
    return dict(data)


def build_card(data):
    """Card payload — summary suitable for mineral cards/tiles."""
    classification = data.get("classification", {}) or {}
    physical = data.get("physical_properties", {}) or {}
    appearance = data.get("appearance", {}) or {}
    cultural = data.get("cultural_and_historical", {}) or {}
    app_meta = data.get("app_metadata", {}) or {}
    identifiers = data.get("identifiers", {}) or {}
    chem = data.get("chemical_profile", {}) or {}

    # Collect color profiles names
    color_profiles = []
    for cp in appearance.get("color_profiles", []) or []:
        if isinstance(cp, dict) and cp.get("name"):
            color_profiles.append(cp["name"])

    return {
        "id": data.get("id"),
        "slug": data.get("slug"),
        "display_name": data.get("display_name"),
        "chemistry_class": classification.get("chemistry_class"),
        "species_status": classification.get("species_status"),
        "parent_species": classification.get("parent_species"),
        "mineral_group": classification.get("mineral_group"),
        "ima_status": identifiers.get("ima_status"),
        "formula": chem.get("simplified_formula") or chem.get("ideal_formula"),
        "mohs_hardness": physical.get("mohs_hardness"),
        "specific_gravity": physical.get("specific_gravity"),
        "luster": physical.get("luster", []),
        "streak": physical.get("streak"),
        "transparency": physical.get("transparency", []),
        "crystal_system": (data.get("crystallography", {}) or {}).get("crystal_system"),
        "baseline_colors": appearance.get("baseline_colors", []),
        "color_profiles_available": color_profiles,
        "habits": (appearance.get("habits", []) or [])[:5],  # top 5
        "birthstone_months": cultural.get("birthstone_status", []),
        "tags": app_meta.get("tags", []),
        "priority_score": app_meta.get("priority_score"),
        "ui_color_hint": app_meta.get("ui_color_hint", []),
    }


def build_prompt(data):
    """Prompt payload — for AI prompts and generative content."""
    vibe = data.get("interpretive_vibe", {}) or {}
    app_meta = data.get("app_metadata", {}) or {}
    cultural = data.get("cultural_and_historical", {}) or {}
    appearance = data.get("appearance", {}) or {}
    classification = data.get("classification", {}) or {}

    return {
        "id": data.get("id"),
        "display_name": data.get("display_name"),
        "chemistry_class": classification.get("chemistry_class"),
        "species_status": classification.get("species_status"),
        "parent_species": classification.get("parent_species"),
        "baseline_colors": appearance.get("baseline_colors", []),
        "visual_notes": appearance.get("visual_notes", ""),
        "prompt_fragments": app_meta.get("prompt_fragments", []),
        "mood_keywords": vibe.get("mood_keywords", []),
        "sensory_keywords": vibe.get("sensory_keywords", []),
        "palette_keywords": vibe.get("palette_keywords", []),
        "aesthetic_roles": vibe.get("aesthetic_roles", []),
        "vibe_notes": vibe.get("vibe_notes", ""),
        "symbolism": cultural.get("symbolism", []),
        "folklore_summary": (cultural.get("folklore_notes", "") or "")[:300],
    }


def build_palette(data):
    """Palette payload — for color/design systems."""
    appearance = data.get("appearance", {}) or {}
    app_meta = data.get("app_metadata", {}) or {}
    classification = data.get("classification", {}) or {}

    # Build clean color profiles
    color_profiles = []
    for cp in appearance.get("color_profiles", []) or []:
        if isinstance(cp, dict):
            color_profiles.append({
                "name": cp.get("name"),
                "colors": cp.get("colors", []),
                "variety_name": cp.get("variety_name"),
                "cause": cp.get("cause", ""),
            })

    return {
        "id": data.get("id"),
        "display_name": data.get("display_name"),
        "chemistry_class": classification.get("chemistry_class"),
        "species_status": classification.get("species_status"),
        "ui_color_hint": app_meta.get("ui_color_hint", []),
        "baseline_colors": appearance.get("baseline_colors", []),
        "color_profiles": color_profiles,
        "habits": appearance.get("habits", []),
        "textures": appearance.get("textures", []),
        "luster": (data.get("physical_properties", {}) or {}).get("luster", []),
        "visual_notes": appearance.get("visual_notes", ""),
        "optical_effects": {
            "fluorescence": (data.get("optical_and_special_effects", {}) or {}).get("fluorescence", ""),
            "iridescence": (data.get("optical_and_special_effects", {}) or {}).get("iridescence", ""),
            "play_of_color": (data.get("optical_and_special_effects", {}) or {}).get("iridescence", ""),
            "chatoyancy": (data.get("optical_and_special_effects", {}) or {}).get("chatoyancy", ""),
            "asterism": (data.get("optical_and_special_effects", {}) or {}).get("asterism", ""),
        },
    }


def build_search(data):
    """Search payload — for full-text and faceted search systems."""
    classification = data.get("classification", {}) or {}
    physical = data.get("physical_properties", {}) or {}
    appearance = data.get("appearance", {}) or {}
    cultural = data.get("cultural_and_historical", {}) or {}
    app_meta = data.get("app_metadata", {}) or {}
    identifiers = data.get("identifiers", {}) or {}
    chem = data.get("chemical_profile", {}) or {}
    crystal = data.get("crystallography", {}) or {}
    formation = data.get("formation_and_occurrence", {}) or {}
    vibe = data.get("interpretive_vibe", {}) or {}

    # Build all_text — one big string for full-text search
    all_text_parts = [
        data.get("display_name", ""),
        data.get("id", ""),
        chem.get("ideal_formula", "") or "",
        chem.get("chemistry_notes", "") or "",
        appearance.get("visual_notes", "") or "",
        cultural.get("folklore_notes", "") or "",
        " ".join(cultural.get("symbolism", []) or []),
        " ".join(cultural.get("historical_uses", []) or []),
        " ".join(app_meta.get("search_boost_terms", []) or []),
        " ".join(app_meta.get("tags", []) or []),
        " ".join(vibe.get("mood_keywords", []) or []),
        " ".join(appearance.get("baseline_colors", []) or []),
    ]
    all_text = " ".join(p for p in all_text_parts if p)

    return {
        "id": data.get("id"),
        "slug": data.get("slug"),
        "display_name": data.get("display_name"),
        "chemistry_class": classification.get("chemistry_class"),
        "species_status": classification.get("species_status"),
        "parent_species": classification.get("parent_species"),
        "mineral_group": classification.get("mineral_group"),
        "ima_status": identifiers.get("ima_status"),
        "formula": chem.get("ideal_formula"),
        "essential_elements": chem.get("essential_elements", []),
        "crystal_system": crystal.get("crystal_system"),
        "mohs_hardness": physical.get("mohs_hardness"),
        "luster": physical.get("luster", []),
        "transparency": physical.get("transparency", []),
        "baseline_colors": appearance.get("baseline_colors", []),
        "genesis": formation.get("genesis", []),
        "birthstone_status": cultural.get("birthstone_status", []),
        "tags": app_meta.get("tags", []),
        "search_boost_terms": app_meta.get("search_boost_terms", []),
        "priority_score": app_meta.get("priority_score"),
        "mood_keywords": vibe.get("mood_keywords", []),
        "_all_text": all_text,
    }


PAYLOAD_BUILDERS = {
    "full": build_full,
    "card": build_card,
    "prompt": build_prompt,
    "palette": build_palette,
    "search": build_search,
}


def export_format(minerals, format_name, exports_dir):
    """Export all minerals in a single format."""
    format_dir = exports_dir / format_name
    format_dir.mkdir(parents=True, exist_ok=True)

    builder = PAYLOAD_BUILDERS[format_name]
    all_payloads = []
    count = 0

    for data in minerals:
        entry_id = data.get("id")
        if not entry_id:
            continue
        try:
            payload = builder(data)
            # Individual file
            out_file = format_dir / f"{entry_id}.json"
            with open(out_file, "w", encoding="utf-8") as f:
                json.dump(payload, f, ensure_ascii=False, indent=2, default=str)
            all_payloads.append(payload)
            count += 1
        except Exception as e:
            print(f"  Warning: Failed to build {format_name} payload for {entry_id}: {e}")

    # Combined file
    combined_file = format_dir / f"all_{format_name}.json"
    with open(combined_file, "w", encoding="utf-8") as f:
        json.dump({
            "format": format_name,
            "count": len(all_payloads),
            "minerals": all_payloads
        }, f, ensure_ascii=False, indent=2, default=str)

    print(f"  {format_name:10s}: {count} individual files + all_{format_name}.json → {format_dir.relative_to(REPO_ROOT)}/")
    return count


def main():
    parser = argparse.ArgumentParser(description="Export mineral app payloads")
    parser.add_argument("--format", choices=list(VALID_FORMATS),
                        help="Only export this format (default: all)")
    args = parser.parse_args()

    print("Mineral App Payload Exporter")
    print(f"Scanning: {MINERALS_DIR}")
    print("=" * 60)

    if not MINERALS_DIR.exists():
        print(f"ERROR: Minerals directory not found: {MINERALS_DIR}")
        sys.exit(1)

    EXPORTS_DIR.mkdir(parents=True, exist_ok=True)
    minerals = collect_minerals(MINERALS_DIR)
    print(f"Loaded {len(minerals)} mineral entries\n")

    formats_to_export = [args.format] if args.format else list(VALID_FORMATS)

    print("Exporting payloads...")
    total = 0
    for fmt in sorted(formats_to_export):
        count = export_format(minerals, fmt, EXPORTS_DIR)
        total += count

    print(f"\n{'=' * 60}")
    print(f"Export complete: {total} payloads across {len(formats_to_export)} format(s) ✓")
    print(f"Output directory: {EXPORTS_DIR.relative_to(REPO_ROOT)}/")


if __name__ == "__main__":
    main()
