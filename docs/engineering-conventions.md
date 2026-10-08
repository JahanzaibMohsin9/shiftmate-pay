# ShiftMate Pay — Engineering Conventions

## 1. Primary technical choices
- Flutter for the app framework
- Riverpod for state management and dependency injection
- GoRouter for navigation
- Drift for source-of-truth persistence
- SharedPreferences for lightweight app settings and simple flags
- Freezed for immutable models where it improves clarity
- flutter_local_notifications for MVP local reminders

## 1.1 Settings storage decision
- choose SharedPreferences over Hive for MVP settings storage
- use it only for lightweight preferences such as first-run flags, default calendar view, first day of week, notification permission flags, and premium cache hints
- do not use it as a source of truth for jobs, patterns, shift instances, or pay data

### Why SharedPreferences instead of Hive
- the architecture already chooses Drift for structured local data, so Hive would duplicate local persistence concerns
- the app only needs a small settings cache, not a second object database
- SharedPreferences is simpler for primitive key-value app configuration and reduces setup overhead
- this keeps the data boundary clean: Drift for domain data, SharedPreferences for lightweight settings

## 2. MVP scope baseline

### Included in MVP
- job setup with hourly rate and pay rules
- rotating shift pattern builder
- manual one-off shift edits
- monthly and weekly calendar views
- per-shift notes
- weekly and monthly pay estimate
- basic overtime support
- holiday pay multiplier support
- local reminders for upcoming shifts and sleep reminders
- export schedule as image or PDF
- backup/export of local data

### Excluded from MVP
- cloud sync
- employer roster import
- payroll integrations
- tax filing support
- smartwatch companion
- AI chat assistant
- desktop/web parity within MVP scope

## 3. Free vs premium baseline

### Always free
- one job
- calendar
- basic pattern builder
- basic pay estimate
- simple notifications

### Premium-gated
- multiple jobs
- widgets
- export PDF/image
- advanced pay rules
- holiday packs
- additional reminder presets

## 4. Folder ownership rules
- `lib/app/`: app-level composition, bootstrap, router, theme
- `lib/core/`: shared framework-agnostic primitives used by multiple features
- `lib/features/<feature>/`: feature-specific presentation, application, and local coordination code
- `lib/domain/`: pure domain entities, repository contracts, services, and use cases
- `lib/data/`: persistence implementations, mappers, and local data sources

## 5. Layering rules
- presentation depends on application/domain abstractions, never on persistence details
- application orchestrates feature flows and provider wiring
- domain stays pure Dart and framework-agnostic
- data implements repository contracts and storage mapping
- avoid cross-feature imports unless the dependency is promoted to `lib/core/` or `lib/domain/`

## 6. Naming rules
- files use `snake_case.dart`
- classes, enums, typedefs use `PascalCase`
- variables, parameters, methods, and top-level functions use `camelCase`
- providers end with `Provider`
- repository interfaces are named as abstractions, implementations are suffixed with `RepositoryImpl` only if a clearer name is not available
- DTO and persistence models must use explicit suffixes such as `Dto`, `Companion`, or `Record`

## 7. Code style rules
- prefer small widgets and pure helper methods over long build methods
- keep business rules out of Flutter widgets
- store money in integer minor units only
- store durations in minutes only
- prefer deterministic date handling with explicit timezone assumptions
- add tests with every rules-heavy domain service
