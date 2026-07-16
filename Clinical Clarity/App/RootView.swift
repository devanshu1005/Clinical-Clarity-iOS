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
//
//                case .clinicDetails(let clinicId):
//                    ClinicDetailsView(
//                        clinicId: clinicId
//                    )
//
//                case .appointmentDetails(let appointmentId):
//                    AppointmentDetailsView(
//                        appointmentId: appointmentId
//                    )
//
//                case .bookAppointment(let doctorId):
//                    BookAppointmentView(
//                        doctorId: doctorId
//                    )
//
//                case .searchDoctors:
//                    SearchDoctorsView()
//
//                case .searchClinics:
//                    SearchClinicsView()
//
//                case .notifications:
//                    NotificationView()
//
//                case .profile:
//                    ProfileView()
//
//                case .editProfile:
//                    EditProfileView()
//
//                case .medicalRecords:
//                    MedicalRecordsView()
//
//                case .prescriptions:
//                    PrescriptionView()
                }
            }
        }
    }
}
