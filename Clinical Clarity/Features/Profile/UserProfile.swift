//
//  UserProfile.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 23/07/26.
//

import Foundation

struct UserProfile: Decodable {

    let id: String

    let email: String
    let isEmailVerified: Bool
    let authProvider: String

    let name: String
    let gender: String?
    let age: Int?
    let bloodGroup: String?

    let mobileNumber: String

    let profileImage: String?

    let address: UserAddress

    let lastLoginAt: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {

        case id = "_id"

        case email
        case isEmailVerified
        case authProvider

        case name
        case gender
        case age
        case bloodGroup

        case mobileNumber
        case profileImage

        case address

        case lastLoginAt
        case createdAt
        case updatedAt
    }
}
