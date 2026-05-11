#!/usr/bin/env python3
"""
organise_kb.py — Flutter Knowledge Base Organiser
Copies source repos into apps/, screens/, components/ with nocode_metadata.json
Decisions: COPY (no move), loader=new enum, bfut→4 apps, build.status="partial"
"""
import json, shutil
from pathlib import Path

KB             = Path(r"c:\Users\Krish\OneDrive\Desktop\flutter-knowledge-base")
SRC_AWESOME    = KB / "awesome-flutter-ui-master"    / "awesome-flutter-ui-master"
SRC_BEST       = KB / "Best-Flutter-UI-Templates-master" / "Best-Flutter-UI-Templates-master" / "best_flutter_ui_templates"
SRC_SCREENS    = KB / "FlutterScreens-master"        / "FlutterScreens-master"
SRC_CHALLENGES = KB / "my_flutter_challenges-master" / "my_flutter_challenges-master"
APPS_DIR       = KB / "apps"
SCREENS_DIR    = KB / "screens"
COMPONENTS_DIR = KB / "components"
INDEX          = []

def copy_tree(src, dst):
    src, dst = Path(src), Path(dst)
    if not src.exists():
        print(f"  [SKIP-DIR]  {src}"); return False
    if dst.exists(): shutil.rmtree(dst)
    shutil.copytree(str(src), str(dst))
    print(f"  [TREE] {src.name} → {dst.relative_to(KB)}"); return True

def copy_file(src, dst):
    src, dst = Path(src), Path(dst)
    if not src.exists():
        print(f"  [SKIP-FILE] {src}"); return False
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(str(src), str(dst))
    print(f"  [FILE] {src.name} → {dst.relative_to(KB)}"); return True

def wjson(path, data):
    path = Path(path); path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2), encoding="utf-8")
    print(f"  [META] {path.relative_to(KB)}")

def build_status(): return {"status": "partial", "fixer_attempts": 0}

# ═══════════════════════════════════════════════════════════════════════════════
# 1. APPS
# ═══════════════════════════════════════════════════════════════════════════════
print("\n=== APPS ===")

SIMPLE_APPS = [
    dict(id="awesome-login-app", name="Awesome Login App",
         desc="Polished login/signup page with rounded SVG input fields and a custom alert service.",
         domain="generic", app_type="utility", src=SRC_AWESOME/"awesome_login_page",
         repo="awesome-flutter-ui-master",
         packages=["flutter_svg","flutter_screenutil"],
         screens=[{"id":"login-screen","name":"Login Screen","screen_type":"auth"},
                  {"id":"register-screen","name":"Register Screen","screen_type":"auth"}],
         tags=["login","auth","svg","screenutil"]),
    dict(id="book-app-ui", name="Book App UI",
         desc="Reader-style app with staggered grid book listing and detail screens.",
         domain="media", app_type="reader", src=SRC_AWESOME/"book_app_ui",
         repo="awesome-flutter-ui-master",
         packages=["flutter_svg","flutter_staggered_grid_view"],
         screens=[{"id":"book-list-screen","name":"Book List","screen_type":"list"},
                  {"id":"book-detail-screen","name":"Book Detail","screen_type":"detail"}],
         tags=["books","grid","staggered","media"]),
    dict(id="food-order-app", name="Food Order App",
         desc="Food marketplace with animated page transitions and order flow.",
         domain="ecommerce", app_type="marketplace", src=SRC_AWESOME/"food_order_app",
         repo="awesome-flutter-ui-master",
         packages=["simple_animations","page_transition"],
         screens=[{"id":"home-screen","name":"Home","screen_type":"dashboard"},
                  {"id":"food-detail-screen","name":"Food Detail","screen_type":"detail"},
                  {"id":"cart-screen","name":"Cart","screen_type":"form"}],
         tags=["food","ecommerce","animation","order"]),
    dict(id="movie-streaming-app", name="Movie Streaming App",
         desc="Dashboard streaming app with animated hero banners and movie cards.",
         domain="media", app_type="dashboard", src=SRC_AWESOME/"movie_streaming_app",
         repo="awesome-flutter-ui-master",
         packages=["simple_animations"],
         screens=[{"id":"home-screen","name":"Home","screen_type":"dashboard"},
                  {"id":"movie-detail-screen","name":"Movie Detail","screen_type":"detail"}],
         tags=["movies","streaming","animation","media"]),
    dict(id="profile-page-app", name="Profile Page App",
         desc="Social profile page with icon set, stats, and responsive layout.",
         domain="social", app_type="portfolio", src=SRC_AWESOME/"profile_page",
         repo="awesome-flutter-ui-master",
         packages=["line_awesome_flutter","flutter_screenutil"],
         screens=[{"id":"profile-screen","name":"Profile","screen_type":"detail"}],
         tags=["profile","social","icons","screenutil"]),
]

