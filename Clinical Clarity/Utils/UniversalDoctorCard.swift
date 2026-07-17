//
//  UniversalDoctorCard.swift
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

            topSection

            bottomSection
        }
        .padding(24)
        .background(Color.cardBackground)
        .overlay {

            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.borderDefault, lineWidth: 1)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
        .shadow(
            color: .black.opacity(0.05),
            radius: 8,
            x: 0,
            y: 2
        )
    }
}

// MARK: - Top Section

private extension UniversalDoctorCard {

    var topSection: some View {

        HStack(alignment: .top, spacing: 24) {

            doctorImage

            doctorInfo
        }
    }

    var doctorImage: some View {

        AsyncImage(
            url: URL(string: imageURL ?? "")
        ) { image in

            image
                .resizable()
                .scaledToFill()

        } placeholder: {

            Rectangle()
                .fill(Color.brandAccentBlue)
        }
        .frame(width: 96, height: 96)
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
        .overlay {

            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.borderDefault)
        }
    }

    var doctorInfo: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack(alignment: .top) {

                VStack(alignment: .leading, spacing: 4) {

                    Text(name)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .lineLimit(2)

                    Text(specialization)
                        .font(.appBody)
                        .foregroundColor(.brandPrimary)
                }

                Spacer(minLength: 12)

                if rating != nil {

                    ratingBadge
                }
            }

            experienceRow

            availabilityRow

            if clinicName != nil || address != nil || distance != nil {

                clinicSection
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var ratingBadge: some View {

        HStack(spacing: 4) {

            Image(systemName: "star.fill")
                .font(.system(size: 12))
                .foregroundColor(Color(red: 0/255,
                                       green: 114/255,
                                       blue: 54/255))

            Text(
                String(format: "%.1f", rating ?? 0)
            )
            .font(.appBody)
            .foregroundColor(
                Color(red: 0/255,
                      green: 114/255,
                      blue: 54/255)
            )
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Color(
                red: 117/255,
                green: 249/255,
                blue: 153/255
            )
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
    }

    var experienceRow: some View {

        HStack(spacing: 4) {

            Image(systemName: "stethoscope")
                .font(.system(size: 12))
                .foregroundColor(.textSecondary)

            Text(
                "\(experience ?? 0) Years Experience"
            )
            .font(.appCaptionMedium)
            .foregroundColor(.textSecondary)
        }
    }

    var availabilityRow: some View {

        HStack(spacing: 4) {

            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(
                    Color(
                        red: 0/255,
                        green: 109/255,
                        blue: 51/255
                    )
                )

            Text(
                isAvailable
                ? "Available Today"
                : "Unavailable"
            )
            .font(.appBody)
            .foregroundColor(
                isAvailable
                ? Color(
                    red: 0/255,
                    green: 109/255,
                    blue: 51/255
                )
                : .red
            )
        }
    }
    
    var clinicSection: some View {

        VStack(alignment: .leading, spacing: 6) {

            if let clinicName {

                HStack(spacing: 6) {

                    Image(systemName: "cross.case.fill")
                        .font(.caption)

                    Text(clinicName)
                        .font(.appCaptionMedium)
                }
                .foregroundColor(.textPrimary)
            }

            if let address {

                HStack(spacing: 6) {

                    Image(systemName: "mappin.and.ellipse")

                    Text(address)
                        .lineLimit(1)
                }
                .font(.appCaptionMedium)
                .foregroundColor(.textSecondary)
            }

            if let distance {

                HStack(spacing: 6) {

                    Image(systemName: "location")

                    Text(String(format: "%.1f km away", distance))
                }
                .font(.appCaptionMedium)
                .foregroundColor(.textSecondary)
            }
        }
    }
}

private extension UniversalDoctorCard {

    var bottomSection: some View {

        HStack(alignment: .center) {

            consultationSection

            Spacer()

            bookButton
        }
        .padding(.top, 24)
        .overlay(alignment: .top) {

            Divider()
        }
    }

    var consultationSection: some View {

        VStack(alignment: .leading, spacing: 4) {

            Text("Consultation Fee")
                .font(.appCaptionMedium)
                .foregroundColor(.textSecondary)

            Text(feeText)
                .font(.appBody)
                .foregroundColor(.textPrimary)
        }
    }

    var feeText: String {

        guard let consultationFee else {
            return "—"
        }

        return "₹\(consultationFee)"
    }

    var bookButton: some View {

        Button {

            onButtonTap?()

        } label: {

            HStack(spacing: 10) {

                Image(systemName: "calendar.badge.plus")

                Text(buttonTitle)
            }
            .font(.appBody)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .frame(height: 48)
            .background(Color.brandPrimary)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
