//
//  EditProfileViewModel.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 23/07/26.
//

import Foundation
import SwiftUI
import Combine
import PhotosUI

@MainActor
final class EditProfileViewModel: ObservableObject {
    
    private weak var authManager: AuthManager?
    
    @Published var selectedPhoto: PhotosPickerItem?

    // MARK: - Form Fields

    @Published var name = ""
    @Published var gender = ""
    @Published var age = ""
    @Published var bloodGroup = ""
    @Published var mobileNumber = ""

    @Published var line1 = ""
    @Published var line2 = ""
    @Published var city = ""
    @Published var state = ""
    @Published var postalCode = ""
    @Published var country = ""

    // MARK: - Image

    @Published var selectedImage: UIImage?
    @Published var existingImageURL: String?

    // MARK: - UI State

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSaved = false

    // MARK: - Dropdown Data

    let genders = [
        "Male",
        "Female",
        "Other"
    ]

    let bloodGroups = [
        "A+",
        "A-",
        "B+",
        "B-",
        "AB+",
        "AB-",
        "O+",
        "O-"
    ]


    @Published private(set) var profile: UserProfile?
    
    func configure(authManager: AuthManager) {

        guard self.authManager == nil else {
            return
        }

        self.authManager = authManager

        if let currentUser = authManager.currentUser {
            populate(with: currentUser)
        }
    }
    
    // MARK: - Populate Form

    func populate(with profile: UserProfile) {

        self.profile = profile

        name = profile.name
        gender = profile.gender ?? ""
        age = profile.age.map(String.init) ?? ""
        bloodGroup = profile.bloodGroup ?? ""
        mobileNumber = profile.mobileNumber

        line1 = profile.address.line1
        line2 = profile.address.line2
        city = profile.address.city
        state = profile.address.state
        postalCode = profile.address.postalCode
        country = profile.address.country

        existingImageURL = profile.profileImage
    }

    // MARK: - Validation

    var isValid: Bool {

        !name.isEmpty &&
        !gender.isEmpty &&
        !bloodGroup.isEmpty &&
        !mobileNumber.isEmpty &&
        !line1.isEmpty &&
        !city.isEmpty &&
        !state.isEmpty &&
        !postalCode.isEmpty &&
        !country.isEmpty &&
        Int(age) != nil
    }
    
    func loadSelectedPhoto() async {

        guard let selectedPhoto else {
            return
        }

        do {

            if let data = try await selectedPhoto.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {

                selectedImage = image
            }

        } catch {

            errorMessage = "Unable to load selected image."
        }
    }

    // MARK: - Save

    func saveProfile() async {

        guard isValid else {

            errorMessage = "Please fill all required fields."

            return
        }

        isLoading = true
        errorMessage = nil

        defer {

            isLoading = false
        }

        do {

            let parameters = [

                "name": name,
                "gender": gender,
                "age": age,
                "bloodGroup": bloodGroup,
                "mobileNumber": mobileNumber,

                "address[line1]": line1,
                "address[line2]": line2,
                "address[city]": city,
                "address[state]": state,
                "address[postalCode]": postalCode,
                "address[country]": country
            ]

            let images = [

                "profileImage": selectedImage
            ]

            let response: ProfileResponse =
            try await APIClient.shared.multipartRequestWithImages(

                endpoint: .updateProfile,

                parameters: parameters,

                images: images,

                requiresAuth: true
            )

            authManager?.currentUser = response.data

            populate(with: response.data)

            isSaved = true

        } catch {

            errorMessage = error.localizedDescription
        }
    }
}
