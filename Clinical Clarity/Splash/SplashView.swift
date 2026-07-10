import SwiftUI

struct SplashView: View {

    @EnvironmentObject var appFlow: AppFlowManager

    private func runSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {

            let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""

            if !authToken.isEmpty {
                appFlow.state = .onboarding
            } else {
                appFlow.state = .onboarding
            }
        }
    }

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            ScrollView {
                VStack {
                    Spacer(minLength: 0)

                    Image("splash") // Add your image to Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)

                    Spacer()
                        .frame(height: 80)

                    ProgressView()
                        .tint(Color.accentColor) // Replace with your custom color if needed
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
