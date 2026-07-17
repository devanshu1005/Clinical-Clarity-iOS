//
//  StatCard.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 17/07/26.
//

import SwiftUI

struct StatCard: View {

    let icon: String

    let title: String

    let value: String

    var body: some View {

        VStack(spacing: 10) {

            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.brandPrimary)

            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)

            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 130)
        .background(Color(.systemGray6))
        .overlay {

            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    Color.borderDefault.opacity(0.25),
                    lineWidth: 1
                )
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }
}
