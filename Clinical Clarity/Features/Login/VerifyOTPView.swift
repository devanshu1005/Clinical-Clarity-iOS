//
//  VerifyOTPView.swift
//  Clinical Clarity
//

import SwiftUI

struct VerifyOTPView: View {

    let email: String

    @EnvironmentObject var appFlow: AppFlowManager
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = VerifyOTPViewModel()

    @FocusState private var isOTPFocused: Bool

    var body: some View {

        ZStack {

            Color.appBackground
                .ignoresSafeArea()

            // MARK: Background Blur
            ZStack {

                Ellipse()
                    .fill(Color.brandAccentBlue.opacity(0.35))
                    .frame(width: 400, height: 400)
                    .blur(radius: 32)
                    .offset(x: 120, y: -220)

                Ellipse()
                    .fill(Color.brandAccentGreen.opacity(0.30))
                    .frame(width: 350, height: 350)
                    .blur(radius: 32)
                    .offset(x: -120, y: 330)
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Header

                HStack {

                    Button {

//                        dismiss()
                        appFlow.moveToLogin()

                    } label: {

                        Image(systemName: "chevron.left")
                            .font(.appIconMedium)
                            .foregroundColor(.brandPrimary)
                            .frame(width: 40, height: 40)
                    }

                    Spacer()

                    Text("Verify OTP")
                        .font(.title2.bold())
                        .foregroundColor(.brandPrimary)

                    Spacer()

                    Color.clear
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal,20)
                .frame(height:64)

                ScrollView(showsIndicators: false) {

                    VStack(spacing: 48) {
                        
                        // MARK: Header Text
                        
                        VStack(spacing: 12) {
                            
                            Text("Enter Verification Code")
                                .font(.appTitle)
                                .foregroundColor(.textPrimary)
                            
                            Text("We've sent a verification code to")
                                .font(.appBody)
                                .foregroundColor(.textSecondary)
                            
                            Text(email)
                                .font(.appBodyMedium)
                                .foregroundColor(.brandPrimary)
                        }
                        .multilineTextAlignment(.center)
                        .padding(.top,30)
                        
                        // MARK: OTP Card
                        
                        VStack(alignment: .leading, spacing: 24) {
                            
                            Text("Verification Code")
                                .font(.appLabel)
                                .foregroundColor(.textSecondary)
                            
                            ZStack {
                                
                                // Hidden TextField
                                
                                TextField("", text: $viewModel.otp)
                                    .keyboardType(.numberPad)
                                    .textContentType(.oneTimeCode)
                                    .focused($isOTPFocused)
                                    .foregroundColor(.clear)
                                    .accentColor(.clear)
                                    .frame(width: 1, height: 1)
                                    .opacity(0.01)
                                    .onChange(of: viewModel.otp) { newValue in
                                        
                                        let filtered = newValue.filter {
                                            $0.isNumber
                                        }
                                        
                                        if filtered.count > 6 {
                                            viewModel.otp = String(filtered.prefix(6))
                                        } else {
                                            viewModel.otp = filtered
                                        }
                                    }
                                
                                HStack(spacing: 10) {
                                    
                                    ForEach(0..<6,id:\.self) { index in
                                        
                                        otpBox(index)
                                    }
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                
                                isOTPFocused = true
                            }
                            
                            HStack(spacing:4) {
                                
                                Text("Didn't receive the code?")
                                    .font(.appLabel)
                                    .foregroundColor(.textSecondary)
                                
                                Button {
                                    
                                    // TODO:
                                    // Call Request OTP API again
                                    
                                } label: {
                                    
                                    Text("Resend")
                                        .font(.appLabelBold)
                                        .foregroundColor(.brandPrimary)
                                }
                            }
                            .frame(maxWidth:.infinity)
                            
                        }
                        .padding(24)
                        .background(Color.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.borderDefault)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 32)
                        )
                        .shadow(
                            color: .black.opacity(0.05),
                            radius: 8,
                            x: 0,
                            y: 2
                        )
                        
                        if let error = viewModel.errorMessage {
                            
                            Text(error)
                                .font(.appCaptionMedium)
                                .foregroundColor(.red)
                        }
                        
                        BrandedActionButton(
                            title: viewModel.isLoading
                            ? "Verifying..."
                            : "Verify OTP",
                            suffixIcon: viewModel.isLoading
                            ? nil
                            : "checkmark"
                        ) {
                            
                            hideKeyboard()
                               isOTPFocused = false
                            
                            guard !viewModel.isLoading else {
                                return
                            }
                            
                            Task {
                                
                                let success = await viewModel.verifyOTP(
                                    email: email,
                                    authManager: authManager
                                )
                                
                                if success {
                                    
                                    appFlow.moveToDashboard()
                                }
                            }
                        }
                        
                        // MARK: Security Card

                        HStack(alignment: .top, spacing: 16) {

                            ZStack {

                                Circle()
                                    .fill(Color.brandAccentGreen)

                                Image(systemName: "lock.shield.fill")
                                    .font(.appIconMedium)
                                    .foregroundColor(.green)
                            }
                            .frame(width: 40, height: 40)

                            VStack(alignment: .leading, spacing: 8) {

                                Text("Secure Verification")
                                    .font(.appLabel)
                                    .foregroundColor(.textPrimary)

                                Text("Your verification code expires in a few minutes. Never share this code with anyone.")
                                    .font(.appBody)
                                    .foregroundColor(.textSecondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer()
                        }
                        .padding(24)
                        .background(
                            Color(red: 238/255,
                                  green: 238/255,
                                  blue: 240/255)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.borderDefault)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }.onTapGesture {
            hideKeyboard()
            isOTPFocused = false
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isOTPFocused = true
            }
        }
    }

    // MARK: OTP Box

    @ViewBuilder
    private func otpBox(_ index: Int) -> some View {

        let characters = Array(viewModel.otp)

        let value: String = index < characters.count
            ? String(characters[index])
            : ""

//        let active = index == min(viewModel.otp.count, 5)
        let active = isOTPFocused && index == min(viewModel.otp.count, 5)

        Text(value)
            .font(.appTitle)
            .foregroundColor(.textPrimary)
            .frame(width: 48, height: 56)
            .background(Color.inputBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        active
                        ? Color.brandPrimary
                        : Color.borderDefault,
                        lineWidth: active ? 2 : 1.5
                    )
            )
            .overlay {

                if active {

                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            Color.brandPrimary.opacity(0.25),
                            lineWidth: 4
                        )
                }
            }
            .animation(.easeInOut(duration: 0.2), value: viewModel.otp)
    }
}

#Preview {
    VerifyOTPView(
        email: "test@example.com"
    )
}