for a in SIMPLE_APPS:
    dst = APPS_DIR / a["id"]
    print(f"\n→ {a['id']}")
    copy_tree(a["src"], dst)
    wjson(dst / "nocode_metadata.json", {
        "id": a["id"], "type": "app", "name": a["name"], "description": a["desc"],
        "domain": a["domain"], "app_type": a["app_type"],
        "source_repo": a["repo"], "screens": a["screens"],
        "packages": a["packages"], "build": build_status(), "tags": a["tags"],
    })
    INDEX.append({"id":a["id"],"type":"app","path":f"apps/{a['id']}","name":a["name"],"domain":a["domain"]})

# ── best_flutter_ui_templates → 4 separate apps ──────────────────────────────
BFUT_APPS = [
    dict(id="fitness-app", name="Fitness App",
         desc="Fitness tracker with diary, training plans, and animated custom UI views.",
         domain="fitness", app_type="tracker", lib_sub="fitness_app",
         packages=["font_awesome_flutter","intl","animations"],
         screens=[{"id":"fitness-home","name":"Fitness Home","screen_type":"dashboard"},
                  {"id":"my-diary","name":"My Diary","screen_type":"list"},
                  {"id":"training","name":"Training","screen_type":"detail"}],
         tags=["fitness","health","tracker","animation","diary"]),
    dict(id="hotel-booking-app", name="Hotel Booking App",
         desc="Hotel search and booking UI with date pickers and smooth animations.",
         domain="travel", app_type="booking", lib_sub="hotel_booking",
         packages=["intl","animations"],
         screens=[{"id":"hotel-home","name":"Hotel Home","screen_type":"dashboard"},
                  {"id":"hotel-list","name":"Hotel List","screen_type":"list"},
                  {"id":"hotel-detail","name":"Hotel Detail","screen_type":"detail"}],
         tags=["hotel","travel","booking","animation"]),
    dict(id="design-course-app", name="Design Course App",
         desc="Education app for design courses with ratings, cards and detail views.",
         domain="education", app_type="reader", lib_sub="design_course",
         packages=["font_awesome_flutter","flutter_rating_bar"],
         screens=[{"id":"course-home","name":"Course Home","screen_type":"dashboard"},
                  {"id":"course-detail","name":"Course Detail","screen_type":"detail"}],
         tags=["education","courses","rating","design"]),
    dict(id="intro-animation-app", name="Intro Animation App",
         desc="Onboarding introduction sequence with elegant page animations.",
         domain="generic", app_type="utility", lib_sub="introduction_animation",
         packages=["animations"],
         screens=[{"id":"intro-1","name":"Intro Screen 1","screen_type":"onboarding"},
                  {"id":"intro-2","name":"Intro Screen 2","screen_type":"onboarding"},
                  {"id":"intro-3","name":"Intro Screen 3","screen_type":"onboarding"}],
         tags=["onboarding","intro","animation"]),
]

