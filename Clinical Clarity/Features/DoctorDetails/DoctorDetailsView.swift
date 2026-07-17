//
//  DoctorDetailsView.swift
//  Clinical Clarity
//
//  Created by Rakesh Gupta on 16/07/26.
//

import SwiftUI

struct DoctorDetailsView: View {

    let doctorId: String

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

            } else if let doctor = viewModel.doctor {

                ScrollView(showsIndicators: false) {

                    VStack(spacing: 40) {

                        heroCard
                        statsSection
                        aboutSection
                        clinicSection
                        bookingSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }.safeAreaInset(edge: .bottom) {
                    
                    bookingBottomBar
                }
            }
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

                    Text("\(doctor.experienceYears) Years Experience" ?? "")
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

        HStack(spacing: 6) {

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 12))
                .foregroundColor(.white)

            Text("Available Today")
                .font(.system(size: 12, weight: .semibold))
                .textCase(.uppercase)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.green)
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
                    icon: "stethoscope",
                    title: "Experience",
                    value: "\(doctor.experienceYears) yrs"
                )

                StatCard(
                    icon: "star.fill",
                    title: "Rating",
                    value: String(
                        format: "%.1f",
                        doctor.averageRating ?? 00
                    )
                )

                StatCard(
                    icon: "person.2.fill",
                    title: "Reviews",
                    value: "\(doctor.totalReviews)"
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

//                Text(doctor.bio)
//                    .font(.appBody)
//                    .foregroundColor(.textSecondary)
//                    .lineSpacing(8)
//                    .fixedSize(
//                        horizontal: false,
//                        vertical: true
//                    )
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

            Text("Clinic information coming soon")
                .font(.headline)
                .foregroundColor(.textPrimary)

            Text(
                "This doctor's clinic details will appear here once available."
            )
            .font(.appBody)
            .foregroundColor(.textSecondary)
        }
    }
}

private extension DoctorDetailsView {

    var clinicLocationRow: some View {

        HStack(alignment: .top, spacing: 12) {

            Image(systemName: "location.fill")
                .foregroundColor(.brandPrimary)

            VStack(
                alignment: .leading,
                spacing: 2
            ) {

                Text("Location")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.textPrimary)

                Text("Distance unavailable")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
        .padding(12)
        .background(
            Color.white.opacity(0.6)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
    }
}

private extension DoctorDetailsView {

    var clinicMap: some View {

        ZStack(alignment: .bottomTrailing) {

            RoundedRectangle(cornerRadius: 8)
                .fill(Color.brandPrimary.opacity(0.08))
                .frame(height: 160)

            VStack(spacing: 12) {

                Image(systemName: "map.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.brandPrimary)

                Text("Map Preview")
                    .font(.headline)

                Text("Available when clinic coordinates are provided")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }

            Text("MAP")
                .font(.caption2.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 4)
                )
                .overlay {

                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.borderDefault)
                }
                .padding(8)
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

            slotSection(
                title: "Morning",
                icon: "sun.max.fill",
                slots: morningSlots
            )

            slotSection(
                title: "Afternoon",
                icon: "sun.max",
                slots: afternoonSlots
            )
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

                            await viewModel.loadDoctor(
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

            return hour >= 12
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
