import SwiftUI
import Combine

@MainActor
final class NavigationManager: ObservableObject {

    @Published var path = NavigationPath()
    
    func reset() {
           path = NavigationPath()
       }

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
