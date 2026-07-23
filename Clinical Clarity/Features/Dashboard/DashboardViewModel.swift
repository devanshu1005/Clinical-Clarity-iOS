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
    
    //profile
    @Published var profile: UserProfile?
    
    func loadProfile() async {

        isLoading = true
        errorMessage = nil

        defer {

            isLoading = false
        }

        do {

            let response: ProfileResponse =
                try await APIClient.shared.request(
                    endpoint: .profile,
                    requiresAuth: true
                )

            profile = response.data

        } catch {

            errorMessage = error.localizedDescription

            print(error)
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

extension DashboardViewModel {

    var displayName: String {

        guard let profile else {

            return "Guest User"
        }

        return profile.name.isEmpty
            ? "Complete Your Profile"
            : profile.name
    }

    var displayEmail: String {

        profile?.email ?? ""
    }

    var displayPhone: String {

        guard let profile else {

            return "Not Added"
        }

        return profile.mobileNumber.isEmpty
            ? "Not Added"
            : profile.mobileNumber
    }

    var displayGender: String {

        profile?.gender ?? "Not Added"
    }

    var displayAge: String {

        guard let age = profile?.age else {

            return "Not Added"
        }

        return "\(age) Years"
    }

    var displayBloodGroup: String {

        profile?.bloodGroup ?? "Not Added"
    }

    var formattedAddress: String {

        guard let address = profile?.address else {

            return "Address not added"
        }

        let parts = [

            address.line1,
            address.line2,
            address.city,
            address.state,
            address.postalCode,
            address.country

        ].filter {

            !$0.isEmpty
        }

        if parts.isEmpty {

            return "Address not added"
        }

        return parts.joined(separator: ", ")
    }

    var profileImageURL: URL? {

        guard
            let url = profile?.profileImage,
            !url.isEmpty
        else {

            return nil
        }

        return URL(string: url)
    }

    var isProfileComplete: Bool {

        guard let profile else {

            return false
        }

        return
            !profile.name.isEmpty &&
            !profile.mobileNumber.isEmpty &&
            profile.gender != nil &&
            profile.age != nil &&
            profile.bloodGroup != nil
    }
}
