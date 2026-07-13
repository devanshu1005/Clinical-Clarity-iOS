import SwiftUI

extension Color {
    // MARK: - Brand
    static let brandPrimary = Color(red: 0/255, green: 71/255, blue: 141/255)       // deep blue - headlines, CTA bg, links
    static let brandSecondary = Color(red: 0/255, green: 94/255, blue: 184/255)     // icon badge bg
    static let brandIconTint = Color(red: 200/255, green: 218/255, blue: 255/255)   // icon foreground on brand badge
    static let brandAccentBlue = Color(red: 214/255, green: 227/255, blue: 255/255) // decorative blur
    static let brandAccentGreen = Color(red: 120/255, green: 252/255, blue: 156/255) // decorative blur

    // MARK: - Backgrounds
    static let appBackground = Color(red: 249/255, green: 249/255, blue: 252/255)
    static let inputBackground = Color(red: 243/255, green: 243/255, blue: 246/255)
    static let cardBackground = Color.white

    // MARK: - Text
    static let textPrimary = Color(red: 26/255, green: 28/255, blue: 30/255)
    static let textSecondary = Color(red: 66/255, green: 71/255, blue: 82/255)
    static let textOnboardingTitle = Color.black
    static let textOnboardingSubtitle = Color.gray

    // MARK: - Borders / Dividers
    static let borderDefault = Color(red: 194/255, green: 198/255, blue: 212/255)

    // MARK: - Status
    static let statusComingSoon = Color.orange

    // MARK: - Onboarding controls
    static let pageIndicatorActive = Color.blue
    static let pageIndicatorInactive = Color.gray.opacity(0.3)
    static let ctaBackground = Color.blue
    static let skipButtonText = Color.gray
}
