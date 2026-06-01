#!/usr/bin/env python3
"""
add_github_app.py — Unified Master Utility for Flutter Knowledge Base
Accepts a GitHub repository URL or a local folder path, clones if needed,
extracts full app metadata (packages, screens, tags, domain, app type),
and registers/updates the root index.json automatically.
"""

import sys
import re
import json
import datetime
import subprocess
from pathlib import Path

# Base knowledge base path (calculated from script location)
KB_ROOT = Path(__file__).resolve().parent
APPS_DIR = KB_ROOT / "apps"
DEFAULT_BUILD = {"status": "partial", "fixer_attempts": 0}

STANDARD_PACKAGES = {
    "flutter",
    "flutter_test",
    "cupertino_icons",
    "flutter_localizations",
    "meta",
    "integration_test",
}

def parse_pubspec(pubspec_path):
    """
    Parses pubspec.yaml using a pure-Python line parser to avoid third-party yaml dependencies.
    Extracts name, description, and direct third-party packages.
    """
    if not pubspec_path.exists():
        return "", "", []
        
    try:
        content = pubspec_path.read_text(encoding="utf-8", errors="ignore")
    except Exception as e:
        print(f"Warning: Failed to read pubspec.yaml at {pubspec_path}: {e}")
        return "", "", []
        
    # Extract root keys using regex
    name_match = re.search(r'^name:\s*(.+)$', content, re.MULTILINE)
    desc_match = re.search(r'^description:\s*(.+)$', content, re.MULTILINE)
    
    name = name_match.group(1).strip().strip("'\"") if name_match else ""
    description = desc_match.group(1).strip().strip("'\"") if desc_match else ""
    
    # Pure Python indented parsing for dependencies block
    lines = content.splitlines()
    dependencies = []
    in_dependencies = False
    dependencies_indent = None
    
    for line in lines:
        stripped = line.strip()
        if not stripped or stripped.startswith('#'):
            continue
            
        # Look for dependencies block start
        if re.match(r'^dependencies\s*:', line):
            in_dependencies = True
            continue
            
        if in_dependencies:
            # Match package declarations (e.g., "  flutter_svg: ^2.0.10" or "  intl: any")
            match = re.match(r'^(\s+)(\w+)\s*:', line)
            if match:
                indent = len(match.group(1))
                if dependencies_indent is None:
                    dependencies_indent = indent
                
                # We only want top-level keys under dependencies
                if indent == dependencies_indent:
                    pkg_name = match.group(2).strip()
                    dependencies.append(pkg_name)
            else:
                # If we hit another root block (indentation level 0) or block with less indentation than the dependencies
                root_match = re.match(r'^(\w+)\s*:', line)
                if root_match:
                    in_dependencies = False
                    
    packages = [pkg for pkg in dependencies if pkg not in STANDARD_PACKAGES]
    return name, description, packages

