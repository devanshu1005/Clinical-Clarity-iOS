//
//  AppointmentDetailViewModel.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 22/07/26.
//

import Foundation
import Combine

@MainActor
final class AppointmentDetailViewModel: ObservableObject {

    @Published var appointment: UpcomingAppointments?

    @Published var isLoading = false

    @Published var errorMessage: String?

    private let appointmentId: String

    init(appointmentId: String) {
        self.appointmentId = appointmentId
    }

    func loadAppointment() async {

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {

            let response: AppointmentDetailResponse =
                try await APIClient.shared.request(
                    endpoint: .appointmentDetails(
                        id: appointmentId
                    ),
                    requiresAuth: true
                )

            appointment = response.data

        } catch {

            errorMessage = error.localizedDescription

            print(error)
        }
    }
}
