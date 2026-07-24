import SwiftUI

struct RootView: View {

    @EnvironmentObject private var appFlow: AppFlowManager
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var authManager: AuthManager

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
                    
                case .doctorDetails(let doctorId, let clinicId):
                    DoctorDetailsView(
                        doctorId: doctorId,
                        clinicId: clinicId
                    )
                    
                case .doctorList(let specialization):
                    DoctorListView(
                        specialization: specialization
                    )
                    
                case .doctorSearch:
                    DoctorSearchView()
                    
                case .appointmentConfirmation(let appointment):
                    AppointmentConfirmationView(
                        appointment: appointment
                    )
                    
                case .appointmentDetails(let id):
                    AppointmentDetailView(appointmentId: id)
                    
                case .editProfile:
                    EditProfileView()
                    
                }
            }
        }
        .task {
            
            guard authManager.isLoggedIn,
                  authManager.currentUser == nil else {
                return
            }

            await authManager.loadCurrentUser()
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: .didLogout
            )
        ) { _ in

            authManager.logout()

            navigationManager.reset()

            appFlow.moveToLogin()
        }
    }
}
