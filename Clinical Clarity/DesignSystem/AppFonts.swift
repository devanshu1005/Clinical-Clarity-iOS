import SwiftUI

extension Font {
    // MARK: - Headings
    static let appTitle = Font.system(size: 28, weight: .bold)           // hero title / onboarding title
    static let appTitle2 = Font.system(size: 24, weight: .semibold)      // section titles
    static let appSubtitle = Font.system(size: 18, weight: .regular)     // hero subtitle

    // MARK: - Body
    static let appBody = Font.system(size: 16, weight: .regular)         // body text, text fields, onboarding subtitle
    static let appBodyMedium = Font.system(size: 16, weight: .medium)    // email box label
    static let appBodySemibold = Font.system(size: 16, weight: .semibold) // primary CTA button label

    // MARK: - Labels / Captions
    static let appLabel = Font.system(size: 14, weight: .semibold)       // field labels, CTA text
    static let appLabelBold = Font.system(size: 14, weight: .bold)       // "Create your account"
    static let appCaption = Font.system(size: 13, weight: .semibold)     // "Coming Soon"
    static let appCaptionBold = Font.system(size: 13, weight: .bold)      // badge/chip text
    static let appCaptionSmall = Font.system(size: 12, weight: .semibold) // lock icon
    static let appCaptionMedium = Font.system(size: 12, weight: .medium) // trust text

    // MARK: - Nav / Small controls
    static let appNavButton = Font.system(size: 15, weight: .medium)     // "Skip" button

    // MARK: - Icon-sized
    static let appIconLarge = Font.system(size: 24, weight: .semibold)
    static let appIconMedium = Font.system(size: 16, weight: .medium)
    static let appIconSmall = Font.system(size: 14, weight: .bold)
    static let appIconSmallBold = Font.system(size: 12, weight: .bold)
}
