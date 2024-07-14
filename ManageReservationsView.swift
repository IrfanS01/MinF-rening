//
//  ManageReservationsView.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-07-07.
//

import SwiftUI

struct ManageReservationsView: View {
    @ObservedObject var viewModel: ReservationViewModel

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.reservations) { reservation in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(reservation.type.rawValue)
                            Text("User: \(reservation.userEmail)")
                            Text("Date: \(reservation.date, formatter: dateFormatter)")
                            Text("Time: \(reservation.startTime, formatter: timeFormatter) - \(reservation.endTime, formatter: timeFormatter)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: {
                            viewModel.deleteReservation(id: reservation.id)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Manage Reservations")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddReservationView(viewModel: viewModel)) {
                        Text("Add")
                    }
                }
            }
        }
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

struct ManageReservationsView_Previews: PreviewProvider {
    static var previews: some View {
        ManageReservationsView(viewModel: ReservationViewModel())
    }
}
