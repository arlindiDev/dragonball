# Dragon Ball Characters App

A Flutter application showcasing Dragon Ball characters with Clean Architecture, BLoC state management, and custom animations.

## Demo

https://github.com/user-attachments/assets/screenrecording.mp4

☝️ **See the demo screen recording** ☝️


## Architecture & Code Structure

This project follows **Clean Architecture** with clear separation of concerns across three layers:

1. **Data Layer** - External data sources (API calls, models, repository implementations)
2. **Domain Layer** - Business logic (entities, use cases, repository contracts)
3. **Presentation Layer** - UI and state management (BLoC, screens, widgets)

### Folder Structure
```
lib/
├── core/                          # Shared utilities & UI components
│   ├── constants/                 # API endpoints and constants
│   ├── error/                     # Error handling (Failures & Exceptions)
│   ├── result/                    # Result type for error handling
│   ├── ui/theme/                  # Colors and theme configuration
│   ├── usecases/                  # Base UseCase interface
│   └── widgets/                   # Reusable widgets (loaders, skeletons)
│
├── features/characters/           # Characters feature module
│   ├── data/                      # Data Layer
│   │   ├── datasources/           # API data sources
│   │   ├── models/                # Data models with JSON serialization
│   │   └── repositories/          # Repository implementations
│   │
│   ├── domain/                    # Domain Layer (Business Logic)
│   │   ├── entities/              # Pure business entities
│   │   ├── repositories/          # Repository contracts
│   │   └── usecases/              # Business use cases
│   │
│   └── presentation/              # Presentation Layer
│       ├── bloc/                  # BLoC state management
│       └── ui/
│           ├── painters/          # Custom painters for animations
│           ├── screens/           # Screen widgets
│           └── widgets/           # UI components
│               ├── list/          # List screen components
│               └── details/       # Detail screen components
│
├── injection_container.dart       # Dependency injection setup
├── main.dart                      # App entry point
└── routes.dart                    # Navigation routes
```

### Technologies Used
- **Flutter & Dart** - UI framework
- **BLoC (flutter_bloc)** - State management
- **Dio** - HTTP client for API calls
- **GetIt** - Dependency injection
- **Equatable** - Value equality
- **Shimmer** - Loading skeleton animations

### Key Architecture Patterns
1. **Clean Architecture**: Separation between data, domain, and presentation layers
2. **Repository Pattern**: Abstracts data sources from business logic
3. **BLoC Pattern**: Manages UI state predictably
4. **Dependency Injection**: Uses GetIt for loose coupling
5. **Error Handling**: Custom Failure types with Either (Result) pattern


### Data Models vs Entities

**Note**: While JSON data models and business entities have the same properties in this app, they're kept separate for scalability. In larger apps, entities often need additional properties not from the API (computed values, UI state, favorites) or can be combinations of multiple models. This separation maintains clean architecture and allows API changes without impacting business logic.

## UI Features

### Character List Screen

**Features:**
- **Initial Loading**: Displays a card shimmer skeleton while fetching data
- **Character Cards**: Animated cards with:
  - Floating animation effect (moves up/down)
  - Pulsing glow aura around character images
  - Hero animation for smooth transitions
  - Power level (Ki) badges
  - Character names with gradient text
  - Dynamic color gradients based on character ID
- **Load More**: Automatically loads next page when scrolling to 80% of list
- **Pull to Refresh**: Swipe down to refresh the entire list
- **Error Handling**: Shows error view with retry button on failure
- **Pagination**: Loads 20 characters per page

### Character Detail Screen

**Features:**
- **Initial Loading**: Custom Dragon Ball rotating loader animation
- **Character Details**: Displays comprehensive information including:
  - Large hero image with animated energy particles
  - Name with gradient styling
  - Description
  - Gender, race, and affiliation badges
  - Power level (Ki) and Max Ki stats
- **Origin Planet Section**: Shows planet details with custom styling
- **Transformations**: List of character transformations with color-coded badges
- **Animated Background**: Dynamic gradient background with energy effects
- **Custom Back Button**: Themed back button with border glow
- **Error Handling**: Error view with retry functionality
- **Hero Animation**: Smooth image transition from list to detail

## Color Coding System

Characters are assigned dynamic colors based on their ID using a modulo pattern:

```
Character ID % 5:
├── 0 → Orange Gradient   (#FF6B00 → #FF8C00)
├── 1 → Blue Gradient     (#0066CC → #0099FF)
├── 2 → Purple Gradient   (#9900CC → #CC00FF)
├── 3 → Green Gradient    (#00CC66 → #00FF99)
└── 4 → Red Gradient      (#CC0000 → #FF3333)
```

**Transformation Colors** (rotated by index):
- Gold (#FFD700)
- Cyan (#00FFFF)
- Magenta (#FF00FF)
- Lime (#00FF00)
- Deep Pink (#FF1493)

# What Should Be Added in a Real Production App

### 1. **Internationalization**
- Support multiple languages
- Extract all hardcoded strings to translation files
- Consider RTL layout support

### 2. **Design System & Reusable UI Components**
```
lib/core/ui/
├── components/           # Atomic design components
│   ├── atoms/           # Buttons, text inputs, badges
│   ├── molecules/       # Cards, form groups
│   └── organisms/       # Complex components
├── theme/
│   ├── spacing.dart     # Consistent padding/margin values
│   ├── typography.dart  # Font styles and weights
│   ├── dimensions.dart  # Responsive sizing
│   └── colors.dart      # Extended color palette
```

### 3. **Responsive Design System**
- Create `AppDimensions` class with responsive values
- Support multiple screen sizes (mobile, tablet, desktop)
- Use `LayoutBuilder` and `MediaQuery` effectively
- Define breakpoints for different devices
```dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}
```

### 4. **Typography System**
- Define font families and load custom fonts
- Create consistent text styles hierarchy
- Support different font weights
- Implement responsive font scaling
```dart
class AppTextStyles {
  static TextStyle h1 = TextStyle(...);
  static TextStyle h2 = TextStyle(...);
  static TextStyle body = TextStyle(...);
  static TextStyle caption = TextStyle(...);
}
```

### 5. **Testing**

**Unit Tests:**
- Test BLoC logic (events → states)
- Test use cases
- Test repository implementations
- Test data models serialization/deserialization

**Widget Tests:**
- Test UI components in isolation
- Test state transitions
- Test user interactions

### 7. **Image Caching & Loading**
- Implement proper image caching to reduce network calls
- Use packages like `cached_network_image` for efficient caching
- Add fade-in animations when images load
- Handle image loading errors with fallback images

### 8. **Analytics & Logging**
- Implement analytics tracking (Firebase Analytics, Mixpanel, etc.)
- Log errors and exceptions to crash reporting services (Sentry, Crashlytics)
- Add custom event tracking for key user actions


### 9. **Code Quality**
- Implement stricter linting rules
- Add pre-commit hooks, for example run flutter analyze
- Use code generation for boilerplate (freezed, json_serializable)
- Document complex business logic

---

**API**: [Dragon Ball API](https://web.dragonball-api.com/)
