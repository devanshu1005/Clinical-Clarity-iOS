//
//  DoctorDetailsView.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 16/07/26.
//

import SwiftUI
import MapKit

struct DoctorDetailsView: View {

    let doctorId: String
    @State private var showMapsOptions = false

    @StateObject
    private var viewModel: DoctorDetailsViewModel
    
    init(doctorId: String) {

        self.doctorId = doctorId

        _viewModel = StateObject(
            wrappedValue: DoctorDetailsViewModel(
                doctorId: doctorId
            )
        )
    }

    var body: some View {

        ZStack {

            Color.appBackground
                .ignoresSafeArea()

            if viewModel.isLoading {

                ProgressView()

            } else if let error = viewModel.errorMessage {

                Text(error)

            } else if viewModel.doctor != nil {

                ScrollView(showsIndicators: false) {

                    VStack(spacing: 40) {

                        heroCard
                        statsSection
                        aboutSection
                        clinicSection
                        bookingSection
                        
                        
                        if viewModel.isLoadingSlots {

                            VStack {
                                Spacer()

                                ProgressView("Loading available slots...")
                                    .progressViewStyle(.circular)

                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 380) // Match your booking section's approximate height
                            .background(Color.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 20))

                        } else if let error = viewModel.errorMessageSlots {

                            Text(error)

                        } else if viewModel.doctor?.availability != nil {

                            slotSection
                            
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }.safeAreaInset(edge: .bottom) {
                    
                    bookingBottomBar
                }
            }
        }.confirmationDialog(
            "Open in Maps",
            isPresented: $showMapsOptions,
            titleVisibility: .visible
        ) {

            Button("Apple Maps") {

                openAppleMaps()
            }

            Button("Google Maps") {

                openGoogleMaps()
            }

            Button("Cancel", role: .cancel) {}
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {

            await viewModel.loadDoctor(
                for: viewModel.selectedDate
            )
        }
    }
}

#Preview {
    NavigationStack {
        DoctorDetailsView(
            doctorId: "doctor_123456"
        )
    }
}


private extension DoctorDetailsView {

    @ViewBuilder
    var heroCard: some View {

        if let doctor = viewModel.doctor {

            VStack(spacing: 24) {

                profileImage

                VStack(spacing: 12) {

                    Text(doctor.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)

                    Text(doctor.qualification ??  "")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.brandPrimary)
                        .multilineTextAlignment(.center)

                    Text("\(doctor.experienceYears ?? 0) Years Experience")
                        .font(.appBody)
                        .foregroundColor(.textSecondary)

                    specializationBadge
                }
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .background(Color.cardBackground)
            .overlay {

                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.borderDefault.opacity(0.3))
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
            .shadow(
                color: .black.opacity(0.05),
                radius: 2,
                y: 1
            )
        }
    }
}

private extension DoctorDetailsView {

    @ViewBuilder
    var profileImage: some View {

        if let doctor = viewModel.doctor {

            ZStack(alignment: .bottom) {

                AsyncImage(
                    url: URL(string: doctor.profileImage ?? "")
                ) { image in

                    image
                        .resizable()
                        .scaledToFill()

                } placeholder: {

                    ZStack {

                        Color.brandPrimary.opacity(0.08)

                        Image(systemName: "person.crop.square.fill")
                            .font(.system(size: 54))
                            .foregroundColor(.brandPrimary)
                    }
                }
                .frame(width: 160, height: 160)
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
                .overlay {

                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white, lineWidth: 4)
                }
                .shadow(
                    color: .black.opacity(0.12),
                    radius: 6,
                    y: 3
                )

                availabilityBadge
                    .offset(y: 12)
            }
        }
    }
}

private extension DoctorDetailsView {

