import Foundation

enum Endpoint {
    
//    case login(mobile: String)
    case onboarding

    var path: String {
        switch self {
        case .onboarding:
                   return "api/v1/onboarding"
//        case .login(let mobile):
//               return "api/v4/user/login?mobile_no=\(mobile)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
//        case .register, .bookSlot, .verifyOTP, .updateProfile, .raiseQuery:
//            return .POST
        case .onboarding:
            return .GET
        }
    }
}

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}
