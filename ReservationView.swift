//
//  ReservationView.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-18.
//

import SwiftUI

struct ReservationView: View {
    @ObservedObject var viewModel: ReservationViewModel
    @State private var selectedDate = Date()
    @State private var selectedType: ReservationType = .guestApartment

    var body: some View {
        Form {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
            Picker("Reservation Type", selection: $selectedType) {
                ForEach(ReservationType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }

            Button("Add Reservation") {
                viewModel.addReservation(date: selectedDate, type: selectedType)
            }

            Section(header: Text("Existing Reservations")) {
                List(viewModel.reservations) { reservation in
                    VStack(alignment: .leading) {
                        Text(reservation.type.rawValue)
                        Text("\(reservation.date, formatter: dateFormatter)")
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
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView(viewModel: ReservationViewModel())
    }
}