def detect_screens(lib_dir):
    """
    Recursively scans the lib/ directory for widgets ending with Page/Screen/View/etc.,
    derives clean labels, and infers screen types based on nomenclature.
    """
    screens = []
    if not lib_dir.exists():
        return screens
        
    # Regex to capture Widget declarations subclassing StatefulWidget or StatelessWidget
    class_re = re.compile(r'\bclass\s+(\w+)\s+extends\s+(StatelessWidget|StatefulWidget)\b')
    
    # UI helper names to exclude (we want full screens, not sub-widgets)
    exclude_keywords = [
        "button", "card", "tile", "dialog", "popup", "menu", "action", "widget",
        "controller", "model", "state", "indicator", "icon", "alert", "result",
        "wrapper", "clipper", "decoration", "builder", "painter", "cell", "item",
        "tabbar", "navbar", "appbar", "theme", "provider", "util", "helper", "row"
    ]
    
    screen_suffixes = ["screen", "page", "view", "home", "dashboard", "login", "register", "tab", "panel", "console"]
    
    for dart_file in lib_dir.rglob("*.dart"):
        try:
            content = dart_file.read_text(encoding="utf-8", errors="ignore")
        except Exception:
            continue
            
        for match in class_re.finditer(content):
            class_name = match.group(1)
            lower_name = class_name.lower()
            
            is_screen = False
            
            # Rule 1: Filename suggests a screen component
            filename = dart_file.name.lower()
            if filename.endswith("_screen.dart") or filename.endswith("_page.dart") or filename.endswith("_view.dart"):
                if not any(ex in lower_name for ex in exclude_keywords):
                    is_screen = True
                    
            # Rule 2: Class ends with a screen suffix and excludes sub-widgets
            if any(lower_name.endswith(sfx) for sfx in screen_suffixes):
                if not any(ex in lower_name for ex in exclude_keywords if ex not in ["view", "tab", "console"]):
                    is_screen = True
                    
            # Rule 3: File is located inside a screens/pages/views directory
            parent_parts = [part.lower() for part in dart_file.parts]
            if any(part in parent_parts for part in ["screens", "pages", "views"]):
                if not any(ex in lower_name for ex in exclude_keywords):
                    is_screen = True
                    
            if is_screen:
                # 1. Kebab-case ID
                screen_id = re.sub(r'(?<!^)(?=[A-Z])', '-', class_name).lower()
                
                # 2. Clean human-readable Title Name (strips standard suffixes)
                clean_name = re.sub(r'(?<!^)(?=[A-Z])', ' ', class_name)
                for suffix in ["Screen", "Page", "View"]:
                    if clean_name.endswith(" " + suffix):
                        clean_name = clean_name[:-len(" " + suffix)]
                    elif clean_name.endswith(suffix):
                        clean_name = clean_name[:-len(suffix)]
                clean_name = clean_name.strip()
                
                # 3. Classify screen type
                screen_type = "general"
                lower_clean = clean_name.lower()
                
                if any(k in lower_clean for k in ["login", "register", "signup", "signin", "auth", "otp", "password"]):
                    screen_type = "auth"
                elif any(k in lower_clean for k in ["list", "search", "catalog", "grid", "browse", "explorer", "scroller"]):
                    screen_type = "list"
                elif any(k in lower_clean for k in ["detail", "profile", "info", "display"]):
                    screen_type = "detail"
                elif any(k in lower_clean for k in ["dashboard", "home", "main", "overview", "panel"]):
                    screen_type = "dashboard"
                elif any(k in lower_clean for k in ["form", "booking", "order", "input", "add", "edit", "create", "write", "settings", "config"]):
                    screen_type = "form"
                elif any(k in lower_clean for k in ["onboarding", "intro", "welcome", "splash", "tutorial"]):
                    screen_type = "onboarding"
                    
                if not any(s["id"] == screen_id for s in screens):
                    screens.append({
                        "id": screen_id,
                        "name": clean_name,
                        "screen_type": screen_type
                    })
                    
    return screens

def classify_domain_and_type(app_id, description, tags, packages):
    """
    Classifies the domain and app type based on combined text content and dependency analysis.
    """
    desc_lower = description.lower()
    id_lower = app_id.lower()
    
    tokens = set()
    for word in re.findall(r'\b\w+\b', desc_lower + " " + id_lower):
        tokens.add(word)
    for tag in tags:
        tokens.add(tag.lower())
    for pkg in packages:
        tokens.add(pkg.lower())
        
    domain_mapping = {
        "media": ["book", "reader", "movie", "stream", "play", "video", "music", "audio", "podcast", "media", "youtube", "tv"],
        "ecommerce": ["shop", "cart", "pay", "order", "store", "buy", "sell", "checkout", "shopping", "market", "delivery"],
        "fitness": ["fit", "health", "workout", "gym", "run", "track", "diet", "nutrition", "cardio", "exercise"],
        "travel": ["hotel", "flight", "travel", "booking", "trip", "map", "route", "gps", "tourism", "vacation"],
        "education": ["learn", "course", "educat", "school", "study", "exam", "quiz", "class", "lecture", "student"],
        "social": ["social", "chat", "profile", "friend", "post", "share", "message", "twitter", "instagram", "facebook"],
        "finance": ["bank", "finance", "money", "wallet", "expense", "transac", "bill", "payment", "card", "crypto"],
        "productivity": ["todo", "task", "note", "calendar", "schedule", "timer", "clock", "remind", "organizer"]
    }
    
    domain = "generic"
    for dom, keywords in domain_mapping.items():
        if any(keyword in tokens or any(keyword in token for token in tokens) for keyword in keywords):
            domain = dom
            break
            
    app_type_mapping = {
        "media": "reader" if ("reader" in tokens or "book" in tokens) else "streaming",
        "ecommerce": "marketplace",
        "fitness": "tracker",
        "travel": "booking",
        "education": "reader",
        "social": "portal" if "profile" in tokens else "chat",
        "finance": "dashboard",
        "productivity": "utility"
    }
    
    app_type = app_type_mapping.get(domain, "utility")
    
    # Specific overrides
    if "browser" in tokens:
        domain = "utility"
        app_type = "utility"
        
    return domain, app_type

