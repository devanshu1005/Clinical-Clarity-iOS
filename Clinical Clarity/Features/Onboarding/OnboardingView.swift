import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject var appFlow: AppFlowManager
    @State private var currentPage = 0
    
    private var items: [OnboardingItem] {
        appFlow.onboardingItems
    }
    
    var body: some View {
        ZStack {
            Color.cardBackground.ignoresSafeArea()
            
            if items.isEmpty {
//                appFlow.moveToLogin()
            } else {
                VStack(spacing: 0) {
                    
                    Spacer().frame(height: 20)
                    
                    // MARK: - Skip button
                    HStack {
                        Spacer()
                        
                        Button("Skip") {
                            appFlow.moveToLogin()
                        }
                        .font(.appNavButton)
                        .foregroundColor(Color.skipButtonText)
                        .padding(.horizontal, 24)
                    }
                    
                    // MARK: - Pager
                    TabView(selection: $currentPage) {
                        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                            VStack(spacing: 0) {
                                Spacer().frame(height: 20)
                                
                                AsyncImage(url: URL(string: item.onboardingImage)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(height: 280)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 280)
                                            .padding(.horizontal, 24)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 120, height: 120)
                                            .foregroundColor(Color.skipButtonText)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                
                                Spacer().frame(height: 40)
                                
                                Text(item.title)
                                    .font(.appTitle)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.textOnboardingTitle)
                                    .padding(.horizontal, 24)
                                
                                Spacer().frame(height: 16)
                                
                                Text(item.subtitle)
                                    .font(.appBody)
                                    .foregroundColor(Color.textOnboardingSubtitle)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 28)
                                
                                if item.isComingSoon {
                                    Text("Coming Soon")
                                        .font(.appCaption)
                                        .foregroundColor(Color.statusComingSoon)
                                        .padding(.top, 14)
                                }
                                
                                Spacer()
                            }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    // MARK: - Bottom Controls
                    VStack(spacing: 20) {
                        HStack(spacing: 8) {
                            ForEach(0..<items.count, id: \.self) { index in
                                Capsule()
                                    .fill(index == currentPage ? Color.pageIndicatorActive : Color.pageIndicatorInactive)
                                    .frame(width: index == currentPage ? 24 : 8, height: 8)
                                    .animation(.easeInOut, value: currentPage)
                            }
                        }
                        
                        BrandedActionButton(
                            title: currentPage == items.count - 1 ? "Get Started" : "Next",
                            suffixIcon: "arrow.right"
                        ) {
                            handleNext()
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 32)
                }
            }
        }
    }
    
    private func handleNext() {
        if currentPage < items.count - 1 {
            withAnimation {
                currentPage += 1
            }
        } else {
            appFlow.moveToLogin()
        }
    }
}


#Preview {
    OnboardingView()
}
