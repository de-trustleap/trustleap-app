# Finanzbegleiter (Trust Leap)

Flutter-Web-App für Finanzempfehlungen mit Promoter-System und Landing-Page-Builder.

## Architektur

**Clean Architecture mit BLoC-Pattern:**
```
presentation/ → application/ (Cubit/Bloc) → domain/ → infrastructure/
    UI              State-Mgmt           Entities    Firebase-Repos
```

- **State Management:** flutter_bloc
- **DI:** flutter_modular
- **Backend:** Firebase (Auth, Firestore, Storage, Functions)
- **Error Handling:** dartz Either<Failure, Success>

## Verzeichnisstruktur

| Verzeichnis | Inhalt |
|-------------|--------|
| `lib/presentation/` | Pages und Widgets |
| `lib/application/` | Cubits/Blocs für Features |
| `lib/domain/entities/` | Business-Objekte (CustomUser, Promoter, LandingPage) |
| `lib/domain/repositories/` | Abstrakte Repository-Interfaces |
| `lib/infrastructure/repositories/` | Firebase-Implementierungen |
| `lib/infrastructure/models/` | Firestore-Models mit toDomain() |
| `lib/core/modules/` | App-Module, Route-Guards (Auth, Admin) |
| `lib/constants.dart` | Globale Enums (Role, AuthStatus, MenuItems) |

## Befehle

```bash
# Tests
./scripts/flutter_test.sh

# Web-Build
./scripts/build_web.sh

# Lokalisierung generieren
flutter gen-l10n

# Mocks generieren
dart run build_runner build --delete-conflicting-outputs
```

## Environments

| Env | App-URL | Firebase-Projekt |
|-----|---------|------------------|
| Staging | staging.trust-leap.de | trustleap-staging |
| Prod | app.trust-leap.de | finanzwegbegleiter |

## Konventionen

- **Entities vs Models:** Entities sind reine Domain-Objekte, Models haben Firestore-Serialisierung
- **Repository-Pattern:** Abstraktion in domain/, Implementierung in infrastructure/
- **Fehlerbehandlung:** Immer Either<Failure, T> verwenden, nie Exceptions werfen
- **Widgets:** Responsive für Mobile/Tablet/Desktop (responsive_framework)
- **Sprache:** Lokalisierung (DE/EN) in `lib/l10n/`
- **Tests:** Bei neuen Tests an bestehenden vergleichbaren Tests im `test/`-Verzeichnis orientieren und deren Patterns übernehmen
- **Navigation:** CustomNavigator statt Navigator verwenden
- **Snackbars:** CustomSnackbar für alle Snackbar-Anzeigen nutzen
