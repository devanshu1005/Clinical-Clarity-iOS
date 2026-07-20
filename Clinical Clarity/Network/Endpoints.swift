import Foundation

enum Endpoint {
    
//    case login(mobile: String)
    case onboarding
    case requestOTP
    case verifyOTP
    case dashboard(latitude: Double, longitude: Double)
    case searchDoctors(query: String)
    case doctorDetails(
        doctorId: String,
        clinicId: String,
        date: String
    )

    var path: String {
        switch self {
        case .onboarding:
                   return "api/v1/onboarding"
        case .requestOTP:
                    return "api/v1/auth/request-otp"
        case .verifyOTP:
                return "api/v1/auth/verify-otp"
        case .dashboard(let latitude, let longitude):
            return "api/v1/dashboard?latitude=\(latitude)&longitude=\(longitude)"
        case .searchDoctors(let query):

            let encoded =
                query.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed
                ) ?? ""

            return "api/v1/doctors/search?q=\(encoded)"
        case .doctorDetails(let doctorId, let clinicId, let date):
            return "api/v1/doctors/\(doctorId)?clinicId=\(clinicId)&date=\(date)"
//        case .login(let mobile):
//               return "api/v4/user/login?mobile_no=\(mobile)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
//        case .register, .bookSlot, .verifyOTP, .updateProfile, .raiseQuery:
//            return .POST
        case .requestOTP, .verifyOTP:
                   return .POST
        case .onboarding, .dashboard, .searchDoctors, .doctorDetails:
            return .GET
        }
    }
}

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}
