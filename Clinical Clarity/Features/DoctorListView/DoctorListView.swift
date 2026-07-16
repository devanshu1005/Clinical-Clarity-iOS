//
//  DoctorListView.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 16/07/26.
//

import SwiftUI

struct DoctorListView: View {

    let specialization: String

    var body: some View {

        ZStack {

            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 24) {

                Image(systemName: "stethoscope.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .foregroundColor(.brandPrimary)

                Text("Doctor List")
                    .font(.appTitle)
                    .foregroundColor(.brandPrimary)

                Text("Selected Specialization")
                    .font(.appLabel)
                    .foregroundColor(.textSecondary)

                Text(specialization)
                    .font(.appBodySemibold)
                    .foregroundColor(.textPrimary)

                Spacer()
            }
            .padding(.top, 60)
        }
        .navigationTitle("Doctors")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {

            print("========== Doctor List ==========")
            print("Specialization:", specialization)
            print("=================================")
        }
    }
}

#Preview {

    NavigationStack {

        DoctorListView(
            specialization: "Cardiologist"
        )
    }
}
