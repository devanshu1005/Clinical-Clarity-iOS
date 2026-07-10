import SwiftUI
import Combine

@MainActor
class AppFlowManager: ObservableObject {
    
    enum AppState {
        case splash
        case onboarding
//        case login
//        case register
//        case otp(mobile: String)
//        case dashboard
//        case driverHome
    }
    
    @Published var state: AppState = .splash
    
    private let authManager: AuthManager
    
    init(authManager: AuthManager) {
        self.authManager = authManager
    }
    
    func moveToNext() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.checkUserState()
        }
    }
    
    private func checkUserState() {
        
        if authManager.isLoggedIn {
            state = .onboarding
            return
        } else {
            state = .onboarding
        }
    }
}
