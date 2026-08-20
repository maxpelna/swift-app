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

- `prod` - Production build
- `staging` - Staging / QA build

These flavors just for showcase purpose. Both have the same BASE_URL inside .xcconfig files.
API and analytics logging is compiled in via `#if DEBUG || STAGING`, so QA builds keep their logs
while production ships without them.

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
- **Presentation**: SwiftUI views, ViewModels (state & handlers), navigation coordinator, design system. Only knows about Domain layer

### State management

- Each screen has an `@Observable` ViewModel holding `private(set)` state and plain methods. State is only ever mutated inside the ViewModel; the view reads it and calls methods
- Derived values (`isLoading`, `isEmptyList`, `characters`) are computed on the ViewModel rather than assembled in the view, so the view stays layout-only
- ViewModels do not depend on UI frameworks (including SwiftUI) or handle localization. A ViewModel is responsible for state and logic, not for rendering, presentation details or navigation
- Loading state is modelled with `DelayedResult<T>` — an enum of `none / inProgress / success(T) / failure(Error)`, so a spinner and a stale value cannot coexist

### Data flow

Clean architecture ensures unidirectional data flow (one way) keeping UI, business logic, and data sources clearly separated, predictable, and easy to test:
- User action ->
- View ->
- ViewModel method ->
- Abstract interface (protocol) ->
    - implementation is hidden (is known only for DI) and can be replaced with another one that conforms to the interface
- Updated state ->
- View

#### Data & Domain Modeling

- Clear domain models (not raw API models everywhere)
- Mapping layers defined (DTO → Domain → UI)

### Dependency Injection

- The main architectural dependency injection (services) is implemented via protocols (see DependencyInjection.swift). ViewModels do not know anything about the concrete implementations of services - only about the service protocols
- There are also observable classes with purely view-related responsibilities — navigation (`Coordinator`) and error presentation (`ErrorHandler`). These are needed only in the Presentation layer, so no additional abstraction is required. They are `@Observable` and injected through the SwiftUI environment in `Main.swift`
- Services that hold state (`UserStatsService`, `ConnectivityService`) are `@Observable` too. A ViewModel exposes them as computed properties, and SwiftUI tracks the change through to the view — so there are no subscriptions, no cancellables and no manual refresh calls anywhere in the app

### Navigation / Coordinator

- Coordinator is implemented using SwiftUI's NavigationStack in the main AppView 
- All application routes are declared in Routes.swift
- Page construction and navigation logic are handled in Coordinator.swift

### Error handling

- `APIError` (data) is mapped to `AppError` (domain) - this helps enforce separation between layers
- `AppError` has only the cases the UI actually distinguishes — `emptyState`, `noConnection` and `caught(Error)`. The mapping wraps rather than discards, so an HTTP status code or a `URLError` survives into crash reporting instead of being flattened into a renamed category. The domain type still names only `Error`, never a transport type
- `AppError` localization is handled in the Presentation layer
- `AppView` is wrapped with `ErrorOverlay`, outside the `NavigationStack`, so one toast at a time is shown above whichever page is on screen
- Cancellation is not an error: it is filtered once in `ErrorHandler` and again in each loader, so a superseded request neither shows a toast nor overwrites state its successor owns

### Concurrency

- Swift 6 language mode with `SWIFT_STRICT_CONCURRENCY = complete` and `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`, so UI code is main-actor isolated by default and the exceptions are the interesting part
- **The view owns async lifetime.** ViewModels hold no `Task` handles. Work is started by `.task` / `.task(id:)`, which means SwiftUI cancels it when the screen goes away and restarts it when its inputs change. `.task(id: query)` is the whole restart-on-search-or-filter mechanism, and pagination is a `.task` on the last row
- **Restartable vs droppable is expressed per loader**, not globally: `reload()` is superseded by a newer query, `loadMore()` refuses re-entry while a page is in flight
- **Networking runs off the main actor.** `APIClient.performRequest` is `@concurrent`, so the request, the response logging and JSON decoding all happen on the cooperative pool rather than blocking the main thread. `nonisolated` alone would not be enough — under approachable concurrency a `nonisolated async` function still runs on the caller's executor
- No Combine anywhere. `ConnectivityService` iterates `NWPathMonitor` as an `AsyncSequence` and publishes the result as observable state, so consumers read `isConnected` rather than subscribing to anything

## Other capabilities

- API client is done with retry logic (3 times)
- System/Dark/Light theme switch
- Localization (English / Spanish), switched from the system Settings app
- Design system elements + Layout constants
- Analytics events logged from the presentation layer

## Testing

Unit tests are written using Swift Testing (`@Suite`, `@Test`, `#expect`). Covered:

- `AppViewModel` — splash gating, state derived from the stats service, connectivity
- `CharactersListViewModel` — loading, pagination, dedupe, search debounce, filters, and the cancellation/supersession rules
- `CharactersFiltersViewModel`, `SettingsViewModel`, `OnboardingViewModel`
- `ErrorHandler` — cancellation filtering, silent empty state, localization, and that the underlying error survives into reporting

Races are tested deterministically: the service mock exposes an `onRequest` hook that fires inside the
request, so a test can change state mid-flight without depending on task scheduling.
