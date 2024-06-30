//
//  ReservationViewModel.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-30.
//

import Foundation

class ReservationViewModel: ObservableObject {
    @Published var reservations: [Reservation] = []

    func addReservation(date: Date, type: ReservationType) {
        let newReservation = Reservation(date: date, type: type)
        reservations.append(newReservation)
    }

    struct Reservation: Identifiable {
        var id = UUID()
        var date: Date
        var type: ReservationType
    }

    enum ReservationType: String, CaseIterable, Identifiable {
        case guestApartment = "Guest Apartment"
        case rooftopTerrace = "Rooftop Terrace"
        
        var id: String { self.rawValue }
    }
}
