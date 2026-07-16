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
//
//    case clinicDetails(id: String)
//
//    case appointmentDetails(id: String)
//
//    case bookAppointment(doctorId: String)
//
//    case searchDoctors
//
//    case searchClinics
//
//    case notifications
//
//    case profile
//
//    case editProfile
//
//    case settings
//
//    case medicalRecords
//
//    case prescriptions
    
    case appointmentDetails
}
