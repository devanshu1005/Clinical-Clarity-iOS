
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
            Color(red: 249/255, green: 249/255, blue: 252/255)
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
                .fill(Color(red: 214/255, green: 227/255, blue: 255/255).opacity(0.45))
                .frame(width: 195, height: 442)
                .blur(radius: 60)
                .offset(x: 120, y: -180)
            
            // Bottom-left green blur
            Ellipse()
                .fill(Color(red: 120/255, green: 252/255, blue: 156/255).opacity(0.35))
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
                    .fill(Color(red: 0/255, green: 94/255, blue: 184/255))
                    .frame(width: 64, height: 64)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                Image(systemName: "cross.case.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color(red: 200/255, green: 218/255, blue: 255/255))
            }
            
            VStack(spacing: 12) {
                Text("Welcome to Clinical Clarity")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0/255, green: 71/255, blue: 141/255))
                    .multilineTextAlignment(.center)
                    .kerning(-0.7)
                
                Text("Sign in with your email to continue and securely access your care journey.")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(Color(red: 66/255, green: 71/255, blue: 82/255))
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
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 66/255, green: 71/255, blue: 82/255))
                
                HStack(spacing: 12) {
                    // Left email icon box (replacing country code box from mobile design)
                    HStack(spacing: 8) {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(red: 0/255, green: 71/255, blue: 141/255))
                        
                        Text("Email")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(red: 26/255, green: 28/255, blue: 30/255))
                    }
                    .padding(.horizontal, 16)
                    .frame(width: 118, height: 56, alignment: .leading)
                    .background(Color(red: 243/255, green: 243/255, blue: 246/255))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(red: 194/255, green: 198/255, blue: 212/255), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    
                    // Email field
                    TextField("Enter your email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color(red: 26/255, green: 28/255, blue: 30/255))
                        .padding(.horizontal, 20)
                        .frame(height: 56)
                        .background(Color(red: 243/255, green: 243/255, blue: 246/255))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(red: 194/255, green: 198/255, blue: 212/255), lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
            }
            
            // MARK: - CTA + Trust Text
            VStack(spacing: 16) {
                Button {
                    // TODO: Call login API
                } label: {
                    HStack(spacing: 8) {
                        Text("Continue")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(Color(red: 0/255, green: 71/255, blue: 141/255))
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(red: 66/255, green: 71/255, blue: 82/255))
                    
                    Text("Your information is safe and encrypted")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 66/255, green: 71/255, blue: 82/255))
                }
                .opacity(0.7)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(Color(red: 194/255, green: 198/255, blue: 212/255), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    var footerSection: some View {
        VStack(spacing: 40) {
            
            LinearGradient(
                colors: [
                    Color(red: 194/255, green: 198/255, blue: 212/255).opacity(0),
                    Color(red: 194/255, green: 198/255, blue: 212/255),
                    Color(red: 194/255, green: 198/255, blue: 212/255).opacity(0)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 1)
            .opacity(0.5)
            
            VStack(spacing: 24) {
                Text("Don’t have an account?")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(red: 66/255, green: 71/255, blue: 82/255))
                
                Button {
                    // TODO: Navigate to Sign Up
                } label: {
                    HStack(spacing: 6) {
                        Text("Create your account")
                            .font(.system(size: 14, weight: .bold))
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .foregroundColor(Color(red: 0/255, green: 71/255, blue: 141/255))
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
