# Dragon Ball App - Architecture Documentation

This document provides a comprehensive visual guide to the architecture and data flow of the Dragon Ball Characters application.

## Table of Contents
- [Overview](#overview)
- [Clean Architecture Layers](#clean-architecture-layers)
- [Data Flow](#data-flow)
- [Component Structure](#component-structure)
- [State Management](#state-management)

---

## Overview

This application follows **Clean Architecture** principles with three distinct layers:
- **Presentation Layer** (UI & State Management)
- **Domain Layer** (Business Logic)
- **Data Layer** (External Data Sources)

---

## Clean Architecture Layers

```mermaid
graph TB
    subgraph "Presentation Layer"
        UI[UI Screens & Widgets]
        BLoC[BLoC State Management]
        UI -->|User Events| BLoC
        BLoC -->|UI States| UI
    end

    subgraph "Domain Layer - Business Logic"
        UseCases[Use Cases]
        Entities[Domain Entities]
        RepoInterface[Repository Interface]
        UseCases -->|Uses| RepoInterface
        UseCases -->|Returns| Entities
    end

    subgraph "Data Layer"
        RepoImpl[Repository Implementation]
        DataSource[Remote Data Source]
        Models[Data Models]
        
        RepoImpl -->|Calls| DataSource
        DataSource -->|Returns JSON| Models
        Models -->|Converts to| Entities
        RepoImpl -->|Implements| RepoInterface
    end

    subgraph "External"
        API[Dragon Ball API]
        DataSource -->|HTTP Requests| API
    end

    subgraph "Core"
        DI[Dependency Injection]
        ErrorHandling[Error Handling]
        Result[Result Type]
        Theme[UI Theme]
        Widgets[Reusable Widgets]
    end

    BLoC -->|Calls| UseCases
    DI -.->|Provides| BLoC
    DI -.->|Provides| UseCases
    DI -.->|Provides| RepoImpl
    RepoImpl -->|Uses| ErrorHandling
    RepoImpl -->|Returns| Result
    UI -->|Uses| Theme
    UI -->|Uses| Widgets

    style UI fill:#4A90E2
    style BLoC fill:#4A90E2
    style UseCases fill:#50C878
    style Entities fill:#50C878
    style RepoInterface fill:#50C878
    style RepoImpl fill:#F39C12
    style DataSource fill:#F39C12
    style Models fill:#F39C12
    style API fill:#E74C3C
    style DI fill:#9B59B6
    style ErrorHandling fill:#9B59B6
    style Result fill:#9B59B6
    style Theme fill:#9B59B6
    style Widgets fill:#9B59B6
```

### Layer Responsibilities

#### 🔵 Presentation Layer
- **UI Components**: Screens, widgets, custom painters
- **State Management**: BLoC pattern for managing UI state
- **User Interactions**: Handling taps, scrolls, navigation

#### 🟢 Domain Layer (Core Business Logic)
- **Entities**: Pure business objects (Character, Planet, etc.)
- **Use Cases**: Application-specific business rules
- **Repository Interfaces**: Contracts for data operations

#### 🟠 Data Layer
- **Repository Implementations**: Concrete data access logic
- **Data Sources**: API communication (Remote) or local storage
- **Data Models**: JSON serialization/deserialization

#### 🟣 Core Layer
- **Dependency Injection**: GetIt service locator
- **Error Handling**: Custom exceptions and failures
- **Shared Utilities**: Reusable widgets, themes, constants

---

## Data Flow

This sequence diagram shows how data flows through the application from user interaction to API call and back:

```mermaid
sequenceDiagram
    participant U as User
    participant UI as Character List Screen
    participant B as CharacterListBloc
    participant UC as GetCharacters UseCase
    participant R as CharacterRepository
    participant DS as RemoteDataSource
    participant API as Dragon Ball API

    U->>UI: Opens App
    UI->>B: LoadCharacters Event
    B->>B: Emit Loading State
    B->>UC: Execute(page, limit)
    UC->>R: getCharacters(page, limit)
    R->>DS: getCharacters(page, limit)
    DS->>API: HTTP GET /characters
    API-->>DS: JSON Response
    DS-->>R: Map<String, dynamic>
    R->>R: Parse to Models
    R->>R: Convert to Entities
    R-->>UC: Result<Success/Failure>
    UC-->>B: CharacterListResult
    B->>B: Emit Loaded State
    B-->>UI: Update State
    UI-->>U: Display Characters

    U->>UI: Scrolls to 80%
    UI->>B: LoadMoreCharacters Event
    Note over B: Same flow for next page
```

### Data Transformation Journey

1. **API Response** (JSON) → Raw data from Dragon Ball API
2. **Data Models** → Parsed JSON with type safety
3. **Domain Entities** → Pure business objects
4. **BLoC State** → UI-ready data with loading/error states
5. **UI Widgets** → Visual representation

---

## Component Structure

This diagram shows the detailed architecture of the Characters feature:

```mermaid
graph LR
    subgraph "Characters Feature"
        subgraph "Presentation"
            CharListScreen[Character List Screen]
            CharDetailScreen[Character Detail Screen]
            CharCard[Character Card Widget]
            CharListBloc[Character List BLoC]
            CharDetailBloc[Character Detail BLoC]
        end

        subgraph "Domain"
            GetChars[Get Characters UseCase]
            GetDetail[Get Character Detail UseCase]
            CharEntity[Character Entity]
            CharDetailEntity[Character Detail Entity]
            CharRepo[Character Repository Interface]
        end

        subgraph "Data"
            CharRepoImpl[Character Repository Impl]
            RemoteDS[Remote Data Source]
            CharModel[Character Model]
            CharDetailModel[Character Detail Model]
        end
    end

    CharListScreen --> CharListBloc
    CharDetailScreen --> CharDetailBloc
    CharListScreen --> CharCard
    
    CharListBloc --> GetChars
    CharDetailBloc --> GetDetail
    
    GetChars --> CharRepo
    GetDetail --> CharRepo
    
    CharRepo -.implements.- CharRepoImpl
    CharRepoImpl --> RemoteDS
    
    RemoteDS --> CharModel
    RemoteDS --> CharDetailModel
    
    CharModel -.converts to.- CharEntity
    CharDetailModel -.converts to.- CharDetailEntity

    style CharListScreen fill:#4A90E2
    style CharDetailScreen fill:#4A90E2
    style CharCard fill:#4A90E2
    style CharListBloc fill:#4A90E2
    style CharDetailBloc fill:#4A90E2
    style GetChars fill:#50C878
    style GetDetail fill:#50C878
    style CharEntity fill:#50C878
    style CharDetailEntity fill:#50C878
    style CharRepo fill:#50C878
    style CharRepoImpl fill:#F39C12
    style RemoteDS fill:#F39C12
    style CharModel fill:#F39C12
    style CharDetailModel fill:#F39C12
```

### Component Relationships

- **Screens** depend on **BLoCs** for state management
- **BLoCs** depend on **Use Cases** for business logic
- **Use Cases** depend on **Repository Interfaces** (not implementations)
- **Repository Implementations** depend on **Data Sources**
- **Data Models** convert to **Domain Entities**

---

## State Management

BLoC (Business Logic Component) pattern manages all UI states:

```mermaid
stateDiagram-v2
    [*] --> CharacterListInitial
    
    CharacterListInitial --> CharacterListLoading: LoadCharacters
    
    CharacterListLoading --> CharacterListLoaded: Success
    CharacterListLoading --> CharacterListError: Failure
    
    CharacterListLoaded --> CharacterListLoadingMore: LoadMoreCharacters
    CharacterListLoaded --> CharacterListLoading: RefreshCharacters
    
    CharacterListLoadingMore --> CharacterListLoaded: Success
    CharacterListLoadingMore --> CharacterListError: Failure
    
    CharacterListError --> CharacterListLoading: Retry
    
    note right of CharacterListInitial
        Initial state when
        BLoC is created
    end note
    
    note right of CharacterListLoaded
        Contains:
        - characters list
        - hasMore flag
        - currentPage
        - isLoadingMore flag
    end note
    
    note right of CharacterListError
        Contains:
        - error message
        - allows retry
    end note
    
    note right of CharacterListLoadingMore
        Loading next page
        while showing current
        characters
    end note
```

### Character Detail BLoC States

```mermaid
stateDiagram-v2
    [*] --> CharacterDetailInitial
    
    CharacterDetailInitial --> CharacterDetailLoading: LoadCharacterDetail
    
    CharacterDetailLoading --> CharacterDetailLoaded: Success
    CharacterDetailLoading --> CharacterDetailError: Failure
    
    CharacterDetailError --> CharacterDetailLoading: Retry
    
    CharacterDetailLoaded --> [*]: Navigate Back
    
    note right of CharacterDetailLoaded
        Contains:
        - Full character details
        - Transformations
        - Origin planet
        - Stats (Ki, Max Ki)
    end note
```

---

## Dependency Injection Flow

```mermaid
graph TD
    Main[main.dart] -->|Initializes| DI[Dependency Injection]
    
    DI -->|Registers| Dio[Dio HTTP Client]
    DI -->|Registers| DataSource[Remote Data Source]
    DI -->|Registers| Repo[Character Repository]
    DI -->|Registers| UC1[GetCharacters UseCase]
    DI -->|Registers| UC2[GetCharacterDetail UseCase]
    DI -->|Factory| BLoC1[CharacterListBloc]
    DI -->|Factory| BLoC2[CharacterDetailBloc]
    
    Dio -.->|Used by| DataSource
    DataSource -.->|Used by| Repo
    Repo -.->|Used by| UC1
    Repo -.->|Used by| UC2
    UC1 -.->|Injected into| BLoC1
    UC2 -.->|Injected into| BLoC2
    
    Screen1[Character List Screen] -->|Gets| BLoC1
    Screen2[Character Detail Screen] -->|Gets| BLoC2
    
    style Main fill:#E74C3C
    style DI fill:#9B59B6
    style Screen1 fill:#4A90E2
    style Screen2 fill:#4A90E2
    style BLoC1 fill:#4A90E2
    style BLoC2 fill:#4A90E2
    style UC1 fill:#50C878
    style UC2 fill:#50C878
    style Repo fill:#F39C12
    style DataSource fill:#F39C12
    style Dio fill:#F39C12
```

---

## Error Handling Flow

```mermaid
graph TD
    API[API Call] -->|Success| Parse[Parse Response]
    API -->|DioException| ErrorHandler[Error Handler]
    
    Parse -->|Success| Model[Create Model]
    Parse -->|Exception| ErrorHandler
    
    Model -->|Success| Entity[Convert to Entity]
    Model -->|Exception| ErrorHandler
    
    Entity -->|Success| SuccessResult[Result.success]
    
    ErrorHandler -->|Network Error| NetworkFailure[NetworkFailure]
    ErrorHandler -->|Server Error| ServerFailure[ServerFailure]
    ErrorHandler -->|Unknown Error| ServerFailure
    
    NetworkFailure --> ErrorResult[Result.error]
    ServerFailure --> ErrorResult
    
    SuccessResult --> BLoC[BLoC State]
    ErrorResult --> BLoC
    
    BLoC -->|Success| LoadedState[Loaded State]
    BLoC -->|Error| ErrorState[Error State]
    
    LoadedState --> UI[Display Data]
    ErrorState --> ErrorUI[Show Error + Retry]
    
    style SuccessResult fill:#50C878
    style ErrorResult fill:#E74C3C
    style LoadedState fill:#50C878
    style ErrorState fill:#E74C3C
    style UI fill:#4A90E2
    style ErrorUI fill:#E74C3C
```

---

## Folder Structure Visualization

```mermaid
graph TD
    Root[lib/] --> Core[core/]
    Root --> Features[features/]
    Root --> Main[main.dart]
    Root --> Routes[routes.dart]
    Root --> DI[injection_container.dart]
    
    Core --> Constants[constants/]
    Core --> Error[error/]
    Core --> Result[result/]
    Core --> UI[ui/]
    Core --> UseCases[usecases/]
    
    Features --> Characters[characters/]
    
    Characters --> Data[data/]
    Characters --> Domain[domain/]
    Characters --> Presentation[presentation/]
    
    Data --> DataSources[datasources/]
    Data --> Models[models/]
    Data --> Repositories[repositories/]
    
    Domain --> Entities[entities/]
    Domain --> DomainRepos[repositories/]
    Domain --> DomainUseCases[usecases/]
    
    Presentation --> BLoC[bloc/]
    Presentation --> PresentationUI[ui/]
    
    PresentationUI --> Screens[screens/]
    PresentationUI --> Widgets[widgets/]
    PresentationUI --> Painters[painters/]
    
    style Core fill:#9B59B6
    style Data fill:#F39C12
    style Domain fill:#50C878
    style Presentation fill:#4A90E2
    style Features fill:#34495E
```

---

## Key Design Principles

### 1. Dependency Rule
- Dependencies point inward (outer layers depend on inner layers)
- Domain layer has no dependencies on outer layers
- Data and Presentation layers depend on Domain layer

### 2. Single Responsibility
- Each class has one reason to change
- BLoCs handle state management only
- Use Cases handle business logic only
- Repositories handle data access only

### 3. Dependency Inversion
- High-level modules don't depend on low-level modules
- Both depend on abstractions (interfaces)
- Repository interface in Domain, implementation in Data

### 4. Open/Closed Principle
- Open for extension (add new features easily)
- Closed for modification (don't break existing code)

---
