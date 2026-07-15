//
//  DashboardViewModel.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 15/07/26.
//

import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {

    @Published var isLoading = false

    @Published var errorMessage: String?

    @Published var sections: [DashboardSection] = []

    func loadDashboard() async {

        isLoading = true

        errorMessage = nil

        do {

            let response: DashboardResponse =
                try await APIClient.shared.request(
                    endpoint: .dashboard(
                        latitude: 28.6139,
                        longitude: 77.2090
                    ),
                    requiresAuth: true
                )

            sections = response.data.sections

            isLoading = false

        } catch {

            isLoading = false

            errorMessage = error.localizedDescription

            print(error)
        }
    }
}
