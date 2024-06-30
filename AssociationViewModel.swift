//
//  AssociationViewModel.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-27.
//

import Foundation
import FirebaseFirestore

class AssociationViewModel: ObservableObject {
    @Published var reservations: [Reservation] = []
    @Published var notifications: [Notification] = []
    @Published var associations: [Association] = []
    private var db = Firestore.firestore()

    func registerAssociation(name: String, email: String, organizationNumber: String, numberOfApartments: String) {
        guard !name.isEmpty, !email.isEmpty, !organizationNumber.isEmpty, !numberOfApartments.isEmpty else {
            print("All fields must be filled out")
            return
        }

        let newAssociation = Association(name: name, email: email, organizationNumber: organizationNumber, numberOfApartments: numberOfApartments)
        associations.append(newAssociation)
        db.collection("associations").addDocument(data: [
            "name": name,
            "email": email,
            "organizationNumber": organizationNumber,
            "numberOfApartments": numberOfApartments
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Association added successfully")
            }
        }
    }

    struct Association: Identifiable {
        var id = UUID()
        var name: String
        var email: String
        var organizationNumber: String
        var numberOfApartments: String
    }
}

