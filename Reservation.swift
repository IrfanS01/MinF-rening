//
//  Reservation.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-18.
//

import Foundation

struct Reservation: Identifiable {
    var id: String
    var date: Date
    var type: ReservationType
}

enum ReservationType: String, CaseIterable, Identifiable {
    case guestApartment = "Guest Apartment"
    case rooftopTerrace = "Rooftop Terrace"
    
    var id: String { self.rawValue }
}