for a in BFUT_APPS:
    dst = APPS_DIR / a["id"]
    print(f"\n→ {a['id']}")
    dst.mkdir(parents=True, exist_ok=True)
    copy_file(SRC_BEST / "pubspec.yaml",   dst / "pubspec.yaml")
    copy_tree(SRC_BEST / "assets",         dst / "assets")
    copy_tree(SRC_BEST / "lib" / a["lib_sub"], dst / "lib" / a["lib_sub"])
    copy_tree(SRC_BEST / "lib" / "model",       dst / "lib" / "model")
    copy_tree(SRC_BEST / "lib" / "custom_drawer", dst / "lib" / "custom_drawer")
    wjson(dst / "nocode_metadata.json", {
        "id": a["id"], "type": "app", "name": a["name"], "description": a["desc"],
        "domain": a["domain"], "app_type": a["app_type"],
        "source_repo": "Best-Flutter-UI-Templates-master",
        "screens": a["screens"], "packages": a["packages"],
        "build": build_status(), "tags": a["tags"],
    })
    INDEX.append({"id":a["id"],"type":"app","path":f"apps/{a['id']}","name":a["name"],"domain":a["domain"]})

# ═══════════════════════════════════════════════════════════════════════════════
# 2. SCREENS
# ═══════════════════════════════════════════════════════════════════════════════
print("\n=== SCREENS ===")

