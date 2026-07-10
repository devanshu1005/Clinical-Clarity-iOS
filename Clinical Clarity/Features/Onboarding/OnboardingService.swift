//
//  OnboardingService.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 10/07/26.
//

import Foundation

struct OnboardingService {
    func fetchOnboarding() async throws -> OnboardingListResponse {
        try await APIClient.shared.request(endpoint: .onboarding)
    }
}
