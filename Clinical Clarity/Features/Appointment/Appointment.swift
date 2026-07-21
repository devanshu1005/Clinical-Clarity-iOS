//
//  Appointment.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 21/07/26.
//

struct Appointment: Decodable, Hashable {

    let id: String
    let doctorId: String
    let clinicId: String
    let patientId: String
    let appointmentDate: String
    let startTime: String
    let endTime: String
    let status: String

    enum CodingKeys: String, CodingKey {

        case id = "_id"

        case doctorId
        case clinicId
        case patientId
        case appointmentDate
        case startTime
        case endTime
        case status
    }
}
