//
//  UserView.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-07-07.
//

import SwiftUI

struct UserView: View {
    @ObservedObject var reservationViewModel: ReservationViewModel
    @ObservedObject var notificationViewModel: NotificationViewModel

    var body: some View {
        VStack {
            Text("User View")
                .font(.largeTitle)
                .padding()

            NavigationLink(destination: ReservationView(viewModel: reservationViewModel)) {
                Text("Make a Reservation")
            }
            .padding()

            NavigationLink(destination: NotificationView(viewModel: notificationViewModel)) {
                Text("View Notifications")
            }
            .padding()
        }
        .navigationTitle("User Menu")
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(reservationViewModel: ReservationViewModel(), notificationViewModel: NotificationViewModel())
    }
}