    var availabilityBadge: some View {

        let isAvailable = !(morningSlots.isEmpty &&
                            afternoonSlots.isEmpty &&
                            eveningSlots.isEmpty)

        return HStack(spacing: 6) {

            Image(systemName: isAvailable
                  ? "checkmark.circle.fill"
                  : "xmark.circle.fill")
                .font(.system(size: 12))

            Text(isAvailable ? "Available" : "Unavailable")
                .font(.system(size: 12, weight: .semibold))
                .textCase(.uppercase)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            isAvailable
            ? Color.green
            : Color.red.opacity(0.9)
        )
        .clipShape(Capsule())
    }
}

private extension DoctorDetailsView {

    @ViewBuilder
    var specializationBadge: some View {

        if let doctor = viewModel.doctor {

            HStack(spacing: 8) {

                Image(systemName: "stethoscope")
                    .foregroundColor(
                        Color(red: 0/255,
                              green: 27/255,
                              blue: 61/255)
                    )

                Text(doctor.specialization)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(
                Color(red: 0/255,
                      green: 27/255,
                      blue: 61/255)
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Color(red: 214/255,
                      green: 227/255,
                      blue: 1.0)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 8)
            )
        }
    }
}

private extension DoctorDetailsView {

    @ViewBuilder
    var statsSection: some View {

        if let doctor = viewModel.doctor {

            HStack(spacing: 12) {

                StatCard(
                    icon: "globe",
                    title: "Languages",
                    value: doctor.languages?.joined(separator: ", ") ?? "N/A"
                )

                StatCard(
                    icon: "indianrupeesign.circle.fill",
                    title: "Consultation",
                    value: "₹\(doctor.consultationFee ?? 0)"
                )

                StatCard(
                    icon: "star.fill",
                    title: "Ratings",
                    value: "\(doctor.averageRating ?? 0.0)"
                )
            }
        }
    }
}

private extension DoctorDetailsView {

    @ViewBuilder
    var aboutSection: some View {

        if let doctor = viewModel.doctor {

            VStack(
                alignment: .leading,
                spacing: 12
            ) {

                sectionTitle("About Doctor")

                Text(doctor.bio ?? "")
                    .font(.appBody)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(8)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
            }
            .frame(maxWidth: .infinity,
                   alignment: .leading)
        }
    }
}

private extension DoctorDetailsView {

    func sectionTitle(
        _ title: String
    ) -> some View {

        HStack(spacing: 12) {

            Rectangle()
                .fill(Color.brandPrimary)
                .frame(width: 4)

            Text(title)
                .font(
                    .system(
                        size: 24,
                        weight: .semibold
                    )
                )
                .foregroundColor(.textPrimary)

            Spacer()
        }
        .frame(height: 32)
    }
}

private extension DoctorDetailsView {

    var clinicSection: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            sectionTitle("Clinic Details")

            clinicCard
        }
    }
}

private extension DoctorDetailsView {

    var clinicCard: some View {

        VStack(
            alignment: .leading,
            spacing: 24
        ) {

            clinicInfo

            clinicLocationRow

            clinicMap
        }
        .padding(24)
        .background(
            Color(.systemGray6)
        )
        .overlay {

            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    Color.borderDefault.opacity(0.3),
                    lineWidth: 1
                )
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }
}

private extension DoctorDetailsView {

    var clinicInfo: some View {

        VStack(
            alignment: .leading,
            spacing: 4
        ) {

            Text(viewModel.doctor?.clinics?.first?.name ?? "Clinic not available")
                .font(.headline)
                .foregroundColor(.textPrimary)

            Text(viewModel.doctor?.clinics?.first?.shortAddress ?? "")
                .font(.appBody)
                .foregroundColor(.textSecondary)
        }
    }
}

private extension DoctorDetailsView {

    func formattedWorkingDays(_ days: [String]) -> String {

        if days.count == 5 &&
            days == ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"] {
            return "Monday - Friday"
        }

        return days.joined(separator: ", ")
    }

    func formattedTime(_ time: String) -> String {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm"

        guard let date = inputFormatter.date(from: time) else {
            return time
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mm a"

        return outputFormatter.string(from: date)
    }
}

