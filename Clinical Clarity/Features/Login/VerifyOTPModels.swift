//
//  VerifyOTPModels.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 13/07/26.
//

import Foundation

struct VerifyOTPRequest: Encodable {
    let email: String
    let otp: String
}

struct VerifyOTPResponse: Decodable {
    let success: Bool
    let message: String
    let data: VerifyOTPData
}

struct VerifyOTPData: Decodable {
    let token: String
    let isNewUser: Bool
    let user: VerifyOTPUser
}

struct VerifyOTPUser: Decodable {
    let id: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email
    }
}
