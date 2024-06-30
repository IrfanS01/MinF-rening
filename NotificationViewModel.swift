//
//  NotificationViewModel.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-30.
//

import Foundation

class NotificationViewModel: ObservableObject {
    @Published var notifications: [Notification] = []

    func addNotification(message: String) {
        let newNotification = Notification(message: message, date: Date())
        notifications.append(newNotification)
    }

    struct Notification: Identifiable {
        var id = UUID()
        var message: String
        var date: Date
    }
}
