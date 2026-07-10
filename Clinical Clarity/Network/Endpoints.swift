import Foundation

enum Endpoint {
    
//    case login(mobile: String)
    case onboarding(index: Int)

    var path: String {
        switch self {
        case .onboarding(let index):
                    return "api/v1/onboarding?index=\(index)"
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
