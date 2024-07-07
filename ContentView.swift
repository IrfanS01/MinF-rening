//
//  ContentView.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-14.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @State private var signedIn = false
    @State private var userType: Int? = nil
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var associationViewModel = AssociationViewModel()

    var body: some View {
        NavigationView {
            if signedIn {
                MainView(
                    userViewModel: userViewModel,
                    associationViewModel: associationViewModel,
                    userType: $userType,
                    signedIn: $signedIn
                )
            } else {
                SignInView(
                    signedIn: $signedIn,
                    userType: $userType
                )
            }
        }
        .onAppear(perform: checkUserStatus)
    }

    private func checkUserStatus() {
        if let user = Auth.auth().currentUser {
            fetchUserType(userID: user.uid) { type in
                if let type = type {
                    self.userType = type
                    self.signedIn = true
                } else {
                    self.signedIn = false
                }
            }
        } else {
            self.signedIn = false
        }
    }

    private func fetchUserType(userID: String, completion: @escaping (Int?) -> Void) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")

        usersCollection.document(userID).getDocument { document, error in
            if let document = document, document.exists {
                if let data = document.data(), let userType = data["usertype"] as? Int {
                    completion(userType)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
