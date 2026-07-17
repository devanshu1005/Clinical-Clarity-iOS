//
//  DoctorListView.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 16/07/26.
//

import SwiftUI

struct DoctorListView: View {
    
    @EnvironmentObject
    private var navigationManager: NavigationManager
    
    @StateObject
    private var viewModel = DoctorListViewModel()

    let specialization: String

    var body: some View {

        ZStack {

            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 20) {
                content
            }
            .padding(.horizontal,20)
            .padding(.top,10)
        }
        .navigationTitle("Search Doctors")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {

            Task {

//                try? await Task.sleep(for: .milliseconds(250))

                viewModel.searchText = specialization
                await viewModel.searchDoctors()
            }
        }
        .onTapGesture {
            //
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


private extension DoctorListView {

    @ViewBuilder
    var content: some View {

        if viewModel.isLoading {

            Spacer()

            ProgressView()

            Spacer()
        }

        else if let error = viewModel.errorMessage {

            Spacer()

            VStack(spacing:12){

                Image(systemName:"exclamationmark.triangle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.orange)

                Text(error)
                    .font(.appBody)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }

        else if specialization.isEmpty {

            Spacer()

            VStack(spacing:16){

                Image(systemName:"stethoscope.circle")
                    .font(.system(size:70))
                    .foregroundColor(.brandPrimary)

                Text("{specialization} Doctors")
                    .font(.appTitle)

                Text("Search by doctor name or speciality.")
                    .font(.appBody)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }

        else if viewModel.doctors.isEmpty {

            Spacer()

            VStack(spacing:16){

                Image(systemName:"person.crop.circle.badge.questionmark")
                    .font(.system(size:60))
                    .foregroundColor(.gray)

                Text("No Doctors Found")
                    .font(.appBodySemibold)

                Text("Try another keyword.")
                    .font(.appBody)
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }

        else {

            doctorList
        }
    }
}


private extension DoctorListView {

    var doctorList: some View {

        ScrollView(showsIndicators:false){

            LazyVStack(spacing:18){

                ForEach(viewModel.doctors,id:\.id){ doctor in

                    UniversalDoctorCard(

                        imageURL: doctor.profileImage,

                        name: doctor.name,

                        specialization: doctor.specialization,

                        rating: doctor.averageRating,

                        experience: doctor.experienceYears,

                        clinicName: doctor.clinics?.first?.name,

                        address: doctor.clinics?.first?.shortAddress,

                        consultationFee: doctor.consultationFee,

                        buttonTitle: "View Profile"

                    ){

                        navigationManager.push(
                            .doctorDetails(
                                id: doctor.id
                            )
                        )
                    }
                }
            }
            .padding(.bottom,20)
        }
        .scrollDismissesKeyboard(.interactively)
    }
}
