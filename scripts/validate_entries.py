#!/usr/bin/env python3
"""
validate_entries.py
-------------------
Validates all mineral YAML entries in data/minerals/.

Checks:
- Required fields are present
- Controlled vocabulary values are valid
- Data types are correct
- Variety entries have parent_species set
- Mineraloid entries use crystal_system: amorphous

Usage:
    python scripts/validate_entries.py

Exits with code 1 if any errors found, 0 if all pass.
"""

import os
import sys
import yaml
from pathlib import Path

# ─── Path Setup ─────────────────────────────────────────────────────────────
REPO_ROOT = Path(__file__).parent.parent
MINERALS_DIR = REPO_ROOT / "data" / "minerals"

# ─── Controlled Vocabulary ───────────────────────────────────────────────────
VALID_CHEMISTRY_CLASSES = {
    "native-element", "sulfide", "oxide", "carbonate", "sulfate",
    "phosphate", "silicate", "halide", "mineraloid", "organic"
}

VALID_SPECIES_STATUS = {
    "species", "variety", "mineraloid", "rock/gem material", "trade name"
}

VALID_IMA_STATUS = {
    "approved", "grandfathered_approved", "not_ima", "n/a"
}

VALID_CRYSTAL_SYSTEMS = {
    "triclinic", "monoclinic", "orthorhombic", "tetragonal",
    "trigonal", "hexagonal", "isometric", "amorphous"
}

VALID_LUSTER = {
    "metallic", "splendent", "vitreous", "adamantine", "resinous",
    "waxy", "pearly", "silky", "earthy", "greasy", "submetallic"
}

VALID_TRANSPARENCY = {
    "transparent", "translucent", "opaque"
}

VALID_SOURCE_STATUS = {
    "draft", "reviewed", "verified"
}

# ─── Required Fields ─────────────────────────────────────────────────────────
REQUIRED_TOP_LEVEL = ["id", "slug", "display_name", "classification",
                       "identifiers", "chemical_profile", "crystallography",
                       "physical_properties", "appearance", "app_metadata",
                       "provenance"]

REQUIRED_CLASSIFICATION = ["chemistry_class", "species_status"]
REQUIRED_IDENTIFIERS = ["ima_status"]
REQUIRED_CHEMICAL = ["ideal_formula", "essential_elements"]
REQUIRED_CRYSTALLOGRAPHY = ["crystal_system"]
REQUIRED_PHYSICAL = ["mohs_hardness", "luster", "transparency"]
REQUIRED_APPEARANCE = ["baseline_colors"]
REQUIRED_APP_METADATA = ["tags", "priority_score"]
REQUIRED_PROVENANCE = ["source_status", "last_updated"]


def load_yaml_file(filepath):
    """Load a YAML file and return parsed data, or None on error."""
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            return yaml.safe_load(f)
    except yaml.YAMLError as e:
        return {"_yaml_error": str(e)}
    except Exception as e:
        return {"_file_error": str(e)}


def collect_mineral_files(minerals_dir):
    """Recursively collect all .yml files in data/minerals/."""
    files = []
    for root, dirs, filenames in os.walk(minerals_dir):
        for fname in sorted(filenames):
            if fname.endswith(".yml"):
                files.append(Path(root) / fname)
    return sorted(files)


