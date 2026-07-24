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
    
    @Published var upcomingAppointments: [UpcomingAppointments] = []
    
    @Published var selectedAppointmentFilter: AppointmentFilter = .upcoming
    
    enum AppointmentFilter: String, CaseIterable, Identifiable {

        case upcoming = "Upcoming Appointments"
        case completed = "Completed Appointments"

        var id: String { rawValue }

        var status: String {
            switch self {
            case .upcoming:
                return "BOOKED"
            case .completed:
                return "COMPLETED"
            }
        }
    }
    
    func loadDashboard() async {

        isLoading = true
        errorMessage = nil

        async let dashboardTask: Void = fetchDashboard()
        async let appointmentsTask: Void = loadAppointments()

        _ = await (dashboardTask, appointmentsTask)

        isLoading = false
    }

    private func fetchDashboard() async {

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

        } catch {

            errorMessage = error.localizedDescription

            print(error)
        }
    }
    
    func loadAppointments() async {

        do {

            let response: AppointmentsResponse =
                try await APIClient.shared.request(
                    endpoint: .appointments(
                        status: selectedAppointmentFilter.status
                    ),
                    requiresAuth: true
                )

            upcomingAppointments = response.data

        } catch {

            print(error)

            errorMessage = error.localizedDescription
        }
    }
}
