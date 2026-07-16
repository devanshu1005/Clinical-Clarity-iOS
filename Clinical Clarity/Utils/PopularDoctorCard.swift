//
//  PopularDoctorCard.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 16/07/26.
//

import SwiftUI

struct PopularDoctorCard: View {

    let doctor: Doctor

    var onTap: (() -> Void)?

    var body: some View {

        Button {

            onTap?()

        } label: {

            VStack(alignment: .leading, spacing: 14) {

                AsyncImage(
                    url: URL(string: doctor.profileImage ?? "")
                ) { image in

                    image
                        .resizable()
                        .scaledToFill()

                } placeholder: {

                    Rectangle()
                        .fill(Color.brandAccentBlue)
                }
                .frame(width: 210, height: 150)
                .clipShape(
                    RoundedRectangle(cornerRadius: 18)
                )

                Text(doctor.name)
                    .font(.appBodySemibold)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)

                Text(doctor.specialization)
                    .font(.appLabel)
                    .foregroundColor(.textSecondary)

                HStack {

                    Label(
                        "\(doctor.experienceYears ?? 0) yrs",
                        systemImage: "stethoscope"
                    )

                    Spacer()

                    Label(
                        "\(doctor.averageRating ?? 0, specifier: "%.1f")",
                        systemImage: "star.fill"
                    )
                }
                .font(.appCaptionMedium)
                .foregroundColor(.textSecondary)
            }
            .padding(16)
            .frame(width: 240)
            .background(Color.cardBackground)
            .overlay {

                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.borderDefault)
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )
        }
        .buttonStyle(.plain)
    }
}
