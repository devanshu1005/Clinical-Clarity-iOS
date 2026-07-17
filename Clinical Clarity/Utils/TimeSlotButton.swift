//
//  TimeSlotButton.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 17/07/26.
//

import SwiftUI

struct TimeSlotButton: View {

    let slot: DoctorSlot

    let isSelected: Bool

    let action: () -> Void

    var body: some View {

        Button(action: action) {

            Text(slot.start)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(
                    isSelected
                    ? .white
                    : .textPrimary
                )
                .frame(maxWidth: .infinity)
                .frame(height: 46)
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
                            Color.borderDefault,
                            lineWidth: 1
                        )
                    }
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
        }
    }
}
