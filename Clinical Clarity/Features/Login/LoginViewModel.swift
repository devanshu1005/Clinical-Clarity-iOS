//
//  LoginViewModel.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 13/07/26.
//

import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {

    @Published var email = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    func requestOTP() async -> Bool {

        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter your email."
            return false
        }

        guard email.contains("@") else {
            errorMessage = "Please enter a valid email."
            return false
        }

        isLoading = true
        errorMessage = nil

        do {

            let body = RequestOTPRequest(email: email)

            let response: RequestOTPResponse =
                try await APIClient.shared.request(
                    endpoint: .requestOTP,
                    body: body
                )

            isLoading = false

            return response.success

        } catch {

            isLoading = false
            errorMessage = "Unable to send OTP."

            print(error)

            return false
        }
    }
}
