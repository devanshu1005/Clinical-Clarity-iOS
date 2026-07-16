//
//  SearchDoctorsResponse.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 16/07/26.
//

//
//  SearchDoctorsResponse.swift
//

import Foundation

struct SearchDoctorsResponse: Decodable {

    let success: Bool

    let message: String

    let count: Int

    let data: [Doctor]
}
