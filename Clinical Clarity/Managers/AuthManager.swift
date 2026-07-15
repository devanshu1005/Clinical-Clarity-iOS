import Foundation
import Combine

@MainActor
class AuthManager: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    @Published var token: String?
    
    init() {
        loadSession()
    }
    
    // MARK: - Load Session
    func loadSession() {
        let savedToken = UserDefaults.standard.string(forKey: "authToken")
        self.token = savedToken
        self.isLoggedIn = savedToken != nil
//        self.isLoggedIn = false
    }
    
    // MARK: - Save Session
    func saveSession(
        token: String,
//        profileImage: String?,
//        name: String?,
        email: String?,
        isNewUser: Bool
    ) {
        UserDefaults.standard.set(token, forKey: "authToken")
        
        // ✅ Save optional values safely
//        if let profileImage = profileImage, !profileImage.isEmpty {
//            UserDefaults.standard.set(profileImage, forKey: "profileImage")
//        } else {
//            UserDefaults.standard.removeObject(forKey: "profileImage")
//        }
//        
//        if let name = name, !name.isEmpty {
//            UserDefaults.standard.set(name, forKey: "userName")
//        } else {
//            UserDefaults.standard.removeObject(forKey: "userName")
//        }
        
        if let email = email, !email.isEmpty {
            UserDefaults.standard.set(email, forKey: "userEmail")
        } else {
            UserDefaults.standard.removeObject(forKey: "userEmail")
        }
        
        UserDefaults.standard.set(isNewUser, forKey: "isNewUser")
        
        
        self.token = token
        self.isLoggedIn = true
    }
    
    // MARK: - Logout
    func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        token = nil
        isLoggedIn = false
    }
}
