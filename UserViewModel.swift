//
//  UserViewModel.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-27.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var reservations: [Reservation] = []
    @Published var notifications: [Notification] = []
    @Published var users: [User] = []
    private var db = Firestore.firestore()

    func registerUser(apartmentNumber: String, email: String, phoneNumber: String, associationEmail: String) {
        guard !apartmentNumber.isEmpty, !email.isEmpty, !phoneNumber.isEmpty, !associationEmail.isEmpty else {
            print("All fields must be filled out")
            return
        }
        
        // Kreiraj korisnika u Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: "defaultPassword") { authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                return
            }
            
            // Dodaj korisnika u Firestore
            let newUser = User(apartmentNumber: apartmentNumber, email: email, phoneNumber: phoneNumber, associationEmail: associationEmail)
            self.users.append(newUser)
            self.db.collection("users").addDocument(data: [
                "apartmentNumber": apartmentNumber,
                "email": email,
                "phoneNumber": phoneNumber,
                "associationEmail": associationEmail
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("User added successfully")
                }
            }
        }
    }

    struct User: Identifiable {
        var id = UUID()
        var apartmentNumber: String
        var email: String
        var phoneNumber: String
        var associationEmail: String
    }
}

