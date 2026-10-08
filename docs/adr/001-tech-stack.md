# ADR 001 — ShiftMate Pay MVP Tech Stack

## Status
Accepted

## Context
ShiftMate Pay is an offline-first Flutter app focused on rotating schedules, pay estimation, reminders, and local export. The MVP needs:
- fast local reads and writes
- deterministic business logic
- clear module boundaries
- Android-first delivery with future room for platform-specific integrations
- maintainability for a growing rules-heavy domain

## Decision

### UI and app framework
- **Flutter** for cross-platform UI delivery
- **Dart** as the single language across presentation, domain, and data implementation
- **Material 3** for modern mobile UI consistency and faster design-system adoption

### State management and app structure
- **Riverpod** for dependency injection and unidirectional state flow
- **GoRouter** for route definition and predictable navigation structure
- **Feature-first clean architecture** with layers:
  - presentation → application → domain → data

### Modeling and serialization
- **Freezed** for immutable models and unions where beneficial
- **json_serializable** for structured serialization support

### Persistence
- **Drift** as the local database and primary source of truth
- **SharedPreferences** for lightweight app settings and simple flags

### Device integrations
- **flutter_local_notifications** for local notification delivery
- **workmanager** for background reminder refresh where supported
- **home_widget** for Android widget bridge work in premium scope

### Supporting packages
- **timezone** for timezone-safe scheduling behavior
- **intl** for date and currency presentation
- **collection** for safe list/map helpers
- **pdf** and **printing** for export features

## Why This Decision

### Why Flutter
- one codebase fits the Android-first MVP while preserving future iOS expansion
- fast UI iteration and strong ecosystem support
- good fit for calendar-heavy, form-heavy, stateful apps

### Why Riverpod
- clean provider composition for features and repositories
- test-friendly dependency overrides
- better long-term structure than tightly coupled widget state for a rules-heavy app

### Why GoRouter
- explicit route setup for onboarding, jobs, calendar, pay, reminders, export, and settings
- supports future deep-linking and guarded routes more cleanly than ad hoc navigation

### Why Drift over Isar
- the app has relational data and derived queries across jobs, patterns, instances, pay rules, and reminders
- Drift provides better migration control and SQL clarity for complex summaries and filters
- export, reporting, and future reconciliation flows are easier with explicit query control

### Why clean architecture
- schedule and pay logic must remain framework-agnostic and highly testable
- it reduces risk when business rules become more complex
- it protects the core rules from UI churn and platform-specific integrations

## Alternatives Considered

### Provider or Bloc instead of Riverpod
- rejected for MVP because Riverpod provides simpler dependency injection and scalable test overrides with less ceremony

### Isar instead of Drift
- rejected because relational reporting and future summary queries are a stronger fit for Drift

### Hive-only persistence
- rejected because settings are simple, but core source-of-truth data needs richer querying and migrations

### UI-driven business logic
- rejected because schedule expansion and pay rules must live in pure Dart services with unit test coverage

## Consequences

### Positive
- clear testing boundaries
- scalable data layer for future complexity
- better support for deterministic schedule and pay logic
- easier long-term maintenance

### Trade-offs
- more initial setup than a minimal Flutter starter
- Drift and code generation add build tooling overhead
- clean architecture requires discipline to avoid leaking concerns across layers

## Implementation Notes
- store money as integer minor units only
- store durations in minutes only
- keep repositories as abstractions over Drift and preference storage
- keep notification and widget behavior behind service interfaces
- keep entitlement checks centralized
