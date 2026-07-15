//
//  VerifyOTPViewModel.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 13/07/26.
//

import Foundation
import Combine

@MainActor
final class VerifyOTPViewModel: ObservableObject {
    
    @Published var otp = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    func verifyOTP(email: String,  authManager: AuthManager ) async -> Bool {

        guard otp.count == 6 else {
            errorMessage = "Please enter a valid 6-digit OTP."
            return false
        }

        isLoading = true
        errorMessage = nil

        do {

            let body = VerifyOTPRequest(
                email: email,
                otp: otp
            )

            let response: VerifyOTPResponse =
                try await APIClient.shared.request(
                    endpoint: .verifyOTP,
                    body: body
                )

//            // Save auth token
//            UserDefaults.standard.set(
//                response.data.token,
//                forKey: "authToken"
//            )
//            
//            UserDefaults.standard.set(
//                response.data.user.email,
//                forKey: "userEmail"
//            )
//
//            UserDefaults.standard.set(
//                response.data.isNewUser,
//                forKey: "isNewUser"
//            )
            
            authManager.saveSession(token: response.data.token, email: response.data.user.email, isNewUser: response.data.isNewUser)

            isLoading = false

            return response.success

        } catch {

            isLoading = false
            errorMessage = "Invalid OTP."

            print(error)

            return false
        }
    }
}
