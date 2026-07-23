import SwiftUI

struct AppPickerField: View {

    let title: String

    @Binding var selection: String

    let options: [String]

    var placeholder: String = "Select"

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(title)
                .font(.appLabel)
                .foregroundColor(.textPrimary)

            Menu {

                ForEach(options, id: \.self) { option in

                    Button(option) {

                        selection = option
                    }
                }

            } label: {

                HStack {

                    Text(
                        selection.isEmpty
                        ? placeholder
                        : selection
                    )
                    .foregroundColor(
                        selection.isEmpty
                        ? .textSecondary
                        : .textPrimary
                    )

                    Spacer()

                    Image(systemName: "chevron.down")
                        .foregroundColor(.textSecondary)
                }
                .font(.appBody)
                .padding(.horizontal, 16)
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
}
