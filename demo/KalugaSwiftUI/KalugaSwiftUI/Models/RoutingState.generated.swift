// Generated using Sourcery 1.4.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import SwiftUI
import Combine

class RoutingState: ObservableObject {

    @Published var isPresented = false

    func show(animated: Bool = false, force: Bool = false) {
        setPresented(true, animated: animated, force: force)
    }
    func close(animated: Bool = false, force: Bool = false) {
        setPresented(false, animated: animated, force: force)
    }

    fileprivate func setPresented(_ presented: Bool, animated: Bool, force: Bool) {
        if isPresented == presented && !force {
            return
        }

        if animated {
            withAnimation {
                isPresented = presented
            }
        } else {
            isPresented = presented
        }
    }
}

/*
class ObservableRoutingState: RoutingState {

    private var cancellable = Set<AnyCancellable>()

    init(_ observable: BoolObservable, animated: Bool = false) {
        super.init()
        observable.$value
            .sink { [weak self] value in
                if value {
                    self?.show(animated: animated, force: true)
                } else {
                    self?.close(animated: animated, force: false)
                }
            }
            .store(in: &cancellable)
    }
}
*/

class ObjectRoutingState<T: Equatable>: RoutingState {

    private(set) var object: T?

    func show(_ object: T, animated: Bool = false) {
        let force: Bool
        if self.object != object {
            self.object = object
            force = true
        } else {
            force = false
        }
        super.show(animated: animated, force: force)
    }

    override func close(animated: Bool = false, force: Bool = false) {
        object = nil
        super.close(animated: animated, force: force)
    }
}
