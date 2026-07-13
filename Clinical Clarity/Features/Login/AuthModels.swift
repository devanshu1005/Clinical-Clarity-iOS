//
//  AuthModels.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 13/07/26.
//

import Foundation

struct RequestOTPRequest: Encodable {
    let email: String
}

struct RequestOTPResponse: Decodable {
    let success: Bool
    let message: String
}
