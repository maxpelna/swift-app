# swift-app

A demonstration project showcasing my approach to building scalable, testable, and maintainable Swift apps via Clean architecture, using the [Rick and Morty API](https://rickandmortyapi.com/api) as a data source

<video src="https://github.com/user-attachments/assets/2b6c6402-172e-4fb9-b2ff-78b75917c27c" width="352" height="720"></video>

## Requirements

- iOS 26.0+
- Xcode 26.0+
- Swift 6.0+

**Getting started:**
```
open swift-app.xcodeproj
```

**Available flavors (schemes):**

- `swift-app-release` - Production build
- `swift-app-staging` - Staging / QA build

Select the desired scheme via **Product → Scheme → Edit Scheme** and switch the build configuration accordingly.

**SwiftLint**

- Project uses SwiftLint for code styling and consistency

## Dependencies

- [Nuke](https://github.com/kean/Nuke) - added for image loading and caching instead of custom solution

## Pages

- Splash screen shown on launch and as overlay when user swipes away application
- Onboarding — shown to new users to demonstrate main app route switching
- List of characters with pagination, search & filters
- No-network screen shown when internet connection is unavailable
- Settings to change localization, theme and reset all settings
- Secret page available through deep-link `mpelna://secret`

## Architecture & Capabilities

There are three layers: Data, Domain, and Presentation (feature-based or screen-based). In the current app, the Domain layer is implemented without use cases, as this extra separation is optional for me. In a real app, I would implement use cases if there were multiple data sources - for example, persisted data and an API. This allows a use case to coordinate multiple services and decide which data to take, removing duplicated logic from ViewModels

### Layer responsibilities
- **Data**: DTOs, API clients and service implementations. Only knows about Domain layer
- **Domain**: Domain entities, business rules and service protocols. Lives separately from other layers
- **Presentation**: SwiftUI views, ViewModels (state & event handling), navigation coordinator, design system. Only knows about Domain layer

### State management

- For state management, I use an approach inspired by the BLoC package from Flutter (which is also similar to MVI). Each view has a state, events, and a handler class that processes user actions into an updated state. I use the ViewModel suffix for these classes in Swift, as it is more convenient for me
- ViewModels should not depend on UI frameworks (including SwiftUI) or handle localization. There should be a clear separation of concerns - ViewModel is responsible for business, logic and state, not UI rendering, or presentation details or navigation

### Data flow

Clean architecture ensures unidirectional data flow (one way) keeping UI, business logic, and data sources clearly separated, predictable, and easy to test:
- User Action (event) ->
- View ->
- ViewModel ->
- Abstract interface (protocol) ->
    - implementation is hidden (is known only for DI) and can be replaced with another one that conforms to the interface
- Updated state ->
- View

#### Data & Domain Modeling

- Clear domain models (not raw API models everywhere)
- Mapping layers defined (DTO → Domain → UI)

### Dependency Injection

- The main architectural dependency injection (services) is implemented via protocols (see DependencyInjection.swift). ViewModels do not know anything about the concrete implementations of services - only about the service protocols
- There are also observable classes with purely view-related responsibilities, such as navigation, error presentation, and logging user events to an analytics service. These classes are needed only in the Presentation layer, so no additional abstraction is required. They are injected only into the UI and registered using Swift's EnvironmentKeys. (see EnvironmentValues.swift)

### Navigation / Coordinator

- Coordinator is implemented using SwiftUI's NavigationStack in the main AppView 
- All application routes are declared in Routes.swift
- Page construction and navigation logic are handled in Coordinator.swift

### Error handling

- APIError (data) is mapped to AppError (domain) - this helps enforce separation between layers
- AppError localization is handled in the Presentation layer
- AppView is wrapped with ErrorOverlay, which is responsible for displaying one toast at a time
- The ErrorHandler is stored in the environment and should be injected into views where errors may be thrown

## Other capabilities

- API client is done with retry logic (3 times)
- System/Dark/Light theme switch
- Localization switch
- Design system elements + Layout constants
- Fresh install detection -> storage clearing
- Analytics logger

## Testing

Unit tests are written using Apple's [Swift Testing](https://developer.apple.com/xcode/swift-testing/) framework. The following ViewModels are covered:

- `AppViewModel`
- `CharactersListViewModel`
- `CharactersFiltersViewModel`
- `SettingsViewModel`
- `OnboardingViewModel`
