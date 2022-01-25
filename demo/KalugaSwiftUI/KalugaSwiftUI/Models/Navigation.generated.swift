// Generated using Sourcery 1.4.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import SwiftUI

struct Navigation<NavigationContent: View>: ViewModifier {

    enum NavigationType {
        case fullscreen
        case hud
        case push
        case replace
        case sheet
        case cover
    }

    @ObservedObject var state: RoutingState

    private let type: NavigationType
    private let navigationContent: () -> NavigationContent

    init(state: RoutingState, type: NavigationType, @ViewBuilder navigationContent: @escaping () -> NavigationContent) {
        self.state = state
        self.type = type
        self.navigationContent = navigationContent
    }

    @ViewBuilder
    func body(content: Content) -> some View {
        switch type {
        case .push:
            VStack {
                NavigationLink(
                    destination: LazyView(navigationContent()),
                    isActive: $state.isPresented
                ) {
                    EmptyView()
                }
                content
            }
        case .hud:
             Group {
                 content
                     .blur(radius: state.isPresented ? 3 : 0)
                     .opacity(state.isPresented ? 0.5 : 1.0)
                     .disabled(state.isPresented)
                 if state.isPresented {
                     LazyView(navigationContent())
                 }
             }
        case .fullscreen:
            content.fullScreenCover(isPresented: $state.isPresented) { LazyView(navigationContent()) }
        case .sheet:
            content.sheet(isPresented: $state.isPresented) { LazyView(navigationContent()) }
        case .replace:
            if state.isPresented {
                LazyView(navigationContent())
            } else {
                content
            }
        case .cover:
            Group {
                content
                if state.isPresented {
                    LazyView(navigationContent())
                }
            }
        }
    }
}

extension View {
    func navigation<NavigationContent: View>(
        state: RoutingState,
        type: Navigation<NavigationContent>.NavigationType,
        @ViewBuilder content: @escaping () -> NavigationContent
    ) -> some View {
        ModifiedContent(
            content: self,
            modifier: Navigation(
                state: state,
                type: type,
                navigationContent: content
            )
        )
    }
}
