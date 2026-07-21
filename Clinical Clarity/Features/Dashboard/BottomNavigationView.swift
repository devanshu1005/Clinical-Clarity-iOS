//
//  BottomNavigationView.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 15/07/26.
//

import SwiftUI

struct BottomNavigationView: View {

    @Binding var selectedTab: DashboardTab

    var body: some View {

        HStack {

            navItem(
                tab: .home,
                icon: "house.fill",
                title: "Home"
            )

            Spacer()

            navItem(
                tab: .search,
                icon: "magnifyingglass",
                title: "Search"
            )

            Spacer()

            navItem(
                tab: .appointments,
                icon: "calendar",
                title: "Bookings"
            )

            Spacer()

            navItem(
                tab: .profile,
                icon: "person.crop.circle.fill",
                title: "Profile"
            )
        }
        .padding(.horizontal, 28)
        .padding(.top, 16)
        .padding(.bottom, 28)
        .background(Color.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 28)
        )
        .shadow(
            color: .black.opacity(0.08),
            radius: 20,
            y: -4
        )
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func navItem(
        tab: DashboardTab,
        icon: String,
        title: String
    ) -> some View {

        Button {

            withAnimation(.easeInOut(duration: 0.25)) {
                selectedTab = tab
            }

        } label: {

            VStack(spacing: 6) {

                Capsule()
                    .fill(
                        selectedTab == tab
                        ? Color.brandPrimary
                        : .clear
                    )
                    .frame(width: 26, height: 3)

                Image(systemName: icon)
                    .font(.appIconMedium)

                Text(title)
                    .font(.appCaptionMedium)
            }
            .foregroundColor(
                selectedTab == tab
                ? .brandPrimary
                : .textSecondary
            )
            .frame(maxWidth: .infinity)
        }
    }
}
