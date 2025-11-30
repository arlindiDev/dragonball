# Dragon Ball Characters App - Implementation Plan

## Project Overview
Build a Flutter app that displays Dragon Ball characters using Clean Architecture and BLoC pattern.

**API Base:** `https://web.dragonball-api.com/`

**Key Requirements:**
- Character list with pagination (20 items per page)
- Character detail screen
- Clean Architecture structure
- BLoC state management
- Error handling & loading states
- Smooth navigation

---

## Implementation Steps

### Phase 1: Project Setup & Cleanup
**Commit 1: Clean up Flutter boilerplate**
- [ ] Remove `widget_test.dart` from test folder
- [ ] Clear `main.dart` to minimal structure
- [ ] Update `pubspec.yaml` with project description
- [ ] Update `readme.md` with project information

**Commit 2: Add dependencies**
- [ ] Add required packages to `pubspec.yaml`:
  - `flutter_bloc` (state management)
  - `equatable` (value equality for BLoC)
  - `http` or `dio` (networking)
  - `get_it` (dependency injection)
  - `dartz` (functional programming for error handling)
- [ ] Run `flutter pub get`

---

### Phase 2: Project Structure Setup
**Commit 3: Create Clean Architecture folder structure**
```
lib/
├── core/
│   ├── error/
│   ├── network/
│   ├── usecases/
│   └── utils/
├── features/
│   └── characters/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           ├── pages/
│           └── widgets/
└── injection_container.dart
```
- [ ] Create all folder structure
- [ ] Add `.gitkeep` files or empty dart files to preserve structure

---

### Phase 3: Core Layer Implementation
**Commit 4: Core utilities and error handling**
- [ ] `core/error/failures.dart` - Define failure classes
- [ ] `core/error/exceptions.dart` - Define exception classes
- [ ] `core/usecases/usecase.dart` - Base usecase interface
- [ ] `core/network/network_info.dart` - Network connectivity checker (if needed)

**Commit 5: Core constants and utilities**
- [ ] `core/utils/constants.dart` - API URLs and constants
- [ ] `core/network/api_client.dart` - Base HTTP client setup

---

### Phase 4: Domain Layer (Business Logic)
**Commit 6: Domain entities**
- [ ] `features/characters/domain/entities/character.dart` - Character entity
- [ ] `features/characters/domain/entities/planet.dart` - Planet entity
- [ ] `features/characters/domain/entities/transformation.dart` - Transformation entity
- [ ] `features/characters/domain/entities/character_detail.dart` - Character detail entity

**Commit 7: Domain repository interface**
- [ ] `features/characters/domain/repositories/character_repository.dart` - Abstract repository

**Commit 8: Domain use cases**
- [ ] `features/characters/domain/usecases/get_characters.dart` - Get paginated characters
- [ ] `features/characters/domain/usecases/get_character_detail.dart` - Get character by ID

---

### Phase 5: Data Layer (API & Models)
**Commit 9: Data models**
- [ ] `features/characters/data/models/character_model.dart` - Character model with JSON serialization
- [ ] `features/characters/data/models/planet_model.dart` - Planet model
- [ ] `features/characters/data/models/transformation_model.dart` - Transformation model
- [ ] `features/characters/data/models/character_detail_model.dart` - Character detail model
- [ ] Add `fromJson` and `toEntity` methods

**Commit 10: Remote data source**
- [ ] `features/characters/data/datasources/character_remote_datasource.dart` - Abstract interface
- [ ] `features/characters/data/datasources/character_remote_datasource_impl.dart` - HTTP implementation
- [ ] Implement API calls:
  - `GET /characters?page={page}&limit=20`
  - `GET /characters/{id}`

**Commit 11: Repository implementation**
- [ ] `features/characters/data/repositories/character_repository_impl.dart`
- [ ] Implement error handling (try-catch, convert exceptions to failures)
- [ ] Return `Either<Failure, Success>` using dartz

---

### Phase 6: Presentation Layer - BLoC
**Commit 12: Character list BLoC - Events**
- [ ] `features/characters/presentation/bloc/character_list/character_list_event.dart`
- [ ] Events:
  - `LoadCharacters` (initial load)
  - `LoadMoreCharacters` (pagination)
  - `RefreshCharacters` (pull to refresh)

**Commit 13: Character list BLoC - States**
- [ ] `features/characters/presentation/bloc/character_list/character_list_state.dart`
- [ ] States:
  - `CharacterListInitial`
  - `CharacterListLoading`
  - `CharacterListLoaded` (with list and hasMore flag)
  - `CharacterListError`

**Commit 14: Character list BLoC - Implementation**
- [ ] `features/characters/presentation/bloc/character_list/character_list_bloc.dart`
- [ ] Implement event handlers
- [ ] Handle pagination logic (page number, hasMore)
- [ ] Error handling

**Commit 15: Character detail BLoC - Complete**
- [ ] `features/characters/presentation/bloc/character_detail/character_detail_event.dart`
- [ ] `features/characters/presentation/bloc/character_detail/character_detail_state.dart`
- [ ] `features/characters/presentation/bloc/character_detail/character_detail_bloc.dart`
- [ ] Events: `LoadCharacterDetail`
- [ ] States: Initial, Loading, Loaded, Error