SCREENS_CFG = [
    # FlutterScreens login variants
    *[dict(id=f"flutter-login-screen-{i}", name=f"Flutter Login Screen {i}",
           desc=f"Standalone Flutter login screen design variant {i}.",
           screen_type="auth", domain="generic",
           src=SRC_SCREENS/"lib"/f"login_screen_{i}.dart",
           fname=f"login_screen_{i}.dart",
           repo="FlutterScreens-master",
           tags=["login","auth",f"variant-{i}"])
      for i in range(1, 7)],
    # my_flutter_challenges
    dict(id="banking-app-screen", name="Banking App Screen",
         desc="Financial dashboard with account overview and transaction list.",
         screen_type="dashboard", domain="finance",
         src=SRC_CHALLENGES/"lib"/"banking_app.dart", fname="banking_app.dart",
         repo="my_flutter_challenges-master", tags=["banking","finance","dashboard"]),
    dict(id="bsd-login-register", name="BSD Login/Register Screen",
         desc="Login and registration screen with BSD-style layout.",
         screen_type="auth", domain="generic",
         src=SRC_CHALLENGES/"lib"/"bsd_login_register_challenge.dart",
         fname="bsd_login_register_challenge.dart",
         repo="my_flutter_challenges-master", tags=["login","register","auth"]),
    dict(id="coffee-app-auth", name="Coffee App Auth Screen",
         desc="Coffee-themed login/signup screen with warm tones.",
         screen_type="auth", domain="ecommerce",
         src=SRC_CHALLENGES/"lib"/"coffee_app_auth.dart", fname="coffee_app_auth.dart",
         repo="my_flutter_challenges-master", tags=["coffee","auth","theme"]),
    dict(id="flutter-experiment", name="Flutter Experiment Screen",
         desc="Experimental Flutter widget composition and layout exploration.",
         screen_type="general", domain="generic",
         src=SRC_CHALLENGES/"lib"/"flutter_experiment.dart", fname="flutter_experiment.dart",
         repo="my_flutter_challenges-master", tags=["experiment","widget","layout"]),
    dict(id="indexed-list", name="Indexed List Screen",
         desc="Alphabetically indexed scrollable list with sticky headers.",
         screen_type="list", domain="generic",
         src=SRC_CHALLENGES/"lib"/"indexed_list.dart", fname="indexed_list.dart",
         repo="my_flutter_challenges-master", tags=["list","index","scroll"]),
    dict(id="login-challenge", name="Login Challenge Screen",
         desc="Login screen challenge with creative layout.",
         screen_type="auth", domain="generic",
         src=SRC_CHALLENGES/"lib"/"login_challenge.dart", fname="login_challenge.dart",
         repo="my_flutter_challenges-master", tags=["login","auth","challenge"]),
    dict(id="login-profile-challenge", name="Login Profile Challenge Screen",
         desc="Combined login and profile challenge screen.",
         screen_type="auth", domain="social",
         src=SRC_CHALLENGES/"lib"/"login_profile_challenge.dart",
         fname="login_profile_challenge.dart",
         repo="my_flutter_challenges-master", tags=["login","profile","auth"]),
    dict(id="minimal-login", name="Minimal Login Screen",
         desc="Minimalist login with clean, spacious layout.",
         screen_type="auth", domain="generic",
         src=SRC_CHALLENGES/"lib"/"minimal_login.dart", fname="minimal_login.dart",
         repo="my_flutter_challenges-master", tags=["login","minimal","auth"]),
    dict(id="mobile-dashboard", name="Mobile Dashboard Screen",
         desc="General-purpose mobile dashboard with stats and overview cards.",
         screen_type="dashboard", domain="generic",
         src=SRC_CHALLENGES/"lib"/"mobile_dashboard.dart", fname="mobile_dashboard.dart",
         repo="my_flutter_challenges-master", tags=["dashboard","stats","cards"]),
    dict(id="profile-challenge", name="Profile Challenge Screen",
         desc="Creative profile screen with animated avatar and stats.",
         screen_type="detail", domain="social",
         src=SRC_CHALLENGES/"lib"/"profile_challenge.dart", fname="profile_challenge.dart",
         repo="my_flutter_challenges-master", tags=["profile","social","avatar"]),
    dict(id="profile-design", name="Profile Design Screen",
         desc="Alternative profile design with distinct visual treatment.",
         screen_type="detail", domain="social",
         src=SRC_CHALLENGES/"lib"/"profile_design.dart", fname="profile_design.dart",
         repo="my_flutter_challenges-master", tags=["profile","social","design"]),
    dict(id="sliding-login", name="Sliding Login Screen",
         desc="Login screen with sliding panel animation between login and signup.",
         screen_type="auth", domain="generic",
         src=SRC_CHALLENGES/"lib"/"sliding_login.dart", fname="sliding_login.dart",
         repo="my_flutter_challenges-master", tags=["login","auth","sliding","animation"]),
    dict(id="sushi-order", name="Sushi Order Screen",
         desc="Food ordering screen for a sushi restaurant with item selector.",
         screen_type="form", domain="ecommerce",
         src=SRC_CHALLENGES/"lib"/"sushi_order.dart", fname="sushi_order.dart",
         repo="my_flutter_challenges-master", tags=["food","order","sushi","ecommerce"]),
    dict(id="ticket-booking", name="Ticket Booking Screen",
         desc="Event/transport ticket booking form with seat/date selection.",
         screen_type="form", domain="travel",
         src=SRC_CHALLENGES/"lib"/"ticket_booking.dart", fname="ticket_booking.dart",
         repo="my_flutter_challenges-master", tags=["ticket","booking","travel","form"]),
    dict(id="world-clock", name="World Clock Screen",
         desc="World clock showing multiple timezone clocks.",
         screen_type="dashboard", domain="utility",
         src=SRC_CHALLENGES/"lib"/"world_clock.dart", fname="world_clock.dart",
         repo="my_flutter_challenges-master", tags=["clock","timezone","utility"]),
]

for s in SCREENS_CFG:
    dst_dir = SCREENS_DIR / s["id"]
    dst_dir.mkdir(parents=True, exist_ok=True)
    print(f"\n→ {s['id']}")
    copy_file(s["src"], dst_dir / s["fname"])
    wjson(dst_dir / "nocode_metadata.json", {
        "id": s["id"], "type": "screen", "name": s["name"], "description": s["desc"],
        "screen_type": s["screen_type"], "domain": s["domain"],
        "app": None, "source_repo": s["repo"], "tags": s["tags"],
    })
    INDEX.append({"id":s["id"],"type":"screen","path":f"screens/{s['id']}","name":s["name"],"domain":s["domain"]})