def generate_tags(app_id, description, packages, screens):
    """
    Extracts descriptive keywords and aggregates them to form meaningful tag lists.
    """
    tags = set(["nocode-flutter", "local", "app"])
    
    package_tags = {
        "flutter_svg": "svg",
        "cached_network_image": "image",
        "simple_animations": "animation",
        "animations": "animation",
        "flutter_screenutil": "screenutil",
        "flutter_staggered_grid_view": "staggered-grid",
        "provider": "state-management",
        "sqflite": "database",
        "sqlite3_flutter_libs": "sqlite",
        "flutter_inappwebview": "webview",
        "flutter_colorpicker": "colorpicker",
        "intl": "localization",
        "uuid": "utility",
        "dynamic_color": "material-you",
        "flutter_downloader": "downloader",
        "share_plus": "sharing"
    }
    
    for pkg, tag in package_tags.items():
        if pkg in packages:
            tags.add(tag)
            
    keywords = ["login", "auth", "register", "chat", "shopping", "hotel", "movie", "book", "grid", "staggered", "search", "downloader", "share", "theme", "dark-mode", "browser"]
    combined = (app_id + " " + description).lower()
    for kw in keywords:
        if kw in combined:
            tags.add(kw)
            
    screen_types = [s["screen_type"] for s in screens]
    if "auth" in screen_types:
        tags.add("auth")
    if "list" in screen_types:
        tags.add("list")
    if "dashboard" in screen_types:
        tags.add("dashboard")
        
    return sorted(list(tags))

def get_git_repo(project_dir):
    """
    Detects repository origin URL or fallback.
    """
    try:
        res = subprocess.run(["git", "config", "--get", "remote.origin.url"], cwd=str(project_dir), capture_output=True, text=True, check=True)
        url = res.stdout.strip()
        if url:
            return url
    except Exception:
        pass
    return "local-repo"

def merge_metadata(existing, new_data):
    """
    Incremental merging of existing metadata and fresh scan data.
    Ensures manual entries (screens, descriptions, domains) are preserved.
    """
    merged = existing.copy()
    
    # Overwrite if missing or empty
    for key in ["schema", "type", "id", "name", "description", "domain", "app_type", "source_repo", "built_at", "platform", "app", "architecture"]:
        if not merged.get(key):
            merged[key] = new_data.get(key)
            
    # Handle screens
    if not merged.get("screens"):
        merged["screens"] = new_data.get("screens", [])
    else:
        # Keep existing screens
        pass
        
    # Handle packages (always update with the latest dependency list)
    merged["packages"] = new_data.get("packages", [])
    
    # Handle tags (union set to preserve manual + new tags)
    existing_tags = set(merged.get("tags", []))
    new_tags = set(new_data.get("tags", []))
    merged["tags"] = sorted(list(existing_tags.union(new_tags)))
    
    if "build" not in merged:
        merged["build"] = new_data.get("build", DEFAULT_BUILD)
        
    return merged

