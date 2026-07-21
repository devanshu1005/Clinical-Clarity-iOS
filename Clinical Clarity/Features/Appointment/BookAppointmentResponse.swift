//
//  BookAppointmentResponse.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 21/07/26.
//

struct BookAppointmentResponse: Decodable {

    let success: Bool
    let message: String
    let data: Appointment
}

