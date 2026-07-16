//
//  DashboardView.swift
//  Clinical Clarity
//

import SwiftUI

struct DashboardView: View {

    @ObservedObject var viewModel: DashboardViewModel

    @State private var searchText = ""

    var body: some View {

        ZStack{

            Color.appBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 28) {

                    header

                    searchBar

                    if viewModel.isLoading {

                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.top,80)

                    } else if let error = viewModel.errorMessage {

                        VStack(spacing:16){

                            Text(error)
                                .foregroundColor(.red)

                            Button("Retry"){

                                Task{
                                    await viewModel.loadDashboard()
                                }

                            }
                        }
                        .frame(maxWidth:.infinity)

                    } else {

                        specializationSection;

                        upcomingAppointmentSection
                        
                        popularDoctorsSection
                        
                        nearbyDoctorsSection
                        
                        nearbyClinicsSection

                    }

                    Spacer(minLength:40)
                }
                .padding(.horizontal,20)
                .padding(.top,20)
            }
        }
    }
}

private extension DashboardView {

    var header: some View {

        HStack {

            VStack(alignment:.leading,spacing:4){

                Text("Good Morning 👋")
                    .font(.appBody)
                    .foregroundColor(.textSecondary)

                Text("Devanshu")
                    .font(.appTitle)
                    .foregroundColor(.brandPrimary)
            }

            Spacer()

            Button {

            } label: {

                ZStack{

                    Circle()
                        .fill(Color.white)

                    Image(systemName:"bell")
                        .font(.appIconMedium)
                        .foregroundColor(.brandPrimary)

                }
                .frame(width:48,height:48)
                .shadow(
                    color:.black.opacity(0.05),
                    radius:8
                )
            }
        }
    }

    var searchBar: some View {

        HStack(spacing:12){

            Image(systemName:"magnifyingglass")
                .foregroundColor(.textSecondary)

            TextField(
                "Search doctors, clinics...",
                text:$searchText
            )
            .font(.appBody)

        }
        .padding(.horizontal,18)
        .frame(height:56)
        .background(Color.cardBackground)
        .overlay{

            RoundedRectangle(cornerRadius:16)
                .stroke(Color.borderDefault)
        }
        .clipShape(
            RoundedRectangle(cornerRadius:16)
        )
    }

    var specializationSection: some View {

        guard let section = viewModel.sections.section(
            type: "SPECIALIZATIONS"
        ) else {

            return AnyView(EmptyView())
        }

        let values = section.items.compactMap{

            if case let .specialization(name) = $0 {

                return name
            }

            return nil
        }

        return AnyView(

            VStack(alignment:.leading,spacing:20){

                HStack{

                    Text(section.title)
                        .font(.appBodySemibold)
                        .foregroundColor(.textPrimary)

                    Spacer()

                    Button("See All"){

                    }
                    .font(.appLabelBold)
                    .foregroundColor(.brandPrimary)
                }

                ScrollView(
                    .horizontal,
                    showsIndicators:false
                ){

                    HStack(spacing:12){

                        ForEach(values,id:\.self){ specialization in

                            Text(specialization)
                                .font(.appLabel)
                                .foregroundColor(.brandPrimary)
                                .padding(.horizontal,18)
                                .frame(height:42)
                                .background(Color.white)
                                .overlay{

                                    Capsule()
                                        .stroke(
                                            Color.borderDefault
                                        )
                                }
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        )
    }
    
    var upcomingAppointmentSection: some View {

        guard let section = viewModel.sections.section(
            type: "UPCOMING_APPOINTMENTS"
        ) else {

            return AnyView(EmptyView())
        }

        let appointments = section.items.compactMap {

            if case let .appointment(value) = $0 {

                return value
            }

            return nil
        }

        return AnyView(

            VStack(alignment: .leading, spacing: 20) {

                HStack {

                    Text(section.title)
                        .font(.appBodySemibold)

                    Spacer()

                    Button("See All") {

                    }
                    .font(.appLabelBold)
                    .foregroundColor(.brandPrimary)
                }

                LazyVStack(spacing: 16) {

                    ForEach(appointments, id: \.id) { appointment in

                        AppointmentCard(
                            appointment: appointment,
                            buttonTitle: "View Appointment"
                        ) {

                            print("Open Appointment Details")
                        }
                    }
                }
            }
        )
    }
    
    var popularDoctorsSection: some View {

        guard let section = viewModel.sections.section(type: "POPULAR_DOCTORS")
        else {

            return AnyView(EmptyView())
        }

        let doctors = section.items.compactMap {

            if case let .doctor(value) = $0 {

                return value
            }

            return nil
        }

        return AnyView(

            VStack(alignment: .leading, spacing: 20) {

                HStack {

                    Text(section.title)
                        .font(.appBodySemibold)

                    Spacer()

                    Button("See All") {

                    }
                    .font(.appLabelBold)
                    .foregroundColor(.brandPrimary)
                }

                ScrollView(
                    .horizontal,
                    showsIndicators: false
                ) {

                    HStack(spacing: 16) {

                        ForEach(doctors, id: \.id) { doctor in

                            PopularDoctorCard(doctor: doctor) {

                                print("Open Doctor")
                            }
                        }
                    }
                }
            }
        )
    }
    
    var nearbyDoctorsSection: some View {

        guard let section = viewModel.sections.section(type: "NEARBY_DOCTORS")
        else {
            return AnyView(EmptyView())
        }

        let doctors = section.items.compactMap {

            if case let .nearbyDoctor(value) = $0 {
                return value
            }

            return nil
        }

        return AnyView(

            VStack(alignment: .leading, spacing: 20) {

                HStack {

                    Text(section.title)
                        .font(.appBodySemibold)
                        .foregroundColor(.textPrimary)

                    Spacer()

                    Button("See All") {

                    }
                    .font(.appLabelBold)
                    .foregroundColor(.brandPrimary)
                }

                LazyVStack(spacing: 18) {

                    ForEach(doctors, id: \.doctor.id) { doctor in

                        NearbyDoctorCard(item: doctor) {

                            print("Book Appointment")
                        }
                    }
                }
            }
        )
    }
    
    var nearbyClinicsSection: some View {

        guard let section = viewModel.sections.section(type: "NEARBY_CLINICS")
        else {

            return AnyView(EmptyView())
        }

        let clinics = section.items.compactMap {

            if case let .clinic(value) = $0 {
                return value
            }

            return nil
        }

        return AnyView(

            VStack(alignment: .leading, spacing: 20) {

                HStack {

                    Text(section.title)
                        .font(.appBodySemibold)

                    Spacer()

                    Button("See All") {

                    }
                    .font(.appLabelBold)
                    .foregroundColor(.brandPrimary)
                }

                LazyVStack(spacing: 18) {

                    ForEach(clinics, id: \.id) { clinic in

                        ClinicCard(clinic: clinic) {

                            print("Book appointment for \(clinic.name)")
                        }
                    }
                }
            }
        )
    }
}