---

### Phase 7: Presentation Layer - UI Widgets
**Commit 16: Character list widgets**
- [ ] `features/characters/presentation/widgets/character_list_item.dart` - List item card
- [ ] `features/characters/presentation/widgets/loading_indicator.dart` - Loading widget
- [ ] `features/characters/presentation/widgets/error_widget.dart` - Error display with retry

**Commit 17: Character detail widgets**
- [ ] `features/characters/presentation/widgets/character_info_section.dart` - Info display
- [ ] `features/characters/presentation/widgets/transformation_list.dart` - Transformations
- [ ] `features/characters/presentation/widgets/planet_info.dart` - Planet info

---

### Phase 8: Presentation Layer - Pages
**Commit 18: Character list page**
- [ ] `features/characters/presentation/pages/character_list_page.dart`
- [ ] Implement BlocProvider and BlocBuilder
- [ ] ListView with pagination (scroll listener)
- [ ] Pull to refresh
- [ ] Loading states
- [ ] Error states with retry
- [ ] Navigate to detail on tap

**Commit 19: Character detail page**
- [ ] `features/characters/presentation/pages/character_detail_page.dart`
- [ ] Implement BlocProvider and BlocBuilder
- [ ] Display character information
- [ ] Display origin planet
- [ ] Display transformations list
- [ ] Handle empty transformations
- [ ] Loading and error states

---

### Phase 9: Dependency Injection & Routing
**Commit 20: Dependency injection setup**
- [ ] `injection_container.dart`
- [ ] Register all dependencies:
  - Data sources
  - Repositories
  - Use cases
  - BLoCs (as factories)
- [ ] Initialize in main.dart

**Commit 21: App routing and main setup**
- [ ] Update `main.dart`:
  - Initialize dependency injection
  - Setup MaterialApp with routes
  - Define theme
- [ ] Setup navigation between list and detail pages
- [ ] Pass character ID to detail page

---

### Phase 10: Polish & Improvements
**Commit 22: UI/UX polish**
- [ ] Add app theme (colors, text styles)
- [ ] Add hero animations for character images
- [ ] Improve card designs
- [ ] Add proper spacing and padding
- [ ] Optimize images with caching

**Commit 23: Error handling improvements**
- [ ] Better error messages
- [ ] Network error handling
- [ ] Empty state handling
- [ ] Retry mechanisms

**Commit 24: Testing preparation**
- [ ] Add documentation comments
- [ ] Clean up code
- [ ] Add TODO for future tests
- [ ] Verify pagination works correctly
- [ ] Test error scenarios

---

### Phase 11: Documentation & Final Touches
**Commit 25: Update README**
- [ ] Project description
- [ ] Features list
- [ ] Architecture explanation
- [ ] Setup instructions
- [ ] Screenshots (optional)
- [ ] API reference

**Commit 26: Final cleanup**
- [ ] Remove unused imports
- [ ] Format code (`flutter format .`)
- [ ] Run analysis (`flutter analyze`)
- [ ] Fix any warnings
- [ ] Final testing

---

## Architecture Overview

### Clean Architecture Layers

**Domain Layer (Business Logic)**
- Entities: Pure Dart classes, framework independent
- Repository Interfaces: Contracts for data operations
- Use Cases: Single responsibility business logic units

**Data Layer (Data Sources)**
- Models: JSON serialization/deserialization
- Repository Implementations: Implement domain contracts
- Data Sources: API calls, database operations

**Presentation Layer (UI)**
- BLoC: State management, business logic orchestration
- Pages: Full screens
- Widgets: Reusable UI components

### Key Design Patterns
- **Repository Pattern**: Abstract data sources
- **Use Case Pattern**: Single responsibility principle
- **BLoC Pattern**: Predictable state management
- **Dependency Injection**: Loose coupling, testability

### Data Flow
```
UI → BLoC → Use Case → Repository Interface → Repository Implementation → Data Source → API
                                                                              ↓
UI ← BLoC ← Use Case ← Repository Interface ← Repository Implementation ← Response
```

---

## Testing Strategy (Future Work)
- Unit tests for use cases
- Unit tests for BLoCs
- Unit tests for repositories
- Widget tests for UI components
- Integration tests for complete flows

---

## Notes
- Each commit should be atomic and functional
- Run `flutter analyze` before each commit
- Test the app after major features
- Keep commits focused and well-described
- Use meaningful commit messages

---

## Estimated Timeline
- Phase 1: ~30 min
- Phase 2: ~15 min
- Phase 3: ~30 min
- Phase 4: ~45 min
- Phase 5: ~1.5 hours
- Phase 6: ~1.5 hours
- Phase 7: ~1 hour
- Phase 8: ~1.5 hours
- Phase 9: ~45 min
- Phase 10: ~1 hour
- Phase 11: ~30 min

**Total: ~9-10 hours**

---

## Success Criteria
✅ App displays paginated list of characters
✅ Tapping character navigates to detail screen
✅ Detail screen shows name, description, planet, transformations
✅ Proper loading states
✅ Error handling with retry
✅ Clean architecture maintained
✅ BLoC pattern correctly implemented
✅ Code is well-organized and documented

