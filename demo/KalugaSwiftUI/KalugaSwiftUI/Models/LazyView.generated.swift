// Generated using Sourcery 1.4.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import SwiftUI

struct LazyView<Content: View>: View {
    private let content: () -> Content

    init(_ content: @autoclosure @escaping () -> Content) {
        self.content = content
    }

    var body: Content {
        content()
    }
}
