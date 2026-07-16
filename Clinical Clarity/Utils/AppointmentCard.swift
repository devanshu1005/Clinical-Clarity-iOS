//
//  AppointmentCard.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 16/07/26.
//

import SwiftUI

struct AppointmentCard: View {

    let appointment: Appointment

        var buttonTitle: String = "View Appointment"

        var showButton: Bool = true

        var onTap: (() -> Void)?

    var body: some View {

        VStack(spacing: 20) {

            HStack(alignment: .top, spacing: 16) {

                AsyncImage(
                    url: URL(
                        string: appointment.doctorId.profileImage ?? ""
                    )
                ) { image in

                    image
                        .resizable()
                        .scaledToFill()

                } placeholder: {

                    Circle()
                        .fill(Color.brandAccentBlue)
                }
                .frame(width: 70, height: 70)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 6) {

                    Text(appointment.doctorId.name)
                        .font(.appBodySemibold)
                        .foregroundColor(.textPrimary)

                    Text(appointment.doctorId.specialization)
                        .font(.appLabel)
                        .foregroundColor(.textSecondary)

                    Text(appointment.clinicId.name)
                        .font(.appCaptionMedium)
                        .foregroundColor(.textSecondary)
                }

                Spacer()
            }

            Divider()

            HStack {

                Label(
                    appointment.appointmentDate,
                    systemImage: "calendar"
                )
                .font(.appCaptionMedium)

                Spacer()

                Label(
                    "\(appointment.startTime) - \(appointment.endTime)",
                    systemImage: "clock"
                )
                .font(.appCaptionMedium)
            }

            BrandedActionButton(
                title: buttonTitle,
                suffixIcon: "arrow.right"
            ) {

//                onViewAppointment?()
                onTap?()
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
