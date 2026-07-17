//
//  AppRoute.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 16/07/26.
//

enum AppRoute: Hashable {

    case doctorDetails(id: String)
    
    case doctorList(specialization: String)
    
    case doctorSearch
    
    case appointmentDetails
}
