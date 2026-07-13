//
//  LoginView.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 10/07/26.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    
    var body: some View {
        ZStack {
            // MARK: - Base Background
            Color.appBackground
                .ignoresSafeArea()
            
            // MARK: - Decorative Blurs
            backgroundDecorations
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer(minLength: 0)
                    
                    VStack(spacing: 64) {
                        
                        // MARK: - Hero Header Section
                        heroSection
                        
                        // MARK: - Login Form Card
                        loginCard
                        
                        // MARK: - Footer Navigation
                        footerSection
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: 440)
                    .padding(.top, 40)
                    .padding(.bottom, 40)
                    
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: UIScreen.main.bounds.height)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - UI Sections
private extension LoginView {
    
    var backgroundDecorations: some View {
        ZStack {
            // Top-right blue blur
            Ellipse()
                .fill(Color.brandAccentBlue.opacity(0.45))
                .frame(width: 195, height: 442)
                .blur(radius: 60)
                .offset(x: 120, y: -180)
            
            // Bottom-left green blur
            Ellipse()
                .fill(Color.brandAccentGreen.opacity(0.35))
                .frame(width: 156, height: 354)
                .blur(radius: 50)
                .offset(x: -130, y: 320)
        }
        .ignoresSafeArea()
    }
    
    var heroSection: some View {
        VStack(spacing: 24) {
            
            // Branding/Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.brandSecondary)
                    .frame(width: 64, height: 64)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                Image(systemName: "cross.case.fill")
                    .font(.appIconLarge)
                    .foregroundColor(Color.brandIconTint)
            }
            
            VStack(spacing: 12) {
                Text("Welcome to Clinical Clarity")
                    .font(.appTitle)
                    .foregroundColor(Color.brandPrimary)
                    .multilineTextAlignment(.center)
                    .kerning(-0.7)
                
                Text("Sign in with your email to continue and securely access your care journey.")
                    .font(.appSubtitle)
                    .foregroundColor(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .frame(maxWidth: 320)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 12)
    }
    
    var loginCard: some View {
        VStack(alignment: .leading, spacing: 40) {
            
            // MARK: - Email Input Group
            VStack(alignment: .leading, spacing: 12) {
                Text("Email Address")
                    .font(.appLabel)
                    .foregroundColor(Color.textSecondary)
                
                HStack(spacing: 12) {
                    // Left email icon box (replacing country code box from mobile design)
                    HStack(spacing: 8) {
                        Image(systemName: "envelope.fill")
                            .font(.appIconMedium)
                            .foregroundColor(Color.brandPrimary)
                        
                        Text("Email")
                            .font(.appBodyMedium)
                            .foregroundColor(Color.textPrimary)
                    }
                    .padding(.horizontal, 16)
                    .frame(width: 118, height: 56, alignment: .leading)
                    .background(Color.inputBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.borderDefault, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    
                    // Email field
                    TextField("Enter your email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .font(.appBody)
                        .foregroundColor(Color.textPrimary)
                        .padding(.horizontal, 20)
                        .frame(height: 56)
                        .background(Color.inputBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderDefault, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
            }
            
            // MARK: - CTA + Trust Text
            VStack(spacing: 16) {
                BrandedActionButton(
                       title: "Continue",
                       suffixIcon: "arrow.right"
                   ) {
                       // TODO: Call login API
                   }
                
                HStack(spacing: 6) {
                    Image(systemName: "lock.fill")
                        .font(.appCaptionSmall)
                        .foregroundColor(Color.textSecondary)
                    
                    Text("Your information is safe and encrypted")
                        .font(.appCaptionMedium)
                        .foregroundColor(Color.textSecondary)
                }
                .opacity(0.7)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(Color.borderDefault, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    var footerSection: some View {
        VStack(spacing: 40) {
            
            LinearGradient(
                colors: [
                    Color.borderDefault.opacity(0),
                    Color.borderDefault,
                    Color.borderDefault.opacity(0)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 1)
            .opacity(0.5)
            
            VStack(spacing: 24) {
                Text("Don’t have an account?")
                    .font(.appBody)
                    .foregroundColor(Color.textSecondary)
                
                Button {
                    // TODO: Navigate to Sign Up
                } label: {
                    HStack(spacing: 6) {
                        Text("Create your account")
                            .font(.appLabelBold)
                        
                        Image(systemName: "chevron.right")
                            .font(.appIconSmallBold)
                    }
                    .foregroundColor(Color.brandPrimary)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.clear)
                    .clipShape(Capsule())
                }
            }
            .frame(maxWidth: .infinity)
            
            Spacer(minLength: 0)
                .frame(height: 20)
        }
    }
}

#Preview {
    LoginView()
}
