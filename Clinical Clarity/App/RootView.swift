import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var appFlow: AppFlowManager
    
    var body: some View {
        switch appFlow.state {
            
        case .splash:
            SplashView()
            
        case .onboarding:
            OnboardingView()
            
        case .login:
            LoginView()
            
//        case .dashboard:
//            DashboardView()
            
       
        }
    }
}
