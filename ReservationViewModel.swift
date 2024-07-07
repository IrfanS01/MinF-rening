//
//  ReservationViewModel.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-30.
//

import Foundation
import FirebaseFirestore

class ReservationViewModel: ObservableObject {
    @Published var reservations: [Reservation] = []
    private var db = Firestore.firestore()

    init() {
        fetchReservations()
    }

    func addReservation(date: Date, type: ReservationType) {
        let newReservation = Reservation(id: UUID().uuidString, date: date, type: type)
        reservations.append(newReservation)
        saveReservationToFirebase(reservation: newReservation)
    }

    private func saveReservationToFirebase(reservation: Reservation) {
        let reservationData: [String: Any] = [
            "date": reservation.date,
            "type": reservation.type.rawValue
        ]
        db.collection("reservations").document(reservation.id).setData(reservationData) { error in
            if let error = error {
                print("Error saving reservation: \(error)")
            } else {
                print("Reservation saved successfully")
            }
        }
    }

    private func fetchReservations() {
        db.collection("reservations").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching reservations: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No reservations found")
                return
            }

            self.reservations = documents.compactMap { document -> Reservation? in
                let data = document.data()
                guard let timestamp = data["date"] as? Timestamp,
                      let typeString = data["type"] as? String,
                      let type = ReservationType(rawValue: typeString) else {
                    return nil
                }
                let date = timestamp.dateValue()
                return Reservation(id: document.documentID, date: date, type: type)
            }
        }
    }
}
