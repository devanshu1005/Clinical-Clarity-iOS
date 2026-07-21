//
//  DoctorDetailsViewModel.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 17/07/26.
//

import Foundation
import Combine

@MainActor
final class DoctorDetailsViewModel: ObservableObject {

    @Published var doctor: Doctor?

    @Published var slots: [DoctorSlot] = []
    
    @Published
    var selectedSlot: DoctorSlot?

    @Published var isLoading = false
    
    @Published var isLoadingSlots = false

    @Published var errorMessage: String?
    
    @Published var errorMessageSlots: String?

    private let doctorId: String
    
    @Published var selectedClinicId: String
    
    var selectedClinic: Clinic? {
           doctor?.clinics?.first(where: {
               $0.id == selectedClinicId
           })
       }
    
    @Published var isBooking = false
    @Published var bookingError: String?

    init(doctorId: String, clinicId: String) {

        self.doctorId = doctorId
        self.selectedClinicId = clinicId
    }
    
    @Published
    var selectedDate = Date()

    let availableDates = (0..<7).compactMap {

        Calendar.current.date(
            byAdding: .day,
            value: $0,
            to: Date()
        )
    }

    func loadDoctor(
        for date: Date? = nil
    ) async {

        isLoading = true
        errorMessage = nil

        defer {

            isLoading = false
        }

        do {

            let selected = Self.currentDate(
                from: date ?? selectedDate
            )

            let response: DoctorDetailsResponse =
                try await APIClient.shared.request(
                    endpoint: .doctorDetails(
                        doctorId: doctorId,
                        clinicId: selectedClinicId,
                        date: selected
                    )
                )

            doctor = response.data.doctor
            slots = response.data.availableSlots

        } catch {

            errorMessage = error.localizedDescription
        }
    }
    
    func loadDoctorAvailability(
        for date: Date? = nil
    ) async {

        isLoadingSlots = true
        errorMessageSlots = nil

        defer {

            isLoadingSlots = false
        }

        do {

            let selected = Self.currentDate(
                from: date ?? selectedDate
            )

            let response: DoctorDetailsResponse =
                try await APIClient.shared.request(
                    endpoint: .doctorDetails(
                        doctorId: doctorId,
                        clinicId: selectedClinicId,
                        date: selected
                    )
                )

//            doctor = response.data.doctor
            slots = response.data.availableSlots

        } catch {

            errorMessageSlots = error.localizedDescription
        }
    }
    
    func changeClinic(
        for date: Date? = nil
    ) async {

        isLoadingSlots = true
        errorMessageSlots = nil

        defer {

            isLoadingSlots = false
        }

        do {

            let selected = Self.currentDate(
                from: date ?? selectedDate
            )

            let response: DoctorDetailsResponse =
                try await APIClient.shared.request(
                    endpoint: .doctorDetails(
                        doctorId: doctorId,
                        clinicId: selectedClinicId,
                        date: selected
                    )
                )

            doctor = response.data.doctor
            slots = response.data.availableSlots

        } catch {

            errorMessageSlots = error.localizedDescription
        }
    }
    
    func bookAppointment() async throws -> Appointment {

        guard
            let doctor = doctor,
            let slot = selectedSlot
        else {
            throw APIError.invalidResponse
        }

        isBooking = true
        bookingError = nil

        defer {
            isBooking = false
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let body = BookAppointmentRequest(
            doctorId: doctor.id,
            clinicId: selectedClinicId,
            appointmentDate: formatter.string(from: selectedDate),
            startTime: slot.start,
            endTime: slot.end
        )

        let response: BookAppointmentResponse =
            try await APIClient.shared.request(
                endpoint: .bookAppointment,
                body: body,
                requiresAuth: true
            )

        return response.data
    }

    private static func currentDate(
        from date: Date
    ) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.string(from: date)
    }
}
