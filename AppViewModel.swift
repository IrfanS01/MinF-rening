//
//  AppViewModel.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-18.
//

import Foundation

class AppViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var reservations: [Reservation] = []
    @Published var notifications: [Notification] = []
    @Published var associations: [Association] = []

    func addNotification(message: String) {
        let newNotification = Notification(message: message, date: Date())
        notifications.append(newNotification)
    }

    func registerUser(apartmentNumber: String, email: String, phoneNumber: String, associationEmail: String) {
            guard !apartmentNumber.isEmpty, !email.isEmpty, !phoneNumber.isEmpty, !associationEmail.isEmpty else {
                print("All fields must be filled out")
                return
            }
            let newUser = User(apartmentNumber: apartmentNumber, email: email, phoneNumber: phoneNumber, associationEmail: associationEmail)
            users.append(newUser)
        }
    
    func registerAssociation(name: String, email: String, organizationNumber: String, numberOfApartments: String) {
        let newAssociation = Association(name: name, email: email, organizationNumber: organizationNumber, numberOfApartments: numberOfApartments)
        associations.append(newAssociation)
    }

    func addReservation(date: Date, type: ReservationType) {
        let newReservation = Reservation(date: date, type: type)
        reservations.append(newReservation)
    }

    struct User: Identifiable {
        var id = UUID()
        var apartmentNumber: String
        var email: String
        var phoneNumber: String
        var associationEmail: String
    }

    struct Association: Identifiable {
        var id = UUID()
        var name: String
        var email: String
        var organizationNumber: String
        var numberOfApartments: String
    }

    struct Reservation: Identifiable {
        var id = UUID()
        var date: Date
        var type: ReservationType
    }

    struct Notification: Identifiable {
        var id = UUID()
        var message: String
        var date: Date
    }

    enum ReservationType: String, CaseIterable, Identifiable {
        case guestApartment = "Guest Apartment"
        case rooftopTerrace = "Rooftop Terrace"
        
        var id: String { self.rawValue }
    }
}
