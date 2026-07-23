import SwiftUI

struct AppTextField: View {

    let title: String
    let placeholder: String

    @Binding var text: String

    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var autocapitalization: TextInputAutocapitalization = .sentences
    var isSecure: Bool = false
    var disabled: Bool = false

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(title)
                .font(.appLabel)
                .foregroundColor(.textPrimary)

            Group {

                if isSecure {

                    SecureField(
                        placeholder,
                        text: $text
                    )

                } else {

                    TextField(
                        placeholder,
                        text: $text
                    )
                }
            }
            .keyboardType(keyboardType)
            .textContentType(textContentType)
            .textInputAutocapitalization(autocapitalization)
            .autocorrectionDisabled()
            .disabled(disabled)
            .font(.appBody)
            .padding(16)
            .frame(height: 56)
            .background(Color.appBackground)
            .overlay {

                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.borderDefault)
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 14)
            )
        }
    }
}
