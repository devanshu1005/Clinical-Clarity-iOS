import SwiftUI

struct RootView: View {

    @EnvironmentObject private var appFlow: AppFlowManager
    @EnvironmentObject private var navigationManager: NavigationManager

    var body: some View {

        NavigationStack(path: $navigationManager.path) {

            Group {

                switch appFlow.state {

                case .splash:
                    SplashView()

                case .onboarding:
                    OnboardingView()

                case .login:
                    LoginView()

                case .verifyOTP(let email):
                    VerifyOTPView(email: email)

                case .dashboard:
                    MainContainerView()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(for: AppRoute.self) { route in

                switch route {
                    
                case .appointmentDetails:
                                        AppointmentView()
               
                case .doctorDetails(let doctorId):
                    DoctorDetailsView(
                        doctorId: doctorId
                    )
                    
                case .doctorList(let specialization):
                    DoctorListView(
                        specialization: specialization
                    )
                    
                case .doctorSearch:
                    DoctorSearchView()
                }
            }
        }
    }
}
