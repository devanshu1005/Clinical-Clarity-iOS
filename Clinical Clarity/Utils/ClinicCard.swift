//
//  ClinicCard.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 16/07/26.
//

import SwiftUI

struct ClinicCard: View {

    let clinic: Clinic

    var buttonTitle: String = "Book Appointment"

    var showButton: Bool = true

    var onBook: (() -> Void)?

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            AsyncImage(
                url: URL(
                    string: clinic.thumbnailImage ?? ""
                )
            ) { image in

                image
                    .resizable()
                    .scaledToFill()

            } placeholder: {

                Rectangle()
                    .fill(Color.brandAccentBlue)
            }
            .frame(height: 180)
            .clipShape(
                RoundedRectangle(cornerRadius: 18)
            )

            Text(clinic.name)
                .font(.appBodySemibold)
                .foregroundColor(.textPrimary)

            Text(clinic.shortAddress ?? "")
                .font(.appLabel)
                .foregroundColor(.textSecondary)

            HStack {

                if let count = clinic.doctorCount {

                    Label(
                        "\(count) Doctors",
                        systemImage: "stethoscope"
                    )
                }

                Spacer()

                if let distance = clinic.distanceInKm {

                    Label(
                        String(format: "%.1f km", distance),
                        systemImage: "location.fill"
                    )
                }
            }
            .font(.appCaptionMedium)
            .foregroundColor(.textSecondary)

            if showButton {

                BrandedActionButton(
                    title: buttonTitle,
                    suffixIcon: "calendar"
                ) {

                    onBook?()
                }
            }
        }
        .padding(20)
        .background(Color.cardBackground)
        .overlay {

            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.borderDefault)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
}
