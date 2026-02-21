# swift-app

A demonstration project showcasing my approach to building scalable, testable, and maintainable Swift apps via Clean architecture

<video src="https://github.com/user-attachments/assets/2b6c6402-172e-4fb9-b2ff-78b75917c27c" width="352" height="720"></video>

## Architecture

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

### Dependency Injection

- The main architectural dependency injection (services) is implemented via protocols (see DependencyInjection.swift). ViewModels do not know anything about the concrete implementations of services - only about the service protocols
- There are also observable classes with purely view-related responsibilities, such as navigation, error presentation, and logging user events to an analytics service. These classes are needed only in the Presentation layer, so no additional abstraction is required. They are injected only into the UI and registered using Swift’s EnvironmentKeys. (see EnvironmentValues.swift)

### Navigation / Coordinator

- Coordinator is implemented using SwiftUI's NavigationStack in the main AppView. All application routes are declared in Routes.swift, and page construction and navigation logic are handled in Coordinator.swift

### Error handling

- There 2 types of errors in this project - API (data) and App (domain)
- For API errors, in real project I would implement an interceptor that catches and maps server responses to App (domain) errors
- App errors help enforce separation between layers, and their localization should be handled in the Presentation layer
- AppView is wrapped with ErrorOverlay, which is responsible for displaying one toast at a time
- The ErrorHandler is stored in the environment and should be injected into views where errors may be thrown

## Pages

- List of characters with pagination, search & filters
- Settings to change localization, theme and reset all settings
- OnBoarding just to show another main app route switching :) 

## Core capabilities

- API client
- Network connectivity checker
- System/Dark/Light theme switch
- Localization
- Analytics logger

## TODO:

- Add additional SwiftLint rules
- Flavors
- Snapshot tests?
