//
//  AdminNotificationView.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-07-08.
//

import SwiftUI

struct AdminNotificationView: View {
    @ObservedObject var viewModel: NotificationViewModel
    @State private var message = ""

    var body: some View {
        Form {
            Section(header: Text("Send Notification to All Users")) {
                TextField("Message", text: $message)
                Button("Send") {
                    viewModel.sendNotificationToAllUsers(message: message)
                    message = ""
                }
            }

            Section(header: Text("Notifications")) {
                List(viewModel.notifications) { notification in
                    VStack(alignment: .leading) {
                        Text(notification.message)
                        Text("\(notification.date, formatter: dateFormatter)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationTitle("Notifications")
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

struct AdminNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        AdminNotificationView(viewModel: NotificationViewModel())
    }
}

