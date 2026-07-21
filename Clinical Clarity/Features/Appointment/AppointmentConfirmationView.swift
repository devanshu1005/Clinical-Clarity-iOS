//
//  AppointmentConfirmationView.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 21/07/26.
//

import SwiftUI

struct AppointmentConfirmationView: View {
    
    @EnvironmentObject private var navigationManager: NavigationManager

    let appointment: Appointment

    var body: some View {

        ScrollView {

            VStack(spacing: 32) {

                Spacer()
                    .frame(height: 20)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 90))
                    .foregroundColor(.green)

                VStack(spacing: 8) {

                    Text("Appointment Confirmed!")
                        .font(.title2.bold())

                    Text("Your appointment has been booked successfully.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 20) {

                    detailRow(
                        title: "Appointment ID",
                        value: appointment.id
                    )

                    detailRow(
                        title: "Status",
                        value: appointment.status
                    )

                    detailRow(
                        title: "Date",
                        value: appointment.appointmentDate
                    )

                    detailRow(
                        title: "Time",
                        value: "\(appointment.startTime) - \(appointment.endTime)"
                    )
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.05), radius: 8)

                Button {
                    
                     navigationManager.popToRoot()

                } label: {

                    Text("Done")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandPrimary)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Spacer()
            }
            .padding(20)
        }
        .background(Color.appBackground)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Appointment")
    }

    @ViewBuilder
    private func detailRow(
        title: String,
        value: String
    ) -> some View {

        HStack {

            Text(title)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
        }
    }
}

//#Preview {
//
//    AppointmentConfirmationView(
//        appointment: Appointment(
//            id: "APT123456",
//            doctorId: "doctor123",
//            clinicId: "clinic123",
//            patientId: "patient123",
//            appointmentDate: "24 Jul 2026",
//            startTime: "12:00 PM",
//            endTime: "12:30 PM",
//            status: "BOOKED"
//        )
//    )
//}
