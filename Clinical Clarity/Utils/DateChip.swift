//
//  DateChip.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 17/07/26.
//

import SwiftUI

struct DateChip: View {

    let date: Date

    let isSelected: Bool

    let action: () -> Void

    private let dayFormatter: DateFormatter = {

        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter

    }()

    private let numberFormatter: DateFormatter = {

        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter

    }()

    var body: some View {

        Button(action: action) {

            VStack(spacing: 10) {

                Text(
                    dayFormatter.string(from: date)
                )
                .font(.caption.weight(.medium))
                .foregroundColor(
                    isSelected ? .white : .textSecondary
                )

                Text(
                    numberFormatter.string(from: date)
                )
                .font(
                    .system(
                        size: 24,
                        weight: .semibold
                    )
                )
                .foregroundColor(
                    isSelected ? .white : .textPrimary
                )

                if isSelected {

                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            .frame(width: 72, height: 80)
            .background(
                isSelected
                    ? Color.brandPrimary
                    : Color(.systemGray6)
            )
            .overlay {

                if !isSelected {

                    RoundedRectangle(
                        cornerRadius: 12
                    )
                    .stroke(
                        Color.borderDefault.opacity(0.3),
                        lineWidth: 1
                    )
                }
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
            .shadow(
                color: isSelected
                    ? .black.opacity(0.12)
                    : .clear,
                radius: 6,
                y: 2
            )
        }
    }
}