def validate_entry(filepath, data):
    """Validate a single mineral entry. Returns list of error strings."""
    errors = []
    rel_path = filepath.relative_to(REPO_ROOT)
    prefix = f"[{rel_path}]"

    # Check for load errors
    if "_yaml_error" in data:
        errors.append(f"{prefix} YAML parse error: {data['_yaml_error']}")
        return errors
    if "_file_error" in data:
        errors.append(f"{prefix} File error: {data['_file_error']}")
        return errors

    # ── Required top-level fields ──────────────────────────────────────────
    for field in REQUIRED_TOP_LEVEL:
        if field not in data:
            errors.append(f"{prefix} Missing required top-level field: '{field}'")

    if not data:
        return errors

    # ── id / slug consistency ─────────────────────────────────────────────
    entry_id = data.get("id")
    slug = data.get("slug")
    if entry_id and slug and entry_id != slug:
        errors.append(f"{prefix} 'id' ({entry_id!r}) does not match 'slug' ({slug!r})")

    if entry_id and filepath.stem != entry_id:
        errors.append(f"{prefix} Filename '{filepath.stem}' does not match id '{entry_id}'")

    # ── classification block ──────────────────────────────────────────────
    classification = data.get("classification", {}) or {}
    for field in REQUIRED_CLASSIFICATION:
        if field not in classification:
            errors.append(f"{prefix} classification: missing field '{field}'")

    chem_class = classification.get("chemistry_class")
    if chem_class and chem_class not in VALID_CHEMISTRY_CLASSES:
        errors.append(f"{prefix} classification.chemistry_class: invalid value '{chem_class}'. "
                      f"Must be one of: {sorted(VALID_CHEMISTRY_CLASSES)}")

    species_status = classification.get("species_status")
    if species_status and species_status not in VALID_SPECIES_STATUS:
        errors.append(f"{prefix} classification.species_status: invalid value '{species_status}'. "
                      f"Must be one of: {sorted(VALID_SPECIES_STATUS)}")

    # Variety must have parent_species
    if species_status == "variety":
        parent = classification.get("parent_species")
        if not parent:
            errors.append(f"{prefix} classification.parent_species: required for variety "
                          f"entries (species_status='variety') but is null/missing")

    # ── identifiers block ─────────────────────────────────────────────────
    identifiers = data.get("identifiers", {}) or {}
    ima_status = identifiers.get("ima_status")
    if ima_status and ima_status not in VALID_IMA_STATUS:
        errors.append(f"{prefix} identifiers.ima_status: invalid value '{ima_status}'. "
                      f"Must be one of: {sorted(VALID_IMA_STATUS)}")

    # ── chemical_profile block ────────────────────────────────────────────
    chem_profile = data.get("chemical_profile", {}) or {}
    for field in REQUIRED_CHEMICAL:
        if field not in chem_profile or chem_profile[field] is None:
            errors.append(f"{prefix} chemical_profile: missing or null required field '{field}'")

    # ── crystallography block ─────────────────────────────────────────────
    crystallography = data.get("crystallography", {}) or {}
    crystal_system = crystallography.get("crystal_system")
    if crystal_system and crystal_system not in VALID_CRYSTAL_SYSTEMS:
        errors.append(f"{prefix} crystallography.crystal_system: invalid value '{crystal_system}'. "
                      f"Must be one of: {sorted(VALID_CRYSTAL_SYSTEMS)}")

    # Mineraloid / amorphous consistency
    if species_status == "mineraloid" and crystal_system and crystal_system != "amorphous":
        errors.append(f"{prefix} crystallography.crystal_system: mineraloid entries should use "
                      f"'amorphous' (got '{crystal_system}')")

    # ── physical_properties block ─────────────────────────────────────────
    physical = data.get("physical_properties", {}) or {}
    for field in REQUIRED_PHYSICAL:
        if field not in physical:
            errors.append(f"{prefix} physical_properties: missing required field '{field}'")

    luster_list = physical.get("luster", []) or []
    if not isinstance(luster_list, list):
        errors.append(f"{prefix} physical_properties.luster: must be a list")
    else:
        for luster_val in luster_list:
            if luster_val not in VALID_LUSTER:
                errors.append(f"{prefix} physical_properties.luster: invalid value '{luster_val}'. "
                               f"Must be one of: {sorted(VALID_LUSTER)}")

    transparency_list = physical.get("transparency", []) or []
    if not isinstance(transparency_list, list):
        errors.append(f"{prefix} physical_properties.transparency: must be a list")
    else:
        for trans_val in transparency_list:
            if trans_val not in VALID_TRANSPARENCY:
                errors.append(f"{prefix} physical_properties.transparency: invalid value '{trans_val}'. "
                               f"Must be one of: {sorted(VALID_TRANSPARENCY)}")

    # ── appearance block ──────────────────────────────────────────────────
    appearance = data.get("appearance", {}) or {}
    for field in REQUIRED_APPEARANCE:
        if field not in appearance or not appearance[field]:
            errors.append(f"{prefix} appearance: missing or empty required field '{field}'")

    # ── app_metadata block ────────────────────────────────────────────────
    app_meta = data.get("app_metadata", {}) or {}
    for field in REQUIRED_APP_METADATA:
        if field not in app_meta:
            errors.append(f"{prefix} app_metadata: missing required field '{field}'")

    priority = app_meta.get("priority_score")
    if priority is not None:
        if not isinstance(priority, (int, float)):
            errors.append(f"{prefix} app_metadata.priority_score: must be a number (got {type(priority).__name__})")
        elif not (0 <= priority <= 100):
            errors.append(f"{prefix} app_metadata.priority_score: must be 0–100 (got {priority})")

    # ── provenance block ──────────────────────────────────────────────────
    provenance = data.get("provenance", {}) or {}
    for field in REQUIRED_PROVENANCE:
        if field not in provenance or provenance[field] is None:
            errors.append(f"{prefix} provenance: missing or null required field '{field}'")

    source_status = provenance.get("source_status")
    if source_status and source_status not in VALID_SOURCE_STATUS:
        errors.append(f"{prefix} provenance.source_status: invalid value '{source_status}'. "
                      f"Must be one of: {sorted(VALID_SOURCE_STATUS)}")

    completeness = provenance.get("completeness")
    if completeness is not None:
        if not isinstance(completeness, (int, float)):
            errors.append(f"{prefix} provenance.completeness: must be a number (got {type(completeness).__name__})")
        elif not (0.0 <= completeness <= 1.0):
            errors.append(f"{prefix} provenance.completeness: must be 0.0–1.0 (got {completeness})")

    return errors


