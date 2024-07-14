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
    @Published var reservationObjects: [ReservationObject] = []
    private var db = Firestore.firestore()

    init() {
        fetchReservations()
        fetchReservationObjects()
    }

    func addReservation(date: Date, startTime: Date, endTime: Date, type: ReservationType, userEmail: String) {
        let newReservation = Reservation(id: UUID().uuidString, date: date, startTime: startTime, endTime: endTime, type: type, userEmail: userEmail)
        reservations.append(newReservation)
        saveReservationToFirebase(reservation: newReservation)
    }

    func deleteReservation(id: String) {
        if let index = reservations.firstIndex(where: { $0.id == id }) {
            reservations.remove(at: index)
            db.collection("reservations").document(id).delete { error in
                if let error = error {
                    print("Error deleting reservation: \(error)")
                }
            }
        }
    }

    func addReservationObject(name: String, description: String) {
        let newObject = ReservationObject(id: UUID().uuidString, name: name, description: description)
        reservationObjects.append(newObject)
        saveReservationObjectToFirebase(object: newObject)
    }

    func deleteReservationObject(id: String) {
        if let index = reservationObjects.firstIndex(where: { $0.id == id }) {
            reservationObjects.remove(at: index)
            db.collection("reservationObjects").document(id).delete { error in
                if let error = error {
                    print("Error deleting reservation object: \(error)")
                }
            }
        }
    }

    private func saveReservationToFirebase(reservation: Reservation) {
        let reservationData: [String: Any] = [
            "date": reservation.date,
            "startTime": reservation.startTime,
            "endTime": reservation.endTime,
            "type": reservation.type.rawValue,
            "userEmail": reservation.userEmail
        ]
        db.collection("reservations").document(reservation.id).setData(reservationData) { error in
            if let error = error {
                print("Error saving reservation: \(error)")
            } else {
                print("Reservation saved successfully")
            }
        }
    }

    private func saveReservationObjectToFirebase(object: ReservationObject) {
        let objectData: [String: Any] = [
            "name": object.name,
            "description": object.description
        ]
        db.collection("reservationObjects").document(object.id).setData(objectData) { error in
            if let error = error {
                print("Error saving reservation object: \(error)")
            } else {
                print("Reservation object saved successfully")
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
                      let startTime = data["startTime"] as? Timestamp,
                      let endTime = data["endTime"] as? Timestamp,
                      let typeString = data["type"] as? String,
                      let type = ReservationType(rawValue: typeString),
                      let userEmail = data["userEmail"] as? String else {
                    return nil
                }
                let date = timestamp.dateValue()
                let start = startTime.dateValue()
                let end = endTime.dateValue()
                return Reservation(id: document.documentID, date: date, startTime: start, endTime: end, type: type, userEmail: userEmail)
            }
        }
    }

    private func fetchReservationObjects() {
        db.collection("reservationObjects").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching reservation objects: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No reservation objects found")
                return
            }

            self.reservationObjects = documents.compactMap { document -> ReservationObject? in
                let data = document.data()
                guard let name = data["name"] as? String,
                      let description = data["description"] as? String else {
                    return nil
                }
                return ReservationObject(id: document.documentID, name: name, description: description)
            }
        }
    }
}
