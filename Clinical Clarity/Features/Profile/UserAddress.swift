//
//  UserAddress.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 23/07/26.
//

import Foundation

struct UserAddress: Decodable {

    let line1: String
    let line2: String
    let city: String
    let state: String
    let postalCode: String
    let country: String
}