def update_index_json(app_id, name, domain, relative_path):
    """
    Registers the newly generated app to the root index.json automatically.
    """
    index_path = KB_ROOT / "index.json"
    if not index_path.exists():
        print("Warning: index.json not found. Skipping registration.")
        return
        
    try:
        data = json.loads(index_path.read_text(encoding="utf-8"))
    except Exception as e:
        print(f"Error parsing index.json: {e}")
        return
        
    entries = data.get("entries", [])
    new_entry = {
        "id": app_id,
        "type": "app",
        "path": str(relative_path).replace("\\", "/"),
        "name": name,
        "domain": domain
    }
    
    # Check if duplicate exists
    replaced = False
    for idx, item in enumerate(entries):
        if item.get("id") == app_id and item.get("type") == "app":
            entries[idx] = new_entry
            replaced = True
            break
            
    if not replaced:
        entries.append(new_entry)
        
    data["entries"] = entries
    
    try:
        index_path.write_text(json.dumps(data, indent=2), encoding="utf-8")
        print(f"Successfully registered entry for '{app_id}' in index.json")
    except Exception as e:
        print(f"Error writing index.json: {e}")

def process_project(project_dir, source_repo_url=None, update_index=True):
    """
    Processes a single Flutter project directory:
    Scans files, compiles metadata, merges safely, writes JSON, updates root index.
    """
    project_dir = Path(project_dir).resolve()
    if not project_dir.exists():
        print(f"Error: Directory does not exist: {project_dir}")
        return False
        
    pubspec_path = project_dir / "pubspec.yaml"
    if not pubspec_path.exists():
        print(f"Error: No pubspec.yaml found in {project_dir}. Is this a Flutter project?")
        return False
        
    app_id = project_dir.name
    print(f"\nScanning Flutter project: {app_id}")
    
    # 1. Parse pubspec.yaml
    pub_name, pub_desc, packages = parse_pubspec(pubspec_path)
    clean_name = pub_name.replace("-", " ").replace("_", " ").title() if pub_name else app_id.replace("-", " ").replace("_", " ").title()
    desc = pub_desc if pub_desc else f"Imported application from source repository."
    
    # 2. Extract screens
    screens = detect_screens(project_dir / "lib")
    print(f"  -> Detected {len(screens)} screen widget class(es).")
    
    # 3. Extract Git repo info
    source_repo = source_repo_url if source_repo_url else get_git_repo(project_dir)
    
    # 4. Domain & App Type classification
    dummy_tags = generate_tags(app_id, desc, packages, screens)
    domain, app_type = classify_domain_and_type(app_id, desc, dummy_tags, packages)
    
    # 5. Tag Generation
    tags = generate_tags(app_id, desc, packages, screens)
    
    # 6. Compile metadata structure
    today = datetime.datetime.now().strftime("%Y-%m-%d")
    new_metadata = {
        "schema": "1",
        "type": "app",
        "id": app_id,
        "name": clean_name,
        "description": desc,
        "domain": domain,
        "app_type": app_type,
        "source_repo": source_repo,
        "keywords": [],
        "tags": tags,
        "built_at": today,
        "platform": "manual",
        "app": {
            "name": clean_name,
            "slug": app_id.replace("-", "_").lower(),
            "app_type": app_type,
            "prd_summary": "Auto-imported application from GitHub"
        },
        "architecture": {
            "state_management": "stateful",
            "navigation": "navigator",
            "storage": "none",
            "backend_type": "none",
            "screen_count": len(screens)
        },
        "screens": screens,
        "models": [],
        "packages": packages,
        "build": DEFAULT_BUILD
    }
    
    # 7. Merge safely with existing nocode_metadata.json
    metadata_path = project_dir / "nocode_metadata.json"
    if metadata_path.exists():
        print("  -> Found existing nocode_metadata.json. Merging cleanly...")
        try:
            existing_data = json.loads(metadata_path.read_text(encoding="utf-8"))
            final_metadata = merge_metadata(existing_data, new_metadata)
        except Exception as e:
            print(f"  Warning: Error parsing existing metadata, overwriting: {e}")
            final_metadata = new_metadata
    else:
        print("  -> No existing metadata found. Generating fresh nocode_metadata.json...")
        final_metadata = new_metadata
        
    # 8. Write final json structure
    try:
        metadata_path.write_text(json.dumps(final_metadata, indent=2), encoding="utf-8")
        print(f"  -> Wrote metadata successfully to {metadata_path.relative_to(KB_ROOT)}")
    except Exception as e:
        print(f"Error writing metadata file: {e}")
        return False
        
    # 9. Register in root index.json
    if update_index:
        relative_path = project_dir.relative_to(KB_ROOT)
        update_index_json(final_metadata["id"], final_metadata["name"], final_metadata["domain"], relative_path)
        
    return True

