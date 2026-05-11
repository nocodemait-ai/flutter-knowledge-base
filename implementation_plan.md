# Flutter Knowledge Base — Reorganisation Plan

Segregate content from the 4 source repos into `apps/`, `screens/`, and `components/`, add `nocode_metadata.json` to every entry, and rebuild `index.json` at the root.

---

## Source → Target Mapping

### APPS (9 total)

| Target folder | Source | Domain | App type | Key packages |
|---|---|---|---|---|
| `apps/awesome-login-app` | `awesome_login_page/` | generic | utility | flutter_svg, flutter_screenutil |
| `apps/book-app-ui` | `book_app_ui/` | media | reader | flutter_svg, flutter_staggered_grid_view |
| `apps/food-order-app` | `food_order_app/` | ecommerce | marketplace | simple_animations, page_transition |
| `apps/movie-streaming-app` | `movie_streaming_app/` | media | dashboard | simple_animations |
| `apps/profile-page-app` | `profile_page/` | social | portfolio | line_awesome_flutter, flutter_screenutil |
| `apps/fitness-app` | `best_flutter_ui_templates/lib/fitness_app/` | fitness | tracker | font_awesome_flutter, intl, animations |
| `apps/hotel-booking-app` | `best_flutter_ui_templates/lib/hotel_booking/` | travel | booking | intl, animations |
| `apps/design-course-app` | `best_flutter_ui_templates/lib/design_course/` | education | reader | font_awesome_flutter, flutter_rating_bar |
| `apps/intro-animation-app` | `best_flutter_ui_templates/lib/introduction_animation/` | generic | utility | animations |

> **Note:** The 4 best_flutter_ui_templates sub-apps share one `pubspec.yaml`. Their individual app folders will each carry that shared pubspec + just their relevant `lib/` subtree.

---

### SCREENS (21 total)

| Target folder | Source file | Screen type | Domain |
|---|---|---|---|
| `screens/flutter-login-screen-1` | `FlutterScreens/lib/login_screen_1.dart` | auth | generic |
| `screens/flutter-login-screen-2` | `FlutterScreens/lib/login_screen_2.dart` | auth | generic |
| `screens/flutter-login-screen-3` | `FlutterScreens/lib/login_screen_3.dart` | auth | generic |
| `screens/flutter-login-screen-4` | `FlutterScreens/lib/login_screen_4.dart` | auth | generic |
| `screens/flutter-login-screen-5` | `FlutterScreens/lib/login_screen_5.dart` | auth | generic |
| `screens/flutter-login-screen-6` | `FlutterScreens/lib/login_screen_6.dart` | auth | generic |
| `screens/banking-app` | `my_flutter_challenges/lib/banking_app.dart` | dashboard | finance |
| `screens/bsd-login-register` | `my_flutter_challenges/lib/bsd_login_register_challenge.dart` | auth | generic |
| `screens/coffee-app-auth` | `my_flutter_challenges/lib/coffee_app_auth.dart` | auth | generic |
| `screens/flutter-experiment` | `my_flutter_challenges/lib/flutter_experiment.dart` | general | generic |
| `screens/indexed-list` | `my_flutter_challenges/lib/indexed_list.dart` | list | generic |
| `screens/login-challenge` | `my_flutter_challenges/lib/login_challenge.dart` | auth | generic |
| `screens/login-profile-challenge` | `my_flutter_challenges/lib/login_profile_challenge.dart` | auth | generic |
| `screens/minimal-login` | `my_flutter_challenges/lib/minimal_login.dart` | auth | generic |
| `screens/mobile-dashboard` | `my_flutter_challenges/lib/mobile_dashboard.dart` | dashboard | generic |
| `screens/profile-challenge` | `my_flutter_challenges/lib/profile_challenge.dart` | detail | social |
| `screens/profile-design` | `my_flutter_challenges/lib/profile_design.dart` | detail | social |
| `screens/sliding-login` | `my_flutter_challenges/lib/sliding_login.dart` | auth | generic |
| `screens/sushi-order` | `my_flutter_challenges/lib/sushi_order.dart` | form | ecommerce |
| `screens/ticket-booking` | `my_flutter_challenges/lib/ticket_booking.dart` | form | travel |
| `screens/world-clock` | `my_flutter_challenges/lib/world_clock.dart` | dashboard | utility |

---

### COMPONENTS (27 total)

