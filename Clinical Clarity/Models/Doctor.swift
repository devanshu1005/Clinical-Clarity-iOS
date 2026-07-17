//
//  Doctor.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 15/07/26.
//

struct Doctor: Decodable {

    let id: String

    let name: String

    let specialization: String

    let qualification: String?

    let experienceYears: Int?
    
    let consultationFee: Int?

    let profileImage: String?
    
    let bio: String?

    let languages: [String]?

    let averageRating: Double?

    let totalReviews: Int?

    let clinics: [Clinic]?
    
    let availability: DoctorAvailability?

    enum CodingKeys: String, CodingKey {

        case id = "_id"

        case name
        case specialization
        case qualification
        case experienceYears
        case consultationFee
        case profileImage
        case bio
        case languages
        case averageRating
        case totalReviews
        case clinics
        case availability
    }
}


struct DoctorAvailability: Decodable {

    let workingDays: [String]
    let startTime: String
    let endTime: String
    let slotDuration: Int
}

struct DoctorSlot: Decodable, Identifiable {

    var id: String {

        start
    }

    let start: String
    let end: String
}
