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

        guard let section = viewModel.sections.section(type: "UPCOMING_APPOINTMENTS")
        else {
            return AnyView(EmptyView())
        }

        guard let appointment = section.items.compactMap({

            if case let .appointment(value) = $0 {
                return value
            }

            return nil

        }).first else {

            return AnyView(EmptyView())
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

                VStack(spacing: 20) {

                    HStack(alignment: .top, spacing: 16) {

                        AsyncImage(
                            url: URL(
                                string: appointment.doctorId.profileImage ?? ""
                            )
                        ) { image in

                            image
                                .resizable()
                                .scaledToFill()

                        } placeholder: {

                            Circle()
                                .fill(Color.brandAccentBlue)
                        }
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 6) {

                            Text(appointment.doctorId.name)
                                .font(.appBodySemibold)
                                .foregroundColor(.textPrimary)

                            Text(appointment.doctorId.specialization)
                                .font(.appLabel)
                                .foregroundColor(.textSecondary)

                            Text(appointment.clinicId.name)
                                .font(.appCaptionMedium)
                                .foregroundColor(.textSecondary)
                        }

                        Spacer()
                    }

                    Divider()

                    HStack {

                        Label(
                            appointment.appointmentDate,
                            systemImage: "calendar"
                        )
                        .font(.appCaptionMedium)

                        Spacer()

                        Label(
                            "\(appointment.startTime) - \(appointment.endTime)",
                            systemImage: "clock"
                        )
                        .font(.appCaptionMedium)
                    }

                    BrandedActionButton(
                        title: "View Appointment",
                        suffixIcon: "arrow.right"
                    ) {

                    }
                }
                .padding(20)
                .background(Color.cardBackground)
                .overlay {

                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.borderDefault)
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)
                )
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

                            VStack(alignment: .leading, spacing: 14) {

                                AsyncImage(
                                    url: URL(
                                        string: doctor.profileImage ?? ""
                                    )
                                ) { image in

                                    image
                                        .resizable()
                                        .scaledToFill()

                                } placeholder: {

                                    Rectangle()
                                        .fill(Color.brandAccentBlue)
                                }
                                .frame(width: 210, height: 150)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 18)
                                )

                                Text(doctor.name)
                                    .font(.appBodySemibold)
                                    .foregroundColor(.textPrimary)
                                    .lineLimit(1)

                                Text(doctor.specialization)
                                    .font(.appLabel)
                                    .foregroundColor(.textSecondary)

                                HStack {

                                    Label(
                                        "\(doctor.experienceYears ?? 0) yrs",
                                        systemImage: "stethoscope"
                                    )

                                    Spacer()

                                    Label(
                                        "\(doctor.averageRating ?? 0, specifier: "%.1f")",
                                        systemImage: "star.fill"
                                    )
                                }
                                .font(.appCaptionMedium)
                                .foregroundColor(.textSecondary)
                            }
                            .padding(16)
                            .frame(width: 240)
                            .background(Color.cardBackground)
                            .overlay {

                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.borderDefault)
                            }
                            .clipShape(
                                RoundedRectangle(cornerRadius: 24)
                            )
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

                    ForEach(doctors, id: \.doctor.id) { item in

                        VStack(spacing: 16) {

                            HStack(alignment: .top, spacing: 16) {

                                AsyncImage(
                                    url: URL(
                                        string: item.doctor.profileImage ?? ""
                                    )
                                ) { image in

                                    image
                                        .resizable()
                                        .scaledToFill()

                                } placeholder: {

                                    Circle()
                                        .fill(Color.brandAccentBlue)
                                }
                                .frame(width: 72, height: 72)
                                .clipShape(Circle())

                                VStack(alignment: .leading, spacing: 8) {

                                    Text(item.doctor.name)
                                        .font(.appBodySemibold)
                                        .foregroundColor(.textPrimary)

                                    Text(item.doctor.specialization)
                                        .font(.appLabel)
                                        .foregroundColor(.textSecondary)

                                    HStack(spacing: 12) {

                                        Label(
                                            "\(item.doctor.experienceYears ?? 0) yrs",
                                            systemImage: "stethoscope"
                                        )

                                        Label(
                                            "\(item.doctor.averageRating ?? 0, specifier: "%.1f")",
                                            systemImage: "star.fill"
                                        )
                                    }
                                    .font(.appCaptionMedium)
                                    .foregroundColor(.textSecondary)

                                    HStack(spacing: 6) {

                                        Image(systemName: "location.fill")
                                            .foregroundColor(.brandPrimary)

                                        Text(
                                            item.nearestClinic.shortAddress ?? ""
                                        )
                                        .font(.appCaptionMedium)
                                        .foregroundColor(.textSecondary)
                                    }
                                }

                                Spacer()
                            }

                            Divider()

                            HStack {

                                VStack(alignment: .leading, spacing: 4) {

                                    Text("Nearest Clinic")
                                        .font(.appCaptionMedium)
                                        .foregroundColor(.textSecondary)

                                    Text(item.nearestClinic.name)
                                        .font(.appLabel)
                                        .foregroundColor(.textPrimary)
                                }

                                Spacer()

                                if let distance = item.nearestClinic.distanceInKm {

                                    Text(
                                        String(format: "%.1f km", distance)
                                    )
                                    .font(.appCaptionMedium)
                                    .foregroundColor(.brandPrimary)
                                }
                            }

                            BrandedActionButton(
                                title: "Book Appointment",
                                suffixIcon: "calendar"
                            ) {

                            }
                        }
                        .padding(20)
                        .background(Color.cardBackground)
                        .overlay {

                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.borderDefault)
                        }
                        .clipShape(
                            RoundedRectangle(cornerRadius: 24)
                        )
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
                        .foregroundColor(.textPrimary)

                    Spacer()

                    Button("See All") {

                    }
                    .font(.appLabelBold)
                    .foregroundColor(.brandPrimary)
                }

                LazyVStack(spacing: 18) {

                    ForEach(clinics,id:\.id) { clinic in

                        VStack(alignment:.leading,spacing:16){

                            AsyncImage(
                                url: URL(
                                    string: clinic.thumbnailImage ?? ""
                                )
                            ) { image in

                                image
                                    .resizable()
                                    .scaledToFill()

                            } placeholder: {

                                Rectangle()
                                    .fill(Color.brandAccentBlue)
                            }
                            .frame(height:180)
                            .clipShape(
                                RoundedRectangle(cornerRadius:18)
                            )

                            Text(clinic.name)
                                .font(.appBodySemibold)
                                .foregroundColor(.textPrimary)

                            Text(clinic.shortAddress ?? "")
                                .font(.appLabel)
                                .foregroundColor(.textSecondary)

                            HStack {

                                if let count = clinic.doctorCount {

                                    Label(
                                        "\(count) Doctors",
                                        systemImage: "stethoscope"
                                    )
                                }

                                Spacer()

                                if let distance = clinic.distanceInKm {

                                    Label(
                                        String(format: "%.1f km", distance),
                                        systemImage: "location.fill"
                                    )
                                }
                            }
                            .font(.appCaptionMedium)
                            .foregroundColor(.textSecondary)

                            BrandedActionButton(
                                title: "Book Appointment",
                                suffixIcon: "calendar"
                            ) {

                            }

                        }
                        .padding(20)
                        .background(Color.cardBackground)
                        .overlay{

                            RoundedRectangle(cornerRadius:24)
                                .stroke(Color.borderDefault)
                        }
                        .clipShape(
                            RoundedRectangle(cornerRadius:24)
                        )
                    }
                }
            }
        )
    }
    
}


