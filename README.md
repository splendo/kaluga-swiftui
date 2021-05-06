# Kaluga SwiftUI Tools
Tools for generating classes to easily link [Kaluga](https://github.com/splendo/kaluga) projects to SwiftUI.
Since Kotlin Multiplatform does not support Swift implementations, Kaluga does not offer full SwiftUI support.
Instead some bridging classes are required to use Kaluga properly.

Kaluga projects do not directly import Kaluga into the Swift project however, instead exposing dependencies though a project specific shared library.
Therefore, no proper Swift Framework can be offered to developers.

This library aims to resolve this issue by providing coding templates that generated Swift classes directly in the SwiftUI project.
These classes are generated using [Sourcery](https://github.com/krzysztofzablocki/Sourcery).

## Usage
Make sure Sourcery is installed on your machine.

- Checkout this project as a submodule to your project
- Copy `template-kaluga.sourcery.yml` into the iOS folder of your shared code project and rename it to `kaluga.sourcery.yml`
- Open `kaluga.sourcery.yml` and change:
-- $XCODE_PROJ_NAME to the name of your xcodeproj file
-- $TARGET_NAME to the name of the target in your project
-- $PATH_TO_SUBMODULE to the path of the submodule
-- $NAME_OF_SHARED_FRAMEWORK to the name of the Shared Framework
- run `sourcery --config kaluga.sourcery.yml`