def main():
    """Main validation runner."""
    print(f"Mineral Entry Validator")
    print(f"Scanning: {MINERALS_DIR}")
    print("=" * 60)

    if not MINERALS_DIR.exists():
        print(f"ERROR: Minerals directory not found: {MINERALS_DIR}")
        sys.exit(1)

    files = collect_mineral_files(MINERALS_DIR)

    if not files:
        print("No .yml files found in data/minerals/")
        sys.exit(1)

    all_errors = []
    file_count = 0
    entry_ids = {}

    for filepath in files:
        data = load_yaml_file(filepath)
        errors = validate_entry(filepath, data)
        all_errors.extend(errors)
        file_count += 1

        # Check for duplicate ids
        if isinstance(data, dict) and "id" in data:
            entry_id = data["id"]
            if entry_id in entry_ids:
                all_errors.append(
                    f"[{filepath.relative_to(REPO_ROOT)}] "
                    f"Duplicate id '{entry_id}' — also in {entry_ids[entry_id]}"
                )
            else:
                entry_ids[entry_id] = str(filepath.relative_to(REPO_ROOT))

    # ── Report ──────────────────────────────────────────────────────────────
    print(f"\nFiles scanned: {file_count}")

    if all_errors:
        print(f"\nErrors found: {len(all_errors)}\n")
        for err in all_errors:
            print(f"  ✗ {err}")
        print(f"\n{'=' * 60}")
        print(f"VALIDATION FAILED — {len(all_errors)} error(s) found in {file_count} file(s)")
        sys.exit(1)
    else:
        print(f"\nAll {file_count} entries passed validation.")
        print("=" * 60)
        print("VALIDATION PASSED ✓")
        sys.exit(0)


if __name__ == "__main__":
    main()
