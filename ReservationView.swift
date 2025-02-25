//
//  ReservationView.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-18.
//

import SwiftUI
import FirebaseAuth

struct ReservationView: View {
    @ObservedObject var viewModel: ReservationViewModel
    @State private var selectedDate = Date()
    @State private var selectedStartTime = Date()
    @State private var selectedEndTime = Date()
    @State private var selectedType: ReservationType = .guestApartment
    @State private var userEmail: String = Auth.auth().currentUser?.email ?? ""

    var body: some View {
        Form {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
            DatePicker("Start Time", selection: $selectedStartTime, displayedComponents: .hourAndMinute)
            DatePicker("End Time", selection: $selectedEndTime, displayedComponents: .hourAndMinute)
            Picker("Reservation Type", selection: $selectedType) {
                ForEach(ReservationType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }

            Button("Add Reservation") {
                viewModel.addReservation(date: selectedDate, startTime: selectedStartTime, endTime: selectedEndTime, type: selectedType, userEmail: userEmail)
            }

            Section(header: Text("Existing Reservations")) {
                List(viewModel.reservations) { reservation in
                    VStack(alignment: .leading) {
                        Text(reservation.type.rawValue)
                        Text("\(reservation.date, formatter: dateFormatter)")
                        Text("Time: \(reservation.startTime, formatter: timeFormatter) - \(reservation.endTime, formatter: timeFormatter)")
                        Text("User: \(reservation.userEmail)")
                    }
                }
            }
        }
        .navigationTitle("Reservations")
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView(viewModel: ReservationViewModel())
    }
}
