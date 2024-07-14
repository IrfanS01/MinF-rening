//
//  AdminView.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-07-07.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AdminView: View {
    @ObservedObject var reservationViewModel: ReservationViewModel
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var notificationViewModel = NotificationViewModel()
    @ObservedObject var accessRequestViewModel = AccessRequestViewModel()
    @State private var buildingID = ""

    var body: some View {
        NavigationView {
            VStack {
                
                List {
                    Section(header: Text("Management")) {
                        NavigationLink(destination: ManageReservationsView(viewModel: reservationViewModel)) {
                            HStack {
                                Image(systemName: "calendar")
                                Text("Manage Reservations")
                            }
                        }

                        NavigationLink(destination: ManageUsersView(viewModel: userViewModel)) {
                            HStack {
                                Image(systemName: "person.3")
                                Text("Manage Users")
                            }
                        }

                        NavigationLink(destination: ManageReservationObjectsView(viewModel: reservationViewModel)) {
                            HStack {
                                Image(systemName: "house")
                                Text("Manage Reservation Objects")
                            }
                        }

                        NavigationLink(destination: AdminNotificationView(viewModel: notificationViewModel)) {
                            HStack {
                                Image(systemName: "bell")
                                Text("Send Notifications")
                            }
                        }
                    }

                    Section(header: Text("Access Requests")) {
                        ForEach(accessRequestViewModel.requests) { request in
                            VStack(alignment: .leading) {
                                Text("Username: \(request.username)")
                                Text("Email: \(request.email)")
                                Text("Apartment Number: \(request.apartmentNumber)")
                                Text("Phone Number: \(request.phoneNumber)")
                                HStack {
                                    Button("Approve") {
                                        accessRequestViewModel.approveRequest(request, buildingID: buildingID)
                                    }
                                    .foregroundColor(.green)
                                    Button("Deny") {
                                        accessRequestViewModel.denyRequest(request)
                                    }
                                    .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
            }
            
        }
    }

    private func logOut() {
        do {
            try Auth.auth().signOut()
            // Handle sign out logic
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView(reservationViewModel: ReservationViewModel(), userViewModel: UserViewModel())
    }
}