private extension DoctorDetailsView {

    var clinicLocationRow: some View {

        HStack(alignment: .top, spacing: 12) {

            Image(systemName: "clock.fill")
                .foregroundColor(.brandPrimary)

            VStack(alignment: .leading, spacing: 6) {

                Text("Clinic Hours")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.textPrimary)

                if let availability = viewModel.doctor?.availability {

                    Text(formattedWorkingDays(availability.workingDays))
                        .font(.caption)
                        .foregroundColor(.textSecondary)

                    Text("\(formattedTime(availability.startTime)) - \(formattedTime(availability.endTime))")
                        .font(.caption)
                        .foregroundColor(.textSecondary)

                } else {

                    Text("Schedule unavailable")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }

            Spacer()
        }
        .padding(12)
        .background(Color.white.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct ClinicAnnotation: Identifiable {

    let id: String
    let coordinate: CLLocationCoordinate2D
}


private extension DoctorDetailsView {
    
    private func openGoogleMaps() {

        guard
            let clinic = viewModel.doctor?.clinics?.first,
            let location = clinic.location,
            let latitude = location.latitude,
            let longitude = location.longitude
        else {
            return
        }

        guard let url = URL(
            string:
            "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
        ) else {
            return
        }

        UIApplication.shared.open(url)
    }
    
    private func openAppleMaps() {

        guard
            let clinic = viewModel.doctor?.clinics?.first,
            let location = clinic.location,
            let latitude = location.latitude,
            let longitude = location.longitude
        else {
            return
        }

        let coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )

        let mapItem = MKMapItem(
            placemark: MKPlacemark(coordinate: coordinate)
        )

        mapItem.name = clinic.name

        mapItem.openInMaps(
            launchOptions: [
                MKLaunchOptionsDirectionsModeKey:
                    MKLaunchOptionsDirectionsModeDriving
            ]
        )
    }

    var clinicMap: some View {

        Group {

            if let clinic = viewModel.doctor?.clinics?.first,
               let location = clinic.location,
               let latitude = location.latitude,
               let longitude = location.longitude {

                Button {

                    if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {

                        showMapsOptions = true

                    } else {

                        openAppleMaps()
                    }

                } label: {

                    Map(
                        coordinateRegion: .constant(
                            MKCoordinateRegion(
                                center: CLLocationCoordinate2D(
                                    latitude: latitude,
                                    longitude: longitude
                                ),
                                span: MKCoordinateSpan(
                                    latitudeDelta: 0.01,
                                    longitudeDelta: 0.01
                                )
                            )
                        ),
                        annotationItems: [
                            ClinicAnnotation(
                                id: clinic.id,
                                coordinate: CLLocationCoordinate2D(
                                    latitude: latitude,
                                    longitude: longitude
                                )
                            )
                        ]
                    ) { item in

                        MapMarker(
                            coordinate: item.coordinate,
                            tint: .red
                        )
                    }
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)

            } else {

                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.brandPrimary.opacity(0.08))
                    .frame(height: 180)
                    .overlay {

                        Text("Location unavailable")
                            .foregroundColor(.textSecondary)
                    }
            }
        }
    }
}

private extension DoctorDetailsView {

    var bookingSection: some View {

        VStack(
            alignment: .leading,
            spacing: 24
        ) {

            HStack {

                sectionTitle("Book Appointment")

                Spacer()

                Text("Next 7 Days")
                    .font(.appLabel)
                    .foregroundColor(.brandPrimary)
            }

            dateSelector
        }
        }
    }

private extension DoctorDetailsView {

