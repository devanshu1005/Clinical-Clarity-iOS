//
//  DoctorSearchViewModel.swift
//

import Foundation
import Combine

@MainActor
final class DoctorSearchViewModel: ObservableObject {

    @Published var searchText = ""

    @Published var doctors: [Doctor] = []

    @Published var isLoading = false

    @Published var errorMessage: String?

    func searchDoctors() async {

        let query = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !query.isEmpty else {

            doctors = []

            return
        }

        isLoading = true

        errorMessage = nil

        do {

            let response: SearchDoctorsResponse =
                try await APIClient.shared.request(
                    endpoint: .searchDoctors(
                        query: query
                    ),
                    requiresAuth: true
                )

            doctors = response.data

            isLoading = false

        } catch {

            isLoading = false

            doctors = []

            errorMessage = error.localizedDescription

            print(error)
        }
    }

    func clearResults() {

        doctors = []

        searchText = ""

        errorMessage = nil
    }
}
