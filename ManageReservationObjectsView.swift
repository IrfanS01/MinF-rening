//
//  ManageReservationObjectsView.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-07-08.
//

import SwiftUI

struct ManageReservationObjectsView: View {
    @ObservedObject var viewModel: ReservationViewModel
    @State private var name = ""
    @State private var description = ""

    var body: some View {
        Form {
            Section(header: Text("Add New Reservation Object")) {
                TextField("Name", text: $name)
                TextField("Description", text: $description)
                Button("Add Object") {
                    viewModel.addReservationObject(name: name, description: description)
                    name = ""
                    description = ""
                }
            }

            Section(header: Text("Existing Reservation Objects")) {
                List(viewModel.reservationObjects) { object in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(object.name)
                            Text(object.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: {
                            viewModel.deleteReservationObject(id: object.id)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .navigationTitle("Manage Reservation Objects")
        .edgesIgnoringSafeArea(.bottom) // Osiguravanje da form ne koristi tastaturu
    }
}

struct ManageReservationObjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ManageReservationObjectsView(viewModel: ReservationViewModel())
    }
}
