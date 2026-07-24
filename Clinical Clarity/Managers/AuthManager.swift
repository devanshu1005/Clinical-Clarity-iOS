import Foundation
import Combine

@MainActor
class AuthManager: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    @Published var token: String?
    @Published var currentUser: UserProfile?
    
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
        user: UserProfile,
        isNewUser: Bool
    ){
        UserDefaults.standard.set(token, forKey: "authToken")
           UserDefaults.standard.set(user.email, forKey: "userEmail")
           UserDefaults.standard.set(isNewUser, forKey: "isNewUser")

           self.token = token
           self.currentUser = user
           self.isLoggedIn = true
        
        
        UserDefaults.standard.set(isNewUser, forKey: "isNewUser")
        
        
        self.token = token
        self.isLoggedIn = true
    }
    
    // MARK: - Logout
    func logout() {

        UserDefaults.standard.removeObject(forKey: "authToken")

        token = nil
        currentUser = nil
        isLoggedIn = false
    }
}
