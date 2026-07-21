//
//  BookAppointmentRequest.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 21/07/26.
//

struct BookAppointmentRequest: Encodable {

    let doctorId: String
    let clinicId: String
    let appointmentDate: String
    let startTime: String
    let endTime: String
}
