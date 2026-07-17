//
//  DoctorDetailsResponse.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 17/07/26.
//

import Foundation

struct DoctorDetailsResponse: Decodable {

    let success: Bool
    let message: String
    let data: DoctorDetailsData
}

struct DoctorDetailsData: Decodable {

    let doctor: Doctor
    let availableSlots: [DoctorSlot]
}
