import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject var appFlow: AppFlowManager
    
    private func runSplash() {
        Task {
            // Keep splash visible for 5 seconds
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            
            // Preload onboarding during splash
            await appFlow.prepareInitialFlow()
        }
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    Spacer(minLength: 0)
                    
                    Image("splash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                    Spacer()
                        .frame(height: 80)
                    
                    ProgressView()
                        .tint(Color.accentColor)
                        .scaleEffect(1.2)
                    
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: UIScreen.main.bounds.height)
            }
        }
        .onAppear {
            runSplash()
        }
    }
}
