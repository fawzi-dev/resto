# Resto — Restaurant Menu Management Panel

A single-screen Flutter application that lets a restaurant owner manage their
menu sections and food items. The UI is **fully RTL** and written in
**Central Kurdish (Sorani)**.

It is built as a portfolio piece: production-grade architecture, a polished and
pixel-conscious UI, and a real networking layer backed by an included mock REST
API.

---

## Highlights

- **Strict RTL layout** with a bundled **Vazirmatn** font for crisp Kurdish/Arabic script.
- **Real REST backend** — a bundled Dart (`shelf`) mock API with full CRUD, plus an in-memory fallback so the app also runs fully offline.
- **Live search** that filters the grid as you type.
- **Animated category filtering** that combines with search (AND).
- **Create / edit / delete over HTTP** — optimistic UI with rollback if the request fails; delete has confirmation + Undo.
- **Loading, empty, no-results and error states** — skeleton shimmer while data loads, friendly placeholders otherwise.
- **Cached, lazy network images** with graceful placeholder/error fallbacks.
- **Staggered entrance animations** and soft, consistent elevation throughout.

---

## Architecture

A layered, feature-first structure (a pragmatic take on Clean Architecture). The
presentation layer depends only on abstractions, so the data source can switch
between the in-memory fake and the live HTTP backend with a single binding.

```
.
├── lib/
│   ├── app/                        # Composition root
│   │   ├── app.dart                # MaterialApp: theme, RTL locale, providers
│   │   └── dependencies.dart       # DI graph + fake/HTTP data-source switch
│   ├── core/
│   │   ├── theme/                  # Colors, typography, spacing, ThemeData
│   │   ├── localization/           # Centralized Kurdish strings (ready for gen-l10n)
│   │   ├── network/                # ApiClient, ApiConfig, typed Failure
│   │   ├── utils/                  # Currency formatter, id generator
│   │   └── widgets/                # Reusable widgets (shimmer, network image…)
│   └── features/menu/
│       ├── domain/                 # Pure Dart: entities + repository interface
│       ├── data/                   # Models (JSON), data sources, repository impl
│       └── presentation/           # View model (ChangeNotifier), screen, widgets
└── mock_api/                       # Standalone Dart (shelf) REST server
```

### How the layers connect

```
MenuScreen ──watches──▶ MenuViewModel ──▶ MenuRepository (interface)
                                              │
                                       MenuRepositoryImpl ──▶ MenuRemoteDataSource (interface)
                                                                   ├── FakeMenuRemoteDataSource   (offline, in-memory)
                                                                   └── HttpMenuRemoteDataSource ──▶ ApiClient ──▶ mock_api
```

Only the data source differs between the two modes — everything above it is
identical, which is the whole point of the seam.

### Networking layer

- **`ApiClient`** ([core/network/api_client.dart](lib/core/network/api_client.dart)) —
  a thin wrapper over `http.Client`: builds requests, decodes JSON as UTF-8 (so
  Kurdish survives the round trip), enforces a timeout, and maps transport and
  HTTP-status errors onto a typed `Failure` (`NetworkFailure` / `ServerFailure`).
  The `http.Client` is injectable, so tests drive it with a `MockClient`.
- **Typed errors** flow up to the view model, which renders the error state for
  reads and rolls back optimistic writes for create/update/delete.
- **`MenuViewModel`** is a plain `ChangeNotifier` with no Flutter UI imports, so
  the business logic is unit-tested directly.

### State management & DI

[`provider`](https://pub.dev/packages/provider) handles both DI and state. The
graph is declared once in [`buildAppProviders`](lib/app/dependencies.dart) and
picks the data source from `ApiConfig`.

---

## Tech & decisions

| Concern        | Choice                          | Why |
|----------------|---------------------------------|-----|
| State / DI     | `provider` + `ChangeNotifier`   | Lightweight, idiomatic, testable; no codegen |
| HTTP           | `http` + a small `ApiClient`    | Enough for a clean REST client without pulling in a heavy framework |
| Mock backend   | Dart `shelf`                    | A real server in the same language; full CRUD recruiters can curl |
| Images         | `cached_network_image`          | Lazy loading + caching for smooth scrolling |
| Formatting     | `intl`                          | Locale-aware number grouping (`8,000 دینار`) |
| Font           | Vazirmatn (bundled)             | High-quality Sorani/Arabic rendering, offline |

---

## Getting started

### Offline (default)

Runs against the in-memory `FakeMenuRemoteDataSource` — no server needed.

```bash
flutter pub get
flutter run
```

### Against the live mock API

**1. Start the server** (separate terminal):

```bash
cd mock_api
dart pub get
dart run bin/server.dart          # http://localhost:8080
```

**2. Run the app pointed at it:**

```bash
# iOS simulator / desktop / web
flutter run --dart-define=USE_REMOTE_API=true --dart-define=API_BASE_URL=http://localhost:8080

# Android emulator (host is reachable at 10.0.2.2)
flutter run --dart-define=USE_REMOTE_API=true --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

Cleartext HTTP to localhost is enabled for debug builds only.

### API endpoints

| Method | Path                      | Purpose                     |
|--------|---------------------------|-----------------------------|
| GET    | `/categories`             | List sections               |
| POST   | `/categories`             | Create a section            |
| GET    | `/foods?category_id=`     | List foods (optional filter)|
| POST   | `/foods`                  | Create a food               |
| PUT    | `/foods/<id>`             | Update a food               |
| DELETE | `/foods/<id>`             | Delete a food               |

Quick check once the server is up:

```bash
curl http://localhost:8080/foods?category_id=pizza
dart run tool/api_smoke.dart      # drives the app's real client against the server
```

---

## Tests & analysis

```bash
flutter analyze   # clean
flutter test      # 24 tests
```

Coverage includes the `ApiClient` (success, query params, POST body, 4xx/5xx →
`Failure`, connection errors) with a mocked `http.Client`, the
`HttpMenuRemoteDataSource` endpoints, the view-model logic (load, filter, search,
optimistic create/update/delete + rollback + undo), and a widget smoke test.
