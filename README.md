# Kaluga SwiftUI Tools
Tools for generating classes to easily link [Kaluga](https://github.com/splendo/kaluga) projects to SwiftUI.
Since Kotlin Multiplatform does not support Swift implementations, Kaluga does not offer full SwiftUI support.
Instead some bridging classes are required to use Kaluga properly.

Kaluga projects do not directly import Kaluga into the Swift project however, instead exposing dependencies though a project specific shared library.
Therefore, no proper Swift Framework can be offered to developers.

This library aims to resolve this issue by providing coding templates that generated Swift classes directly in the SwiftUI project.
These classes are generated using [Sourcery](https://github.com/krzysztofzablocki/Sourcery).

## Installation
Make sure latest version of Sourcery is [installed](https://github.com/krzysztofzablocki/Sourcery#installation) on your machine.

- Checkout this project as a submodule to your project
- Copy `template-kaluga.sourcery.yml` into the iOS folder of your shared code project and rename it to `kaluga.sourcery.yml`
- Open `kaluga.sourcery.yml` and change:
    - $XCODE_PROJECT_NAME to the name of your xcodeproj file
    - $TARGET_NAME to the name of the target in your project
    - $PATH_TO_SUBMODULE to the path of the submodule
    - $SHARED_FRAMEWORK_NAME to the name of the Kaluga-based Shared Framework
    - Configure features (see below)

### Manually

- Run `sourcery --config kaluga.sourcery.yml`
- If the partial sheet feature was enabled, add `https://github.com/AndreaMiotto/PartialSheet.git` as a Swift Package Dependency to your project.
- Import the files in `./KalugaSwiftUI` into your Xcode project.

### Automatic

- Add Sourcery as pods into your project (Optional)
- Add new Run Build Phase: `$PODS_ROOT/Sourcery/bin/sourcery --config kaluga.sourcery.yml`
- Uncomment `link` section inside `kaluga.sourcery.yml`

> Note code generation should go after multiplatform framework dependency

### Features
To enable or disable certain Kaluga features, update their corresponding settings in the `kaluga.sourcery.yml` file.
All features are enabled by default.

- __includeResources__: Set to `true` when `Kaluga.resources` is exported.
- __includeAlerts__: Set to `true` when `Kaluga.alerts` is exported.
- __includeHud__: Set to `true` when `Kaluga.hud` is exported.
- __includeDatePicker__: Set to `true` when `Kaluga.date-picker` is exported.
- __includePartialSheet__: Set to `true` when using [PartialSheet](https://github.com/AndreaMiotto/PartialSheet.git) navigation.

## Usage
### ViewModels
Kaluga ViewModels require a lifecycle to be maintained. This can be automated by wrapping the `ViewModel` in a `LifecycleViewModel`.
Use the wrappers body method to then display the viewModel in a lifecycle aware state.

```swift
struct SomeView: View {

    private let viewModel: LifecycleViewModel<SomeViewModel>

    init(_ someViewModel: SomeViewModel) {
        viewModel = LifecycleViewModel(viewModel: someViewModel)
    }

    var body: some View {
        viewModel.lifecycleView { viewModel in
            // Render View
            Text(viewModel.title)
        }
    }
}
```

### Alerts, HUD and DatePicker.
If `Kaluga.alerts`, `Kaluga.hud`, and `Kaluga.date-picker` have been enabled,
provide a `ContainerView` to the `LifecycleViewModel`
to automatically add support for displaying alerts, huds, and date-pickers to the View.

The types of builders to support in a container can be provided on initialization.

```swift
let container = ContainerView(.alertBuilder, .hudBuilder, .datePickerBuilder)
let alertBuilder = container.alertBuilder
let hudBuilder = container.hudBuilder
let datePickerBuilder = container.datePickerBuilder
let wrapper = ViewModelWrapperView(container: container, viewModel: viewModel)
```

### Observables and Subjects
This library provides functionality for using Kaluga `Observables` and `Subjects` in SwiftUI views.
Observables can be mapped to a `Observable` or `UninitializedObservable`
and Subjects to `Subject` or `UninitializedSubject` classes.
These classes require a mapping, though convenience default mappings and typealiases are included in this library.

To use the value of an observable:

```swift
struct SomeView: View {

    @ObservedObject private var someString: StringObservable

    init(_ viewModel: SomeViewModel) {
        someString = StringObservable(
            viewModel.someStringObservable,
            defaultValue: "DefaultValueString",
            animated: true // Animate value changes
        )
    }

    var body: some View {
        Text(someString.value)
    }
}
```

Default `Observables`:

- ListObservable
- Object(Uninitialized)Observable
- Color(Uninitialized)Observable
- String(Uninitialized)Observable
- Bool(Uninitialized)Observable
- Int(Uninitialized)Observable
- Float(Uninitialized)Observable
- Double(Uninitialized)Observable

Default `Subjects`:

- String(Uninitialized)Subject
- Bool(Uninitialized)Subject
- Int(Uninitialized)Subject
- Float(Uninitialized)Subject
- Double(Uninitialized)Subject

### Navigation
#### State-driven navigation

Suppose you have navigation state (simplified) in shared code:

```Kotlin
class HomeRoutingNavigator {

    sealed class RoutingState(open val route: String) {
        object Root : RoutingState("Root")
        object LogIn : RoutingState("LogIn")
        object Profile : RoutingState("Profile")
    }

    val routingState = MutableStateFlow<RoutingState>(RoutingState.Root)
}
```

And view model holding this state:

```Kotlin
class SomeViewModel : BaseLifecycleViewModel() {

    private val navigator = HomeRoutingNavigator()

    val isLogInScreenVisible = navigator.routingState
        .mapLatest { it is HomeRoutingNavigator.RoutingState.LogIn }
        .toInitializedObservable(false, coroutineScope)
}
```

To show LogInView in SwiftUI using navigation state:

```Swift
struct HomeView: View {

    private let viewModel: LifecycleViewModel<HomeViewModel>
    @ObservedObject private var isLogInScreenVisible: BoolObservable

    init(_ homeViewModel: HomeViewModel) {
        viewModel = LifecycleViewModel(viewModel: homeViewModel)
        isLogInScreenVisible = BoolObservable(homeViewModel.isLogInScreenVisible, animated: true)
    }

    var body: some View {
        viewModel.lifecycleView { viewModel in
            Group {
                // Home View Layout
                Text(viewModel.staticTitle)
            }
            .navigation(state: ObservableRoutingState(isLogInScreenVisible), type: .fullscreen) {
                LogInView()
            }
        }
    }
}
```

View display types:

- Fullscreen (using `fullScreenCover`)
- Replace (fully replaced view)
- Cover (partly covered view)
- Sheet (using `sheet`)
- Push (using `NavigationView`)

