//
//  AppointmentView.swift
//  Clinical Clarity
//

import SwiftUI

struct AppointmentView: View {
    
    @ObservedObject var viewModel: DashboardViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    var body: some View {
        
        Group {
            
            VStack(spacing: 20) {
                Picker(
                    "Appointments",
                    selection: $viewModel.selectedAppointmentFilter
                ) {
                    
                    ForEach(DashboardViewModel.AppointmentFilter.allCases) { filter in
                        
                        Text(filter.rawValue)
                            .tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: viewModel.selectedAppointmentFilter) { _ in
                    
                    Task {
                        
                        await viewModel.loadAppointments()
                    }
                }
            }
            
            if viewModel.isLoading {
                
                ProgressView()
                
            } else if let error = viewModel.errorMessage {
                
                if #available(iOS 17.0, *) {
                    ContentUnavailableView(
                        "Something went wrong",
                        systemImage: "exclamationmark.triangle",
                        description: Text(error)
                    )
                } else {
                    // Fallback on earlier versions
                    VStack(spacing: 16) {
                        
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundColor(.orange)
                        
                        Text("Something went wrong")
                            .font(.appBodySemibold)
                        
                        Text(error)
                            .font(.appBody)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
            } else if viewModel.upcomingAppointments.isEmpty {
                
                if #available(iOS 17.0, *) {
                    ContentUnavailableView(
                        "No Appointments",
                        systemImage: "calendar",
                        description: Text("You don't have any appointments yet.")
                    )
                } else {
                    // Fallback on earlier versions
                    VStack(spacing: 16) {
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 48))
                            .foregroundColor(.brandPrimary)
                        
                        Text("No Appointments")
                            .font(.appBodySemibold)
                        
                        Text("You don't have any appointments yet.")
                            .font(.appBody)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
            } else {
                
                ScrollView {
                    
                    LazyVStack(spacing: 16) {
                        
                        ForEach(viewModel.upcomingAppointments, id: \.id) { appointment in
                            
                            AppointmentCard(
                                appointment: appointment
                            ) {
                                
                                navigationManager.push(
                                    .appointmentDetails(
                                        id: appointment.id
                                    )
                                )
                            }
                        }
                    }
                    .padding()
                }
                
            }
        }
        .navigationTitle("Appointments")
        .task {
            
            await viewModel.loadAppointments()
        }
    }
}
