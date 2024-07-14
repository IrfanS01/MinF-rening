//
//  ManageUsersView.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-07-07.
//

import SwiftUI

struct ManageUsersView: View {
    @ObservedObject var viewModel: UserViewModel

    var body: some View {
        List {
            ForEach(viewModel.users) { user in
                VStack(alignment: .leading) {
                    Text("Username: \(user.username)")
                    Text("Email: \(user.email)")
                    Text("User Type: \(user.usertype == 1 ? "User" : "Association")")
                    if let apartmentNumber = user.apartmentNumber {
                        Text("Apartment: \(apartmentNumber)")
                    }
                    if let phoneNumber = user.phoneNumber {
                        Text("Phone: \(phoneNumber)")
                    }
                    if let associationEmail = user.associationEmail {
                        Text("Association Email: \(associationEmail)")
                    }
                    Button(action: {
                        viewModel.deleteUser(user: user)
                    }) {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Manage Users")
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}

struct ManageUsersView_Previews: PreviewProvider {
    static var previews: some View {
        ManageUsersView(viewModel: UserViewModel())
    }
}
