//
//  MainContainerView.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 15/07/26.
//

import SwiftUI

struct MainContainerView: View {

    @State private var selectedTab: DashboardTab = .home
    @StateObject private var dashboardViewModel = DashboardViewModel()

    var body: some View {

        ZStack(alignment: .bottom) {

            Group {

                switch selectedTab {

                case .home:
                    DashboardView(viewModel: dashboardViewModel)

                case .search:
                    DoctorSearchView()
                    
                case .appointments:
                    AppointmentView(viewModel: dashboardViewModel)

                case .profile:
//                    ProfileView()
                    AppointmentView(viewModel: dashboardViewModel)
                }
            }

            BottomNavigationView(
                selectedTab: $selectedTab
            )
        } .task {
            
            if dashboardViewModel.sections.isEmpty {

                await dashboardViewModel.loadDashboard()
            }
        }
        .background(Color.appBackground)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    MainContainerView()
}
