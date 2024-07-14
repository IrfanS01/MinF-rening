//
//  AddReservationView.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-07-07.
//

import SwiftUI
import FirebaseAuth

struct AddReservationView: View {
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
        }
        .navigationTitle("Add Reservation")
    }
}

struct AddReservationView_Previews: PreviewProvider {
    static var previews: some View {
        AddReservationView(viewModel: ReservationViewModel())
    }
}
