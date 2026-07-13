//
//  BrandedActionButton.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 13/07/26.
//

import SwiftUI

// MARK: - Shape Option

enum BrandedButtonShape {
    case capsule
    case roundedRectangle(cornerRadius: CGFloat)
}

// MARK: - AnyShape (lightweight type-eraser for Shape)
// Lets us switch between Capsule / RoundedRectangle etc. dynamically in clipShape.

struct AnyShape: Shape {
    private let pathBuilder: (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        self.pathBuilder = { rect in
            shape.path(in: rect)
        }
    }

    func path(in rect: CGRect) -> Path {
        pathBuilder(rect)
    }
}

// MARK: - BrandedActionButton

struct BrandedActionButton: View {
    
    let title: String
    var prefixIcon: String? = nil
    var suffixIcon: String? = nil
    var buttonColor: Color = .brandPrimary
    var textColor: Color = .white
    var height: CGFloat = 64
    var maxWidth: CGFloat? = .infinity
    var shape: BrandedButtonShape = .capsule
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let prefixIcon {
                    Image(systemName: prefixIcon)
                        .font(.appIconSmall)
                }
                
                Text(title)
                    .font(.appLabel)
                
                if let suffixIcon {
                    Image(systemName: suffixIcon)
                        .font(.appIconSmall)
                }
            }
            .foregroundColor(textColor)
            .frame(maxWidth: maxWidth)
            .frame(height: height)
            .background(buttonColor)
            .clipShape(resolvedShape)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    private var resolvedShape: AnyShape {
        switch shape {
        case .capsule:
            return AnyShape(Capsule())
        case .roundedRectangle(let cornerRadius):
            return AnyShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        BrandedActionButton(title: "Continue", suffixIcon: "arrow.right") {}
        
        BrandedActionButton(
            title: "Get Started",
            buttonColor: .blue,
            height: 54,
            shape: .roundedRectangle(cornerRadius: 16)
        ) {}
        
        BrandedActionButton(
            title: "Sign in with Apple",
            prefixIcon: "apple.logo",
            buttonColor: .black,
            height: 50,
            maxWidth: 280,
            shape: .roundedRectangle(cornerRadius: 12)
        ) {}
    }
    .padding()
}
