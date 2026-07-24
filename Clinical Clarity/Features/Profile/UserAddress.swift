import Foundation

struct UserAddress: Decodable {

    let line1: String
    let line2: String
    let city: String
    let state: String
    let postalCode: String
    let country: String

    var formattedAddress: String {

        let parts = [
            line1,
            line2,
            city,
            state,
            postalCode,
            country
        ]
        .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

        return parts.isEmpty
            ? "Address not added"
            : parts.joined(separator: ", ")
    }
}
