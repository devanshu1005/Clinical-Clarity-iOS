//
//  Appointment.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 15/07/26.
//

struct Appointment: Decodable {

    let id: String
    let doctorId: Doctor
    let clinicId: Clinic

    let appointmentDate: String
    let startTime: String
    let endTime: String
    let status: String

    enum CodingKeys: String, CodingKey {

        case id = "_id"

        case doctorId
        case clinicId

        case appointmentDate
        case startTime
        case endTime
        case status
    }
}
