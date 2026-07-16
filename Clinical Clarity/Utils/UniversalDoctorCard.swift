//
//  UniversalDoctorCard.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 16/07/26.
//

import SwiftUI

struct UniversalDoctorCard: View {

    // MARK: - Required

    let imageURL: String?
    let name: String
    let specialization: String

    // MARK: - Optional

    var rating: Double?
    var experience: Int?
    var clinicName: String?
    var address: String?
    var distance: Double?
    var consultationFee: Int?
    var isAvailable: Bool = true

    // MARK: - CTA

    var buttonTitle: String = "Book Appointment"

    var onButtonTap: (() -> Void)?

    var body: some View {

        VStack(alignment: .leading, spacing: 24) {

//            topSection

            Divider()

//            bottomSection
        }
        .padding(24)
        .background(Color.cardBackground)
        .overlay {

            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderDefault)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
        .shadow(
            color: .black.opacity(0.05),
            radius: 8,
            y: 2
        )
    }
}
