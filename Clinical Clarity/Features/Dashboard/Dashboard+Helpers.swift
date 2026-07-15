//
//  Dashboard+Helpers.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 15/07/26.
//

import Foundation

extension Array where Element == DashboardSection {

    func section(type: String) -> DashboardSection? {

        first {

            $0.type == type
        }
    }
}