| Target folder | Source file(s) | component.type |
|---|---|---|
| `components/button/simple-round-button` | `FlutterScreens/lib/buttons/simple_round_button.dart` | button |
| `components/button/simple-round-icon-button` | `FlutterScreens/lib/buttons/simple_round_icon_button.dart` | button |
| `components/button/simple-round-only-icon-button` | `FlutterScreens/lib/buttons/simple_round_only_icon_button.dart` | button |
| `components/button/buttons-collection` | `FlutterScreens/lib/Examples/buttons.dart` | button |
| `components/loader/color-loader-1` | `FlutterScreens/lib/loaders/color_loader.dart` | loader* |
| `components/loader/color-loader-2` | `FlutterScreens/lib/loaders/color_loader_2.dart` | loader* |
| `components/loader/color-loader-3` | `FlutterScreens/lib/loaders/color_loader_3.dart` | loader* |
| `components/loader/color-loader-4` | `FlutterScreens/lib/loaders/color_loader_4.dart` | loader* |
| `components/loader/color-loader-5` | `FlutterScreens/lib/loaders/color_loader_5.dart` | loader* |
| `components/loader/flip-loader` | `FlutterScreens/lib/loaders/flip_loader.dart` | loader* |
| `components/nav_bar/bottom-menu-bar` | `my_flutter_challenges/lib/bottom_menu_bar.dart` | nav_bar |
| `components/nav_bar/bottom-nav-bar` | `my_flutter_challenges/lib/bottom_nav_bar.dart` | nav_bar |
| `components/nav_bar/titled-bottom-bar` | `my_flutter_challenges/lib/titled_bottom_bar.dart` | nav_bar |
| `components/nav_bar/custom-drawer` | `best_flutter_ui_templates/lib/custom_drawer/home_drawer.dart` + `drawer_user_controller.dart` | nav_bar |
| `components/app_bar/search-app-bar` | `my_flutter_challenges/lib/search_app_bar.dart` | app_bar |
| `components/form_field/crazy-switch` | `my_flutter_challenges/lib/crazy_switch_challenge.dart` | form_field |
| `components/form_field/number-picker` | `my_flutter_challenges/lib/number_picker.dart` | form_field |
| `components/form_field/rounded-input-field` | `awesome-flutter-ui/widgets/rounded_input_field.dart` | form_field |
| `components/dialog/alert-service` | `awesome-flutter-ui/widgets/alert_service.dart` | dialog |
| `components/card/slide-list-view` | `FlutterScreens/lib/misc/slide_list_view.dart` | card |
| `components/card/flying-widget` | `my_flutter_challenges/lib/flying_widget.dart` | card |
| `components/card/bubbles-rain` | `my_flutter_challenges/lib/bubbles_rain.dart` | card |
| `components/card/liquid-swipe` | `my_flutter_challenges/lib/liquid_swipe_challenge.dart` | card |
| `components/card/transformation-example` | `my_flutter_challenges/lib/transformation_example.dart` | card |
| `components/list_tile/rating` | `FlutterScreens/lib/misc/rating.dart` | list_tile |
| `components/list_tile/grid-list-example` | `my_flutter_challenges/lib/grid_list_example.dart` | list_tile |
| `components/bottom_sheet/foldable-options-menu` | `my_flutter_challenges/lib/foldable_options_menu.dart` | bottom_sheet |

> *`loader` is not in the enum spec. The folder `components/loader/` already exists in the repo. These entries will use `component.type: "card"` in their JSON metadata (closest valid enum value) but are stored under `components/loader/` for human navigation.

---

## Files NOT migrated (excluded)

| Item | Reason |
|---|---|
| `awesome-flutter-ui/walkthrough_screen/` | Android native Gradle project, not Flutter |
| `awesome-flutter-ui/designs/` | Adobe XD design files only |
| `my_flutter_challenges/lib/main.dart` | Route dispatcher — no standalone value |
| `FlutterScreens/lib/main.dart` | Route dispatcher |
| `FlutterScreens/lib/loaders/dot_type.dart` | Enum helper, not a standalone component |
| `FlutterScreens/lib/experiments/graph.dart` | Minimal experiment, not reusable |
| `best_flutter_ui_templates` shared screens | `home_screen.dart`, `navigation_home_screen.dart`, `feedback_screen.dart`, `help_screen.dart`, `invite_friend_screen.dart` are app-shell glue, included inside their respective sub-app folders |

---

## Implementation Approach

> [!IMPORTANT]
> All source files will be **copied** (not moved) — originals remain untouched in their repo folders.

### Phase 1 — Write the organiser script
A single Python script (`organise_kb.py`) will:
1. Recreate needed subdirs under `apps/`, `screens/`, `components/`
2. Copy source trees / individual dart files to the correct target
3. Write `nocode_metadata.json` for every entry
4. Build and write the root `index.json`

### Phase 2 — Run the script
`python organise_kb.py` from the workspace root.

### Phase 3 — Verify
- Spot-check a sample app, screen, and component folder for correct `nocode_metadata.json`
- Validate `index.json` parses cleanly and has an entry for every folder

---

## Open Questions

> [!IMPORTANT]
> **1. Copy or move?**  
> Plan assumes COPY. If you want the originals removed after migration, say so.

> [!IMPORTANT]
> **2. `loader` component.type**  
> `loader` is not in the enum. Plan stores loaders under `components/loader/` but writes `component.type: "card"` in metadata. Should `loader` be added to the enum (requires retrieval update), or is `"card"` acceptable?

> [!IMPORTANT]
> **3. best_flutter_ui_templates sub-apps**  
> These 4 sections share one pubspec.yaml and one assets folder. Each will get its own app entry with the shared pubspec copied in. If you want them kept as a **single** multi-module app instead, let me know.

> [!NOTE]
> **4. `build.status`**  
> No build results exist yet. All app metadata will default to `"status": "partial"` and `"fixer_attempts": 0`.
