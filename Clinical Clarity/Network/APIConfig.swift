import Foundation

struct APIConfig {
    
    static let baseURL = "https://clinicalclaritybackend.onrender.com/"
    
    static var defaultHeaders: [String: String] {
        [
            "Accept": "application/json",
//            "authkey": "Apna002Slot$#$HS"
        ]
    }
}