# ═══════════════════════════════════════════════════════════════════════════════
# 3. COMPONENTS
# ═══════════════════════════════════════════════════════════════════════════════
print("\n=== COMPONENTS ===")

COMP_CFG = [
    # ── Buttons
    dict(id="simple-round-button", sub="button", ctype="button",
         name="Simple Round Button",
         desc="Rounded rectangular button widget with customisable label and color.",
         files=[(SRC_SCREENS/"lib"/"buttons"/"simple_round_button.dart","simple_round_button.dart")],
         repo="FlutterScreens-master", tags=["button","round"]),
    dict(id="simple-round-icon-button", sub="button", ctype="button",
         name="Simple Round Icon Button",
         desc="Rounded button with leading icon and label.",
         files=[(SRC_SCREENS/"lib"/"buttons"/"simple_round_icon_button.dart","simple_round_icon_button.dart")],
         repo="FlutterScreens-master", tags=["button","icon","round"]),
    dict(id="simple-round-only-icon-button", sub="button", ctype="button",
         name="Simple Round Only-Icon Button",
         desc="Rounded icon-only button with no label text.",
         files=[(SRC_SCREENS/"lib"/"buttons"/"simple_round_only_icon_button.dart","simple_round_only_icon_button.dart")],
         repo="FlutterScreens-master", tags=["button","icon-only","round"]),
    dict(id="buttons-collection", sub="button", ctype="button",
         name="Buttons Collection",
         desc="Gallery of multiple button styles in a single example file.",
         files=[(SRC_SCREENS/"lib"/"Examples"/"buttons.dart","buttons.dart")],
         repo="FlutterScreens-master", tags=["button","collection","example"]),
    # ── Loaders  (loader = new enum value)
    dict(id="color-loader-1", sub="loader", ctype="loader",
         name="Color Loader 1",
         desc="Animated color-cycling loader widget variant 1.",
         files=[(SRC_SCREENS/"lib"/"loaders"/"color_loader.dart","color_loader.dart")],
         repo="FlutterScreens-master", tags=["loader","animation","color"]),
    dict(id="color-loader-2", sub="loader", ctype="loader",
         name="Color Loader 2",
         desc="Animated color-cycling loader widget variant 2.",
         files=[(SRC_SCREENS/"lib"/"loaders"/"color_loader_2.dart","color_loader_2.dart")],
         repo="FlutterScreens-master", tags=["loader","animation","color"]),
    dict(id="color-loader-3", sub="loader", ctype="loader",
         name="Color Loader 3",
         desc="Animated color-cycling loader widget variant 3.",
         files=[(SRC_SCREENS/"lib"/"loaders"/"color_loader_3.dart","color_loader_3.dart")],
         repo="FlutterScreens-master", tags=["loader","animation","color"]),
    dict(id="color-loader-4", sub="loader", ctype="loader",
         name="Color Loader 4",
         desc="Animated color-cycling loader widget variant 4.",
         files=[(SRC_SCREENS/"lib"/"loaders"/"color_loader_4.dart","color_loader_4.dart")],
         repo="FlutterScreens-master", tags=["loader","animation","color"]),
    dict(id="color-loader-5", sub="loader", ctype="loader",
         name="Color Loader 5",
         desc="Animated color-cycling loader widget variant 5.",
         files=[(SRC_SCREENS/"lib"/"loaders"/"color_loader_5.dart","color_loader_5.dart")],
         repo="FlutterScreens-master", tags=["loader","animation","color"]),
    dict(id="flip-loader", sub="loader", ctype="loader",
         name="Flip Loader",
         desc="3D flip animation loader widget.",
         files=[(SRC_SCREENS/"lib"/"loaders"/"flip_loader.dart","flip_loader.dart")],
         repo="FlutterScreens-master", tags=["loader","flip","3d","animation"]),
    # ── Nav Bars
    dict(id="bottom-menu-bar", sub="nav_bar", ctype="nav_bar",
         name="Bottom Menu Bar",
         desc="Custom bottom navigation bar with icon + label menu items.",
         files=[(SRC_CHALLENGES/"lib"/"bottom_menu_bar.dart","bottom_menu_bar.dart")],
         repo="my_flutter_challenges-master", tags=["nav","bottom","menu"]),
    dict(id="bottom-nav-bar", sub="nav_bar", ctype="nav_bar",
         name="Bottom Nav Bar",
         desc="Stylised bottom navigation bar with active-state indicator.",
         files=[(SRC_CHALLENGES/"lib"/"bottom_nav_bar.dart","bottom_nav_bar.dart")],
         repo="my_flutter_challenges-master", tags=["nav","bottom","indicator"]),
    dict(id="titled-bottom-bar", sub="nav_bar", ctype="nav_bar",
         name="Titled Bottom Bar",
         desc="Bottom navigation bar that shows titles alongside icons.",
         files=[(SRC_CHALLENGES/"lib"/"titled_bottom_bar.dart","titled_bottom_bar.dart")],
         repo="my_flutter_challenges-master", tags=["nav","bottom","titled"]),
    dict(id="custom-drawer", sub="nav_bar", ctype="nav_bar",
         name="Custom Drawer",
         desc="Animated side drawer with user controller from Best Flutter UI Templates.",
         files=[(SRC_BEST/"lib"/"custom_drawer"/"home_drawer.dart","home_drawer.dart"),
                (SRC_BEST/"lib"/"custom_drawer"/"drawer_user_controller.dart","drawer_user_controller.dart")],
         repo="Best-Flutter-UI-Templates-master", tags=["nav","drawer","animation","side-menu"]),
    # ── App Bar
    dict(id="search-app-bar", sub="app_bar", ctype="app_bar",
         name="Search App Bar",
         desc="App bar with integrated search field and animated transition.",
         files=[(SRC_CHALLENGES/"lib"/"search_app_bar.dart","search_app_bar.dart")],
         repo="my_flutter_challenges-master", tags=["app-bar","search","animation"]),
    # ── Form Fields
    dict(id="crazy-switch", sub="form_field", ctype="form_field",
         name="Crazy Switch",
         desc="Creatively animated toggle switch widget.",
         files=[(SRC_CHALLENGES/"lib"/"crazy_switch_challenge.dart","crazy_switch_challenge.dart")],
         repo="my_flutter_challenges-master", tags=["switch","toggle","form","animation"]),
    dict(id="number-picker", sub="form_field", ctype="form_field",
         name="Number Picker",
         desc="Scrollable number picker / spinner widget.",
         files=[(SRC_CHALLENGES/"lib"/"number_picker.dart","number_picker.dart")],
         repo="my_flutter_challenges-master", tags=["picker","number","spinner","form"]),
    dict(id="rounded-input-field", sub="form_field", ctype="form_field",
         name="Rounded Input Field",
         desc="Customisable rounded text-input field widget with icon prefix.",
         files=[(SRC_AWESOME/"widgets"/"rounded_input_field.dart","rounded_input_field.dart")],
         repo="awesome-flutter-ui-master", tags=["input","form","rounded","text-field"]),
    # ── Dialogs
    dict(id="alert-service", sub="dialog", ctype="dialog",
         name="Alert Service",
         desc="Reusable alert dialog helper widget with configurable title/message/actions.",
         files=[(SRC_AWESOME/"widgets"/"alert_service.dart","alert_service.dart")],
         repo="awesome-flutter-ui-master", tags=["dialog","alert","service"]),
    # ── Cards
    dict(id="slide-list-view", sub="card", ctype="card",
         name="Slide List View",
         desc="Horizontally sliding card list view widget.",
         files=[(SRC_SCREENS/"lib"/"misc"/"slide_list_view.dart","slide_list_view.dart")],
         repo="FlutterScreens-master", tags=["card","list","slide","scroll"]),
    dict(id="flying-widget", sub="card", ctype="card",
         name="Flying Widget",
         desc="Animated widget that flies across the screen on interaction.",
         files=[(SRC_CHALLENGES/"lib"/"flying_widget.dart","flying_widget.dart")],
         repo="my_flutter_challenges-master", tags=["card","animation","flying"]),
    dict(id="bubbles-rain", sub="card", ctype="card",
         name="Bubbles Rain",
         desc="Particle effect widget showing animated falling bubbles.",
         files=[(SRC_CHALLENGES/"lib"/"bubbles_rain.dart","bubbles_rain.dart")],
         repo="my_flutter_challenges-master", tags=["card","particle","animation","bubbles"]),
    dict(id="liquid-swipe", sub="card", ctype="card",
         name="Liquid Swipe",
         desc="Liquid swipe page-transition animation widget.",
         files=[(SRC_CHALLENGES/"lib"/"liquid_swipe_challenge.dart","liquid_swipe_challenge.dart")],
         repo="my_flutter_challenges-master", tags=["card","liquid","swipe","animation"]),
    dict(id="transformation-example", sub="card", ctype="card",
         name="Transformation Example",
         desc="GestureDetector + Matrix4 transform widget demonstrating pinch/zoom/rotate.",
         files=[(SRC_CHALLENGES/"lib"/"transformation_example.dart","transformation_example.dart")],
         repo="my_flutter_challenges-master", tags=["card","transform","gesture","matrix"]),
    # ── List Tiles
    dict(id="rating", sub="list_tile", ctype="list_tile",
         name="Rating Widget",
         desc="Star-rating list tile widget with interactive touch support.",
         files=[(SRC_SCREENS/"lib"/"misc"/"rating.dart","rating.dart")],
         repo="FlutterScreens-master", tags=["list-tile","rating","stars"]),
    dict(id="grid-list-example", sub="list_tile", ctype="list_tile",
         name="Grid List Example",
         desc="Grid-layout list demonstrating staggered and uniform grid tiles.",
         files=[(SRC_CHALLENGES/"lib"/"grid_list_example.dart","grid_list_example.dart")],
         repo="my_flutter_challenges-master", tags=["list-tile","grid","layout"]),
    # ── Bottom Sheet
    dict(id="foldable-options-menu", sub="bottom_sheet", ctype="bottom_sheet",
         name="Foldable Options Menu",
         desc="Bottom sheet that unfolds to reveal a menu of action options.",
         files=[(SRC_CHALLENGES/"lib"/"foldable_options_menu.dart","foldable_options_menu.dart")],
         repo="my_flutter_challenges-master", tags=["bottom-sheet","menu","fold","animation"]),
]

