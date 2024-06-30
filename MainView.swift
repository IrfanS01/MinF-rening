//
//  MainView.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-22.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var associationViewModel: AssociationViewModel
    @StateObject private var reservationViewModel = ReservationViewModel()
    @StateObject private var notificationViewModel = NotificationViewModel()

    var body: some View {
        VStack {
            List {
                NavigationLink(destination: ReservationView(viewModel: reservationViewModel)) {
                    Text("Make a Reservation")
                }

                NavigationLink(destination: NotificationView(viewModel: notificationViewModel)) {
                    Text("View Notifications")
                }
            }
            .navigationTitle("Main Menu")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(userViewModel: UserViewModel(), associationViewModel: AssociationViewModel())
    }
}
