//
//  DoctorSearchView.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 16/07/26.
//

//
//  DoctorSearchView.swift
//

import SwiftUI
import Combine

struct DoctorSearchView: View {

    @EnvironmentObject
    private var navigationManager: NavigationManager

    @StateObject
    private var viewModel = DoctorSearchViewModel()

    @FocusState
    private var isSearchFocused: Bool

    @State
    private var searchTask: Task<Void, Never>?

    var body: some View {

        ZStack {

            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 20) {

                searchBar

                content
            }
            .padding(.horizontal,20)
            .padding(.top,10)
        }
        .navigationTitle("Search Doctors")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {

            Task {

                try? await Task.sleep(for: .milliseconds(250))

                isSearchFocused = true
            }
        }
        .onTapGesture {

            hideKeyboard()

            isSearchFocused = false
        }
    }
}

private extension DoctorSearchView {

    var searchBar: some View {

        HStack(spacing:12){

            Image(systemName:"magnifyingglass")
                .foregroundColor(.textSecondary)

            TextField(
                "Search doctors...",
                text:$viewModel.searchText
            )
            .focused($isSearchFocused)
            .font(.appBody)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .onChange(of: viewModel.searchText) { _ in

                searchTask?.cancel()

                searchTask = Task {

                    try? await Task.sleep(
                        for: .milliseconds(300)
                    )

                    guard !Task.isCancelled else {
                        return
                    }

                    await viewModel.searchDoctors()
                }
            }

            if !viewModel.searchText.isEmpty {

                Button {

                    viewModel.clearResults()

                } label: {

                    Image(systemName:"xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal,18)
        .frame(height:56)
        .background(Color.cardBackground)
        .overlay{

            RoundedRectangle(cornerRadius:16)
                .stroke(Color.borderDefault)
        }
        .clipShape(
            RoundedRectangle(cornerRadius:16)
        )
    }
}

private extension DoctorSearchView {

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

        else if viewModel.searchText.isEmpty {

            Spacer()

            VStack(spacing:16){

                Image(systemName:"stethoscope.circle")
                    .font(.system(size:70))
                    .foregroundColor(.brandPrimary)

                Text("Search Doctors")
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


private extension DoctorSearchView {

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
