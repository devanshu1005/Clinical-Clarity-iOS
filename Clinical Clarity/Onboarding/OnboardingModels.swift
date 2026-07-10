import Foundation

struct OnboardingResponse: Decodable {
    let success: Bool
    let message: String
    let data: OnboardingItem
}

struct OnboardingItem: Decodable, Identifiable {
    let id: String
    let onboardingImage: String
    let title: String
    let subtitle: String
    let isComingSoon: Bool
    let index: Int
    let createdAt: String
    let updatedAt: String
    let v: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case onboardingImage
        case title
        case subtitle
        case isComingSoon
        case index
        case createdAt
        case updatedAt
        case v = "__v"
    }
}
