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
    @Published var users: [User] = []
    private var db = Firestore.firestore()

    init() {
        fetchUsers()
    }

    func fetchUsers() {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No users found")
                return
            }

            print("Documents found: \(documents.count)")

            self.users = documents.compactMap { document -> User? in
                let data = document.data()
                guard let username = data["username"] as? String,
                      let email = data["email"] as? String,
                      let uid = data["uid"] as? String,
                      let usertype = data["usertype"] as? Int else {
                    print("Error parsing user data: \(data)")
                    return nil
                }
                let apartmentNumber = data["apartmentNumber"] as? String
                let phoneNumber = data["phoneNumber"] as? String
                let associationEmail = data["associationEmail"] as? String
                return User(id: UUID(), username: username, email: email, uid: uid, usertype: usertype, apartmentNumber: apartmentNumber, phoneNumber: phoneNumber, associationEmail: associationEmail)
            }

            print("Fetched users: \(self.users.count)")
        }
    }

    func deleteUser(user: User) {
        guard let userId = user.uid else {
            print("User ID not found.")
            return
        }
        
        db.collection("users").document(userId).delete { error in
            if let error = error {
                print("Error deleting user: \(error)")
            } else {
                print("User deleted successfully")
                self.fetchUsers() // Refresh the users list
            }
        }
    }

    func deleteAllUsers() {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users for deletion: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No users found")
                return
            }

            let batch = self.db.batch()

            for document in documents {
                batch.deleteDocument(document.reference)
            }

            batch.commit { error in
                if let error = error {
                    print("Error deleting all users: \(error)")
                } else {
                    print("All users deleted successfully")
                    self.fetchUsers() // Refresh the users list
                }
            }
        }
    }

    struct User: Identifiable {
        var id: UUID
        var username: String
        var email: String
        var uid: String?
        var usertype: Int
        var apartmentNumber: String?
        var phoneNumber: String?
        var associationEmail: String?
    }
}