    var slotSection: some View {

        VStack(
            alignment: .leading,
            spacing: 24
        ) {
            if(morningSlots.isEmpty && eveningSlots.isEmpty && afternoonSlots.isEmpty){
                Text("No slots available for the selected date")
            }else {
                if(morningSlots.isEmpty){
                    EmptyView()
                }else{
                    slotSection(
                        title: "Morning",
                        icon: "sunrise.fill",
                        slots: morningSlots
                    )
                }
                
                if(afternoonSlots.isEmpty){
                    EmptyView()
                }else{
                    slotSection(
                        title: "Afternoon",
                        icon: "sun.max.fill",
                        slots: afternoonSlots
                    )
                }
                
                if(eveningSlots.isEmpty){
                    EmptyView()
                }else{
                    slotSection(
                        title: "Evening",
                        icon: "moon.stars.fill",
                        slots: eveningSlots
                    )
                }
            }
        }
        }
    }


private extension DoctorDetailsView {

    var dateSelector: some View {

        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {

            HStack(spacing: 12) {

                ForEach(
                    viewModel.availableDates,
                    id: \.self
                ) { date in

                    DateChip(
                        date: date,
                        isSelected:
                            Calendar.current.isDate(
                                date,
                                inSameDayAs: viewModel.selectedDate
                            )
                    ) {

                        viewModel.selectedDate = date

                        Task {

                            await viewModel.loadDoctorAvailability(
                                for: date
                            )
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

private extension DoctorDetailsView {

    var morningSlots: [DoctorSlot] {

        viewModel.slots.filter {
            let hour = Int($0.start.prefix(2)) ?? 0
            return hour < 12
        }
    }

    var afternoonSlots: [DoctorSlot] {

        viewModel.slots.filter {
            let hour = Int($0.start.prefix(2)) ?? 0
            return hour >= 12 && hour < 17
        }
    }

    var eveningSlots: [DoctorSlot] {

        viewModel.slots.filter {
            let hour = Int($0.start.prefix(2)) ?? 0
            return hour >= 17
        }
    }
}

private extension DoctorDetailsView {

    func slotSection(
        title: String,
        icon: String,
        slots: [DoctorSlot]
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            HStack(spacing: 8) {

                Image(systemName: icon)
                    .foregroundColor(.textSecondary)

                Text(title)
                    .font(.headline)
                    .foregroundColor(.textSecondary)
            }

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 12
            ) {

                ForEach(slots) { slot in

                    TimeSlotButton(
                        slot: slot,
                        isSelected:
                            viewModel.selectedSlot?.id == slot.id
                    ) {

                        viewModel.selectedSlot = slot
                    }
                }
            }
        }
    }
}

private extension DoctorDetailsView {

    var bookingBottomBar: some View {

        VStack {
            if let slot = viewModel.selectedSlot {

                Text(
                    "Selected: \(slot.start)"
                )
                .font(.caption)
                .foregroundColor(.textSecondary)
                .padding(.bottom, 8)
            }

            Button {

                bookAppointment()

            } label: {

                HStack(spacing: 12) {

                    Image(systemName: "calendar.badge.plus")

                    Text(
                        viewModel.selectedSlot == nil
                        ? "Select a Time Slot"
                        : "Book Appointment"
                    )
                }
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 72)
                .background(
                    viewModel.selectedSlot == nil
                    ? Color.gray.opacity(0.5)
                    : Color.brandPrimary
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
            }
            .disabled(viewModel.selectedSlot == nil)

        }
        .padding(24)
        .background(Color.white)
        .shadow(
            color: .black.opacity(0.08),
            radius: 16,
            y: -6
        )
    }
}

private extension DoctorDetailsView {

    func bookAppointment() {

        guard
            let doctor = viewModel.doctor,
            let slot = viewModel.selectedSlot
        else {

            return
        }

        print("========== Appointment ==========")
        print("Doctor :", doctor.name)
        print("Doctor Id :", doctor.id)
        print("Date :", viewModel.selectedDate)
        print("Slot :", slot.start)
        print("===============================")

        // TODO:
        // navigationManager.push(
        //     .bookAppointment(...)
        // )
    }
}
