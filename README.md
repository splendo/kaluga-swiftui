# Kaluga SwiftUI Tools
Tools for generating classes to easily link [Kaluga](https://github.com/splendo/kaluga) projects to SwiftUI.
Since Kotlin Multiplatform does not support Swift implementations, Kaluga does not offer full SwiftUI support.
Instead some bridging classes are required to use Kaluga properly.

Kaluga projects do not directly import Kaluga into the Swift project however, instead exposing dependencies though a project specific shared library.
Therefore, no proper Swift Framework can be offered to developers.

This library aims to resolve this issue by providing coding templates that generated Swift classes directly in the SwiftUI project.
These classes are generated using [Sourcery](https://github.com/krzysztofzablocki/Sourcery).

## Installation
Make sure Sourcery is installed on your machine.

- Checkout this project as a submodule to your project
- Copy `template-kaluga.sourcery.yml` into the iOS folder of your shared code project and rename it to `kaluga.sourcery.yml`
- Open `kaluga.sourcery.yml` and change:
-- $XCODE_PROJ_NAME to the name of your xcodeproj file
-- $TARGET_NAME to the name of the target in your project
-- $PATH_TO_SUBMODULE to the path of the submodule
-- $NAME_OF_SHARED_FRAMEWORK to the name of the Shared Framework
-- Configure features (see below)
- run `sourcery --config kaluga.sourcery.yml`
- If the partial sheet feature was enabled, add `https://github.com/AndreaMiotto/PartialSheet.git` as a Swift Package Dependency to your project.
- Import the files in `./KalugaSwiftUI` into your Xcode project.

### Features
To enable or disable certain Kaluga features, update their corresponding settings in the `kaluga.sourcery.yml` file.
All features are enabled by default.

- __includeAlerts__: Set to `true` when `Kaluga.alerts` is exported.
- __includeHud__: Set to `true` when `Kaluga.hud` is exported.
- __includeDatePicker__: Set to `true` when `Kaluga.date-picker` is exported.
- __includePartialSheet__: Set to `true` when using [PartialSheet](https://github.com/AndreaMiotto/PartialSheet.git) navigation.

## Usage
### ViewModels
Kaluga ViewModels require a lifecycle to be maintained. This can be automated by wrapping the `ViewModel` in a `ViewModelWrapperView`.
Use the wrappers body method to then display the viewModel in a lifecycle aware state.

```swift
struct SomeView : View {
	let wrapper: ViewModelWrapperView<SomeViewModel>

	init(viewModel: SomeViewModel) {
		wrapper = ViewModelWrapperView(viewModel: viewModel)
	}

    var body: some View {
    	wrapper.body { viewModel in 
    		// Render View
    	}
    }

}
```

### Alerts, HUD and DatePicker.
If `Kaluga.alerts`, `Kaluga.hud`, and `Kaluga.date-picker` have been enabled, provide a `ViewControllerContainer` to the `ViewModelWrapperView` to automatically add support for displaying alerts, huds, and date-pickers to the View.

The types of builders to support in a container can be provided on initialization.

```swift
let container = ViewControllerContainer(types: [.alertBuilder, .hudBuilder, .datePickerBuilder])
let alertBuilder = container.alertBuilder!
let hudBuilder = container.hudBuilder!
let datePickerBuilder = container.datePickerBuilder!
let wrapper = ViewModelWrapperView(container: container, viewModel: viewModel)
```


### Observables and Subjects
This library provides functionality for using Kaluga `Observables` and `Subjects` in SwiftUI views.
Observables can be mapped to a `CombineObservable` and Subjects to `CombineSubject` classes.
These classes require a mapping, though convenience default implementations are included in this library.

To use the value of an observable

```swift
struct SomeView : View {
	
	@ObservedObject private var someString: StringCombineObservable

	init(viewModel: SomeViewModel) {
		someString = StringCombineObservable(viewModel.someStringObservable)
	}

    var body: some View {
    	Text(someString.value)
    }

}
```

### Navigation
TODO