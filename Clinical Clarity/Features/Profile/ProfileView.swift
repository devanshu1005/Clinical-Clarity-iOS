//
//  ProfileView.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 23/07/26.
//

import SwiftUI

struct ProfileView: View {

    @ObservedObject var viewModel: DashboardViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject var appFlow: AppFlowManager

    @EnvironmentObject
    private var authManager: AuthManager
    
    @State private var showLogoutConfirmation = false

    var body: some View {

        ZStack {

            Color.appBackground
                .ignoresSafeArea()

            if viewModel.isLoading {

                ProgressView()

            } else if let error = viewModel.errorMessage {

                VStack(spacing: 20) {

                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 42))
                        .foregroundColor(.orange)

                    Text(error)
                        .multilineTextAlignment(.center)

                    Button("Retry") {

                        Task {
                            await viewModel.loadDashboard()
                        }
                    }
                }

            } else {

                ScrollView(showsIndicators: false) {

                    VStack(spacing: 24) {

                        profileCard

                        accountSection

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal,20)
                    .padding(.top,20)
                }
            }
        }
        .navigationTitle("Profile")
        .alert(
            "Logout",
            isPresented: $showLogoutConfirmation
        ) {

            Button("Cancel", role: .cancel) { }

            Button("Logout", role: .destructive) {

                authManager.logout()

                navigationManager.reset()

                appFlow.moveToLogin()
            }

        } message: {

            Text("Are you sure you want to logout?")
        }
    }
}

private extension ProfileView {

    var profileCard: some View {

        VStack(spacing: 24) {

            profileImage

            VStack(spacing: 8) {

                Text(authManager.currentUser?.name ?? "")
                    .font(.appTitle)
                    .foregroundColor(.brandPrimary)

                chips
                    .frame(maxWidth: .infinity, alignment: .center)

                VStack(spacing: 12) {

                    profileRow(
                        icon: "phone.fill",
                        text: authManager.currentUser?.mobileNumber ?? ""
                    )

                    profileRow(
                        icon: "envelope.fill",
                        text: authManager.currentUser?.email ?? ""
                    )

                    profileRow(
                        icon: "location.fill",
                        text: authManager.currentUser?.address.formattedAddress ?? "Address not added"
                    )
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(24)
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

private extension ProfileView {

    var profileImage: some View {

        ZStack(alignment:.bottomTrailing) {

            AsyncImage(
                url: URL(string: authManager.currentUser?.profileImage ?? "")
            ) { image in

                image
                    .resizable()
                    .scaledToFill()

            } placeholder: {

                Image(systemName:"person.fill")
                    .font(.system(size:36))
                    .foregroundColor(.brandPrimary)
            }
            .frame(width:96,height:96)
            .background(Color.white)
            .clipShape(Circle())
            .overlay {

                Circle()
                    .stroke(Color.brandAccentBlue,lineWidth:4)
            }

            Button {

            } label: {

                Image(systemName:"camera.fill")
                    .font(.system(size:12))
                    .foregroundColor(.white)
                    .frame(width:30,height:30)
                    .background(Color.brandPrimary)
                    .clipShape(Circle())
            }
        }
    }
}

private extension ProfileView {

    var chips: some View {

        HStack(spacing: 8) {

            if let gender = authManager.currentUser?.gender,
               !gender.isEmpty {

                chip(
                    title: gender,
                    color: .brandAccentBlue
                )
            }

            if let age = authManager.currentUser?.age {

                chip(
                    title: "\(age) Years",
                    color: .brandAccentBlue
                )
            }

            if let bloodGroup = authManager.currentUser?.bloodGroup,
               !bloodGroup.isEmpty {

                chip(
                    title: bloodGroup,
                    color: .brandAccentBlue
                )
            }

            if !(authManager.currentUser?.isProfileComplete ?? false) {

                chip(
                    title: "Complete Profile",
                    color: Color.red.opacity(0.15),
                    foreground: .red
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    func chip(
        title: String,
        color: Color,
        foreground: Color = .brandPrimary
    ) -> some View {

        Text(title)
            .font(.appCaptionBold)
            .foregroundColor(foreground)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(color)
            .clipShape(Capsule())
    }
}

private extension ProfileView {

    func profileRow(
        icon: String,
        text: String
    ) -> some View {

        HStack(spacing: 12) {

            Image(systemName: icon)
                .foregroundColor(.brandPrimary)

            Text(text)
                .font(.appBody)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

private extension ProfileView {

    var accountSection: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text("Account Settings")
                .font(.appTitle2)

            VStack(spacing: 0) {

                menuRow(
                    icon: "person.crop.circle",
                    title: "Edit Profile"
                ) {
                    navigationManager.push(.editProfile)
                }

                Divider()

                menuRow(
                    icon: "person.2.fill",
                    title: "Family Members"
                ) {
                    print("Family Members pressed")
                }

                Divider()

                menuRow(
                    icon: "bell.fill",
                    title: "Notifications"
                ) {
                    print("Notifications pressed")
                }

                Divider()

                menuRow(
                    icon: "lock.fill",
                    title: "Privacy Policy"
                ) {
                    print("Privacy Policy pressed")
                }

                Divider()

                menuRow(
                    icon: "questionmark.circle.fill",
                    title: "Help & Support"
                ) {
                    print("Help & Support pressed")
                }

                Divider()

                logoutRow
            }
            .background(Color.cardBackground)
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.borderDefault)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }
}

private extension ProfileView {

    func menuRow(
        icon: String,
        title: String,
        action: @escaping () -> Void
    ) -> some View {

        Button(action: action) {

            HStack {

                ZStack {

                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.brandAccentBlue)

                    Image(systemName: icon)
                        .foregroundColor(.brandPrimary)
                }
                .frame(width: 48, height: 48)

                Text(title)
                    .font(.appBody)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.textSecondary)
            }
            .padding(24)
        }
        .buttonStyle(.plain)
    }
}

private extension ProfileView {

    var logoutRow: some View {

        Button {
            
            showLogoutConfirmation = true

        } label: {

            HStack {

                ZStack {

                    RoundedRectangle(cornerRadius:12)
                        .fill(Color.red.opacity(0.12))

                    Image(systemName:"rectangle.portrait.and.arrow.right")
                        .foregroundColor(.red)
                }
                .frame(width:48,height:48)

                Text("Logout")
                    .font(.appBodySemibold)
                    .foregroundColor(.red)

                Spacer()
            }
            .padding(24)
        }
        .buttonStyle(.plain)
    }
}
