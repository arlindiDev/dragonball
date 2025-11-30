# Dragon Ball Characters App

A Flutter application that displays Dragon Ball characters from the Dragon Ball API using Clean Architecture and BLoC state management pattern.

## Features

- View a paginated list of Dragon Ball characters (20 at a time)
- Tap on any character to see detailed information
- View character's origin planet and transformations
- Clean Architecture with proper separation of concerns
- BLoC pattern for predictable state management
- Error handling and loading states

## Architecture

This project follows Clean Architecture principles with three main layers:

- **Domain Layer**: Business logic, entities, and repository interfaces
- **Data Layer**: API calls, data models, and repository implementations
- **Presentation Layer**: UI, widgets, and BLoC state management

## API

This app uses the Dragon Ball API: https://web.dragonball-api.com/

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Dependencies

- `flutter_bloc`: State management
- `equatable`: Value equality
- `dio`: HTTP client
- `get_it`: Dependency injection
- `dartz`: Functional programming

## Development Status

🚧 Work in Progress - Following Clean Architecture implementation plan
