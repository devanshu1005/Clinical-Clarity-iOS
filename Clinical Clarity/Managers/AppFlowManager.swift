import SwiftUI
import Combine

@MainActor
final class AppFlowManager: ObservableObject {
    
    enum AppState {
        case splash
        case onboarding
        case login
    }
    
    @Published var state: AppState = .splash
    
    // Preloaded onboarding data
    @Published var onboardingItems: [OnboardingItem] = []
    
    private let authManager: AuthManager
    
    init(authManager: AuthManager) {
        self.authManager = authManager
    }
    
    // Called from SplashView
    func prepareInitialFlow() async {
        do {
            let response: OnboardingListResponse = try await APIClient.shared.request(
                endpoint: .onboarding
            )
            
            // Sort by index just to keep order safe
            onboardingItems = response.data.sorted { $0.index < $1.index }
            
            // After onboarding is loaded, move forward
            let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
            
            if !authToken.isEmpty {
                state = .onboarding
            } else {
                state = .onboarding
            }
            
        } catch {
            print("❌ Failed to preload onboarding:", error)
            
            // fallback: still move to onboarding if you want
            state = .onboarding
        }
    }
    
    func moveToLogin() {
        state = .login
    }
}
