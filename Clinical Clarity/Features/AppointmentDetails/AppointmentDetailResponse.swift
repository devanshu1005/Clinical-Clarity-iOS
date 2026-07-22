//
//  AppointmentDetailResponse.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 22/07/26.
//

struct AppointmentDetailResponse: Decodable {

    let success: Bool
    let message: String
    let data: UpcomingAppointments
}
