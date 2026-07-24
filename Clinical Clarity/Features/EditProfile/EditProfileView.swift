//
//  EditProfileView.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 23/07/26.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {

    @Environment(\.dismiss)
    private var dismiss
    
    @EnvironmentObject
    private var authManager: AuthManager
    
    @StateObject
    private var viewModel = EditProfileViewModel()
 

    var body: some View {

        ZStack {

            Color.appBackground
                .ignoresSafeArea()

            ScrollView {

                VStack(spacing: 24) {

                    profileImageSection

                    personalInformationSection

                    addressSection

                    saveButton
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }

            if viewModel.isLoading {

                Color.black.opacity(0.25)
                    .ignoresSafeArea()

                ProgressView()
                    .controlSize(.large)
            }
        }.task {
            
            viewModel.configure(authManager: authManager)
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            "Error",
            isPresented: Binding(
                get: {
                    viewModel.errorMessage != nil
                },
                set: { _ in
                    viewModel.errorMessage = nil
                }
            )
        ) {

            Button("OK") { }

        } message: {

            Text(viewModel.errorMessage ?? "")
        }
        .onChange(of: viewModel.isSaved) { saved in

            guard saved else {
                return
            }

            dismiss()
        }
    }
}

private extension EditProfileView {

    var personalInformationSection: some View {

        VStack(alignment: .leading, spacing: 20) {

            Text("Personal Information")
                .font(.appTitle2)

            AppTextField(
                title: "Full Name",
                placeholder: "Enter your name",
                text: $viewModel.name
            )

            AppPickerField(
                title: "Gender",
                selection: $viewModel.gender,
                options: viewModel.genders
            )

            AppTextField(
                title: "Age",
                placeholder: "Enter age",
                text: $viewModel.age,
                keyboardType: .numberPad
            )

            AppPickerField(
                title: "Blood Group",
                selection: $viewModel.bloodGroup,
                options: viewModel.bloodGroups
            )

            AppTextField(
                title: "Mobile Number",
                placeholder: "Enter mobile number",
                text: $viewModel.mobileNumber,
                keyboardType: .phonePad
            )
        }
        .padding(20)
        .background(Color.cardBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
        .overlay {

            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.borderDefault)
        }
    }
}

private extension EditProfileView {

    var addressSection: some View {

        VStack(alignment: .leading, spacing: 20) {

            Text("Address")
                .font(.appTitle2)

            AppTextField(
                title: "Address Line 1",
                placeholder: "Flat / House No.",
                text: $viewModel.line1
            )

            AppTextField(
                title: "Address Line 2",
                placeholder: "Street / Area",
                text: $viewModel.line2
            )

            AppTextField(
                title: "City",
                placeholder: "City",
                text: $viewModel.city
            )

            AppTextField(
                title: "State",
                placeholder: "State",
                text: $viewModel.state
            )

            AppTextField(
                title: "Postal Code",
                placeholder: "Postal Code",
                text: $viewModel.postalCode,
                keyboardType: .numberPad
            )

            AppTextField(
                title: "Country",
                placeholder: "Country",
                text: $viewModel.country
            )
        }
        .padding(20)
        .background(Color.cardBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: 24)
        )
        .overlay {

            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.borderDefault)
        }
    }
}

private extension EditProfileView {

    var saveButton: some View {

        Button {

            Task {

                await viewModel.saveProfile()
            }

        } label: {

            Text("Save Changes")
                .font(.appBodySemibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.brandPrimary)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )
        }
        .disabled(viewModel.isLoading)
    }
}

private extension EditProfileView {

    var profileImageSection: some View {

        VStack(spacing: 16) {

            ZStack(alignment: .bottomTrailing) {

                Group {

                    if let image = viewModel.selectedImage {

                        Image(uiImage: image)
                            .resizable()

                    } else if let url = viewModel.existingImageURL,
                              let imageURL = URL(string: url) {

                        AsyncImage(url: imageURL) { phase in

                            switch phase {

                            case .success(let image):

                                image
                                    .resizable()

                            default:

                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .padding(24)
                                    .foregroundColor(.gray.opacity(0.5))
                            }

                        }

                    } else {

                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .padding(24)
                            .foregroundColor(.gray.opacity(0.5))
                    }
                }
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay {

                    Circle()
                        .stroke(
                            Color.brandPrimary,
                            lineWidth: 3
                        )
                }

                PhotosPicker(

                    selection: $viewModel.selectedPhoto,

                    matching: .images,

                    photoLibrary: .shared()

                ) {

                    Image(systemName: "camera.fill")
                        .font(.appIconMedium)
                        .foregroundColor(.white)
                        .frame(width: 38, height: 38)
                        .background(Color.brandPrimary)
                        .clipShape(Circle())
                }
            }

            Text("Tap to change profile photo")
                .font(.appCaption)
                .foregroundColor(.textSecondary)
        }
        .task(id: viewModel.selectedPhoto) {

            await viewModel.loadSelectedPhoto()
        }
    }
}
