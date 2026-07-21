//
//  DashboardModels.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 15/07/26.
//

import Foundation

struct DashboardResponse: Decodable {
    let success: Bool
    let message: String
    let data: DashboardData
}

struct DashboardData: Decodable {
    let sections: [DashboardSection]
}

struct DashboardSection: Decodable {
    let type: String
    let title: String
    let items: [DashboardItem]

    enum CodingKeys: String, CodingKey {
        case type
        case title
        case items
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = try container.decode(String.self, forKey: .type)
        title = try container.decode(String.self, forKey: .title)

        switch type {

        case "SPECIALIZATIONS":
            let value = try container.decode([String].self, forKey: .items)
            items = value.map {
                .specialization($0)
            }

        case "UPCOMING_APPOINTMENTS":
            let value = try container.decode([UpcomingAppointments].self, forKey: .items)
            items = value.map {
                .appointment($0)
            }

        case "POPULAR_DOCTORS":
            let value = try container.decode([Doctor].self, forKey: .items)
            items = value.map {
                .doctor($0)
            }

        case "NEARBY_DOCTORS":
            let value = try container.decode([NearbyDoctor].self, forKey: .items)
            items = value.map {
                .nearbyDoctor($0)
            }

        case "NEARBY_CLINICS":
            let value = try container.decode([Clinic].self, forKey: .items)
            items = value.map {
                .clinic($0)
            }

        default:
            items = []
        }
    }
}
