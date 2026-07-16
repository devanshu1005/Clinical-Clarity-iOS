//
//  NearbyDoctorCard.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 16/07/26.
//

import SwiftUI

struct NearbyDoctorCard: View {

    let item: NearbyDoctor

    var buttonTitle = "Book Appointment"

    var onBook: (() -> Void)?

    var body: some View {

        VStack(spacing: 16) {

            HStack(alignment: .top, spacing: 16) {

                AsyncImage(
                    url: URL(
                        string: item.doctor.profileImage ?? ""
                    )
                ) { image in

                    image
                        .resizable()
                        .scaledToFill()

                } placeholder: {

                    Circle()
                        .fill(Color.brandAccentBlue)
                }
                .frame(width: 72, height: 72)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 8) {

                    Text(item.doctor.name)
                        .font(.appBodySemibold)

                    Text(item.doctor.specialization)
                        .font(.appLabel)
                        .foregroundColor(.textSecondary)

                    HStack(spacing: 12) {

                        Label(
                            "\(item.doctor.experienceYears ?? 0) yrs",
                            systemImage: "stethoscope"
                        )

                        Label(
                            "\(item.doctor.averageRating ?? 0, specifier: "%.1f")",
                            systemImage: "star.fill"
                        )
                    }
                    .font(.appCaptionMedium)
                    .foregroundColor(.textSecondary)

                    HStack(spacing: 6) {

                        Image(systemName: "location.fill")
                            .foregroundColor(.brandPrimary)

                        Text(item.nearestClinic.shortAddress ?? "")
                            .font(.appCaptionMedium)
                            .foregroundColor(.textSecondary)
                    }
                }

                Spacer()
            }

            Divider()

            HStack {

                VStack(alignment: .leading, spacing: 4) {

                    Text("Nearest Clinic")
                        .font(.appCaptionMedium)
                        .foregroundColor(.textSecondary)

                    Text(item.nearestClinic.name)
                        .font(.appLabel)
                        .foregroundColor(.textPrimary)
                }

                Spacer()

                if let distance = item.nearestClinic.distanceInKm {

                    Text(
                        String(format: "%.1f km", distance)
                    )
                    .font(.appCaptionMedium)
                    .foregroundColor(.brandPrimary)
                }
            }

            BrandedActionButton(
                title: buttonTitle,
                suffixIcon: "calendar"
            ) {

                onBook?()
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
