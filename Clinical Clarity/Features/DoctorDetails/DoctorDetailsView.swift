//
//  DoctorDetailsView.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 16/07/26.
//

import SwiftUI

struct DoctorDetailsView: View {

    let doctorId: String

    var body: some View {

        ZStack {

            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 24) {

                Image(systemName: "stethoscope.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.brandPrimary)

                Text("Doctor Details")
                    .font(.appTitle)
                    .foregroundColor(.brandPrimary)

                Text("Doctor ID")
                    .font(.appLabel)
                    .foregroundColor(.textSecondary)

                Text(doctorId)
                    .font(.appBody)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 80)
        }
        .navigationTitle("Doctor")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {

            print("========== Doctor Details ==========")
            print("Doctor ID:", doctorId)
            print("====================================")
        }
    }
}

#Preview {
    NavigationStack {
        DoctorDetailsView(
            doctorId: "doctor_123456"
        )
    }
}
