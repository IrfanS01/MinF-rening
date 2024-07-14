//
//  AccessRequestViewModel.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-07-11.
//

import Foundation
import FirebaseFirestore

class AccessRequestViewModel: ObservableObject {
    @Published var requests: [AccessRequest] = []
    private var db = Firestore.firestore()

    func fetchRequests(for buildingID: String) {
        db.collection("accessRequests").whereField("buildingID", isEqualTo: buildingID).whereField("status", isEqualTo: "pending").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetching access requests: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No access requests found")
                return
            }

            self.requests = documents.map { doc -> AccessRequest in
                            let data = doc.data()
                            let id = doc.documentID
                            let username = data["username"] as? String ?? ""
                            let email = data["email"] as? String ?? ""
                            let apartmentNumber = data["apartmentNumber"] as? String ?? ""
                            let phoneNumber = data["phoneNumber"] as? String ?? ""
                            let status = data["status"] as? String ?? ""
                            let buildingID = data["buildingID"] as? String ?? "" // Retrieve building ID
                            return AccessRequest(id: id, username: username, email: email, apartmentNumber: apartmentNumber, phoneNumber: phoneNumber, status: status, buildingID: buildingID)
            }
        }
    }

    func approveRequest(_ request: AccessRequest, buildingID: String) {
        let userData: [String: Any] = [
            "username": request.username,
            "email": request.email,
            "apartmentNumber": request.apartmentNumber,
            "phoneNumber": request.phoneNumber,
            "usertype": 1, // Normal user type
            "buildingID": buildingID // Include building ID
        ]
        db.collection("users").document(request.id).setData(userData) { error in
            if let error = error {
                print("Error approving request: \(error)")
            } else {
                print("User approved successfully")
                self.updateRequestStatus(request, status: "approved")
            }
        }
    }

    func denyRequest(_ request: AccessRequest) {
        updateRequestStatus(request, status: "denied")
    }

    private func updateRequestStatus(_ request: AccessRequest, status: String) {
        db.collection("accessRequests").document(request.id).updateData(["status": status]) { error in
            if let error = error {
                print("Error updating request status: \(error)")
            } else {
                self.fetchRequests(for: request.buildingID)
            }
        }
    }
}

struct AccessRequest: Identifiable {
    var id: String
    var username: String
    var email: String
    var apartmentNumber: String
    var phoneNumber: String
    var status: String
    var buildingID: String // Include building ID
}
