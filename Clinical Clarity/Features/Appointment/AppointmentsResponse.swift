//
//  AppointmentsResponse.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 22/07/26.
//

struct AppointmentsResponse: Decodable {

    let success: Bool
    let message: String
    let count: Int
    let data: [UpcomingAppointments]
}
