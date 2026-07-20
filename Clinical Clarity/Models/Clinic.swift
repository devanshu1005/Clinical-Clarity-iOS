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

    let location: ClinicLocation?

    let availability: DoctorAvailability?

    enum CodingKeys: String, CodingKey {

        case id = "_id"

        case name
        case shortAddress
        case thumbnailImage
        case doctorCount
        case doctorPreviewImages
        case distanceInKm
        case location
        case availability
    }
}

struct ClinicLocation: Decodable {

    let type: String

    /// GeoJSON format: [longitude, latitude]
    let coordinates: [Double]

    var longitude: Double? {
        coordinates.count > 0 ? coordinates[0] : nil
    }

    var latitude: Double? {
        coordinates.count > 1 ? coordinates[1] : nil
    }
}