for c in COMP_CFG:
    dst_dir = COMPONENTS_DIR / c["sub"] / c["id"]
    dst_dir.mkdir(parents=True, exist_ok=True)
    print(f"\n→ components/{c['sub']}/{c['id']}")
    for src_f, fname in c["files"]:
        copy_file(src_f, dst_dir / fname)
    wjson(dst_dir / "nocode_metadata.json", {
        "id": c["id"], "type": "component", "name": c["name"], "description": c["desc"],
        "component_type": c["ctype"], "domain": "generic",
        "source_repo": c["repo"], "tags": c["tags"],
    })
    INDEX.append({"id":c["id"],"type":"component",
                  "path":f"components/{c['sub']}/{c['id']}",
                  "name":c["name"],"component_type":c["ctype"]})

# ═══════════════════════════════════════════════════════════════════════════════
# 4. ROOT index.json
# ═══════════════════════════════════════════════════════════════════════════════
print("\n=== index.json ===")
wjson(KB / "index.json", {"version": 1, "entries": INDEX})
print(f"\nDone — {len(INDEX)} entries written to index.json")
print(f"  Apps:       {sum(1 for e in INDEX if e['type']=='app')}")
print(f"  Screens:    {sum(1 for e in INDEX if e['type']=='screen')}")
print(f"  Components: {sum(1 for e in INDEX if e['type']=='component')}")
