//
//  AppRoute.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 16/07/26.
//

enum AppRoute: Hashable {

    case doctorDetails(doctorId: String, clinicId: String)
    
    case doctorList(specialization: String)
    
    case doctorSearch
    
    case appointmentDetails
}
