//
//  MainView.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-22.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var associationViewModel: AssociationViewModel
    @ObservedObject var reservationViewModel = ReservationViewModel()
    @ObservedObject var notificationViewModel = NotificationViewModel()
    @Binding var userType: Int?
    @Binding var signedIn: Bool

    var body: some View {
        VStack {
            if userType == 1 { // User
                UserView(reservationViewModel: reservationViewModel, notificationViewModel: notificationViewModel)
            } else if userType == 2 { // Association (Admin)
                AdminView(reservationViewModel: reservationViewModel, userViewModel: userViewModel)
            } else {
                Text("Unknown User Type")
            }
            Spacer()
            Button(action: {
                logOut()
            }) {
                Text("Log Out")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("Admin Panel") 
    }

    private func logOut() {
        do {
            try Auth.auth().signOut()
            signedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(userViewModel: UserViewModel(), associationViewModel: AssociationViewModel(), userType: .constant(1), signedIn: .constant(true))
    }
}
