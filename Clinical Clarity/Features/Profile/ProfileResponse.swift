//
//  ProfileResponse.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 23/07/26.
//

import Foundation

struct ProfileResponse: Decodable {

    let success: Bool
    let message: String
    let data: UserProfile
}
