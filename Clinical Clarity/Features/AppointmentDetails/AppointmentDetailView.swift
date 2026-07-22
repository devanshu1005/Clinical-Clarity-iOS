//
//  AppointmentDetailView.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 22/07/26.
//

import SwiftUI

struct AppointmentDetailView: View {

    @StateObject
    private var viewModel: AppointmentDetailViewModel

    init(appointmentId: String) {

        _viewModel = StateObject(
            wrappedValue: AppointmentDetailViewModel(
                appointmentId: appointmentId
            )
        )
    }

    var body: some View {

        ScrollView {

            if viewModel.isLoading {

                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 80)

            } else if let error = viewModel.errorMessage {

                VStack(spacing: 16) {

                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 48))
                        .foregroundColor(.orange)

                    Text(error)
                        .foregroundColor(.textSecondary)
                }
                .padding(.top, 80)

            } else if let appointment = viewModel.appointment {

                VStack(spacing: 28) {

                    doctorSection(appointment)

                    appointmentSection(appointment)

                    clinicSection(appointment)
                }
                .padding(20)
            }
        }
        .background(Color.appBackground)
        .navigationTitle("Appointment")
        .navigationBarTitleDisplayMode(.inline)
        .task {

            await viewModel.loadAppointment()
        }
    }
}

private extension AppointmentDetailView {

    func doctorSection(
        _ appointment: UpcomingAppointments
    ) -> some View {

        HStack(spacing: 16) {

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
            .frame(width: 80, height: 80)
            .clipShape(Circle())

            VStack(
                alignment: .leading,
                spacing: 6
            ) {

                Text(appointment.doctorId.name)
                    .font(.appBodySemibold)

                Text(appointment.doctorId.specialization)
                    .font(.appBody)

                Text(appointment.doctorId.qualification ?? "")
                    .font(.appCaption)
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
        .padding(20)
        .background(Color.cardBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
}

private extension AppointmentDetailView {

    func appointmentSection(
        _ appointment: UpcomingAppointments
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 20
        ) {

            Text("Appointment Details")
                .font(.appBodySemibold)

            detailRow(
                title: "Date",
                value: appointment.appointmentDate,
                icon: "calendar"
            )

            detailRow(
                title: "Time",
                value: "\(appointment.startTime) - \(appointment.endTime)",
                icon: "clock"
            )

            detailRow(
                title: "Status",
                value: appointment.status,
                icon: "checkmark.circle"
            )
        }
        .padding(20)
        .background(Color.cardBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
}

private extension AppointmentDetailView {

    func clinicSection(
        _ appointment: UpcomingAppointments
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            Text("Clinic")
                .font(.appBodySemibold)

            Text(appointment.clinicId.name)
                .font(.appBody)

            Text(appointment.clinicId.shortAddress ?? "")
                .font(.appCaption)
                .foregroundColor(.textSecondary)
        }
        .padding(20)
        .background(Color.cardBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
    }
}

private extension AppointmentDetailView {

    func detailRow(
        title: String,
        value: String,
        icon: String
    ) -> some View {

        HStack {

            Label(
                title,
                systemImage: icon
            )

            Spacer()

            Text(value)
                .foregroundColor(.textSecondary)
        }
        .font(.appBody)
    }
}
