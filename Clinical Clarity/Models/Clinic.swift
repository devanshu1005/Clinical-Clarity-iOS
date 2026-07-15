//
//  Clinic.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 15/07/26.
//

struct Clinic: Decodable {

    let id: String

    let name: String

    let shortAddress: String?

    let thumbnailImage: String?

    let doctorCount: Int?

    let doctorPreviewImages: [String]?

    let distanceInKm: Double?

    enum CodingKeys: String, CodingKey {

        case id = "_id"

        case name
        case shortAddress
        case thumbnailImage
        case doctorCount
        case doctorPreviewImages
        case distanceInKm
    }
}
