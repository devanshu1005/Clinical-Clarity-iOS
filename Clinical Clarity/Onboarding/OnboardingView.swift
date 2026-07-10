import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject var appFlow: AppFlowManager
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var currentPage = 1
    
    private let totalPages = 3
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
            } else if let item = viewModel.onboardingItem {
                VStack(spacing: 0) {
                    
                    Spacer().frame(height: 40)
                    
                    // MARK: - Image
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
                                .foregroundColor(.gray)
                            
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    Spacer().frame(height: 40)
                    
                    // MARK: - Title
                    Text(item.title)
                        .font(.system(size: 28, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                    
                    Spacer().frame(height: 16)
                    
                    // MARK: - Subtitle
                    Text(item.subtitle)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                    
                    Spacer()
                    
                    // MARK: - Page Indicator
                    HStack(spacing: 8) {
                        ForEach(1...totalPages, id: \.self) { page in
                            Capsule()
                                .fill(page == currentPage ? Color.blue : Color.gray.opacity(0.3))
                                .frame(width: page == currentPage ? 24 : 8, height: 8)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    .padding(.bottom, 24)
                    
                    // MARK: - Button
                    Button {
                        Task {
                            await handleNext()
                        }
                    } label: {
                        Text(currentPage == totalPages ? "Get Started" : "Next")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Color.blue)
                            .cornerRadius(16)
                            .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 32)
                }
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    
                    Button("Retry") {
                        Task {
                            await viewModel.fetchOnboarding(index: currentPage)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
        }
        .task {
            await viewModel.fetchOnboarding(index: currentPage)
        }
    }
    
    // MARK: - Actions
    private func handleNext() async {
        if currentPage < totalPages {
            currentPage += 1
            await viewModel.fetchOnboarding(index: currentPage)
        } else {
//            appFlow.moveToLogin()
        }
    }
}
