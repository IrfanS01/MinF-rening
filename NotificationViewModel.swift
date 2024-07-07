//
//  NotificationViewModel.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-30.
//

import Foundation
import FirebaseFirestore

class NotificationViewModel: ObservableObject {
    @Published var notifications: [Notification] = []
    private var db = Firestore.firestore()

    init() {
        fetchNotifications()
    }

    func addNotification(message: String) {
        let newNotification = Notification(id: UUID().uuidString, message: message, date: Date())
        notifications.append(newNotification)
        saveNotificationToFirebase(notification: newNotification)
    }

    private func saveNotificationToFirebase(notification: Notification) {
        let notificationData: [String: Any] = [
            "message": notification.message,
            "date": notification.date
        ]
        db.collection("notifications").document(notification.id).setData(notificationData) { error in
            if let error = error {
                print("Error saving notification: \(error)")
            } else {
                print("Notification saved successfully")
            }
        }
    }

    private func fetchNotifications() {
        db.collection("notifications").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching notifications: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No notifications found")
                return
            }

            self.notifications = documents.compactMap { document -> Notification? in
                let data = document.data()
                guard let timestamp = data["date"] as? Timestamp,
                      let message = data["message"] as? String else {
                    return nil
                }
                let date = timestamp.dateValue()
                return Notification(id: document.documentID, message: message, date: date)
            }
        }
    }
}
