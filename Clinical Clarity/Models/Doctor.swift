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

    let profileImage: String?

    let averageRating: Double?

    let totalReviews: Int?

    let clinics: [Clinic]?

    enum CodingKeys: String, CodingKey {

        case id = "_id"

        case name
        case specialization
        case qualification
        case experienceYears
        case profileImage
        case averageRating
        case totalReviews
        case clinics
    }
}