def clone_github_repo(repo_url):
    """
    Clones a GitHub repository URL into the apps/ directory.
    Returns the Path to the cloned directory, or None if cloning fails.
    """
    # Extract the repository name to use as the app ID
    repo_name = repo_url.rstrip("/").split("/")[-1]
    if repo_name.endswith(".git"):
        repo_name = repo_name[:-4]

    app_dir = APPS_DIR / repo_name
    
    if app_dir.exists():
        print(f"Error: App directory already exists at {app_dir}")
        print("Please delete it or run metadata enrichment directly on that directory instead.")
        return None

    # Clone the repository
    print(f"Cloning {repo_url} into {app_dir}...")
    try:
        subprocess.run(["git", "clone", repo_url, str(app_dir)], check=True)
    except subprocess.CalledProcessError:
        print("Error: Failed to clone repository.")
        return None
        
    return app_dir

def main():
    import argparse
    parser = argparse.ArgumentParser(
        description="Unified Github Importer & Nocode Metadata Generator for Flutter."
    )
    parser.add_argument(
        "target", nargs="*", 
        help="GitHub repository URL(s) (e.g. https://github.com/...) OR local Flutter project directory path(s)."
    )
    parser.add_argument("--all", action="store_true", help="Scan and enrich all subdirectories under apps/")
    parser.add_argument("--no-index", action="store_true", help="Disable registering generated apps to index.json")
    
    args = parser.parse_args()
    
    # Mode 1: Scan all
    if args.all:
        print("Scanning all projects in apps/...")
        count = 0
        for sub in APPS_DIR.iterdir():
            if sub.is_dir() and (sub / "pubspec.yaml").exists():
                if process_project(sub, update_index=not args.no_index):
                    count += 1
        print(f"\nCompleted scanning all projects. Processed {count} app(s).")
        sys.exit(0)
        
    # Mode 2: Targeted import or scan
    if args.target:
        has_failure = False
        for target in args.target:
            target = target.strip()
            if not target:
                continue
            
            # Check if target is a GitHub URL
            if target.startswith("http://") or target.startswith("https://") or target.startswith("git@"):
                app_dir = clone_github_repo(target)
                if app_dir:
                    process_project(app_dir, source_repo_url=target, update_index=not args.no_index)
                    print(f"\nUnified import and metadata generation completed successfully for {target}!")
                else:
                    print(f"Error: Failed to process repository: {target}")
                    has_failure = True
            else:
                # Assume local directory
                local_path = Path(target).resolve()
                if not local_path.exists():
                    print(f"Error: Target path does not exist: {local_path}")
                    has_failure = True
                    continue
                
                success = process_project(local_path, update_index=not args.no_index)
                if not success:
                    has_failure = True
                    continue
                print(f"\nMetadata generation completed successfully for {target}!")
        if has_failure:
            sys.exit(1)
    else:
        # Default fallback: scan current working directory
        cwd = Path.cwd()
        if (cwd / "pubspec.yaml").exists():
            success = process_project(cwd, update_index=not args.no_index)
            if not success:
                sys.exit(1)
        else:
            parser.print_help()
            sys.exit(1)

if __name__ == "__main__":
    main()
