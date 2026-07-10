import Foundation
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    
    @Published var onboardingItem: OnboardingItem?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchOnboarding(index: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: OnboardingResponse = try await APIClient.shared.request(
                endpoint: .onboarding(index: index)
            )
            
            onboardingItem = response.data
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Failed to load onboarding data."
            print("❌ Onboarding fetch error:", error)
        }
    }
}
