//
//  NotificationView.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-18.
//

import SwiftUI

struct NotificationView: View {
    @ObservedObject var viewModel: NotificationViewModel
    @State private var message = ""

    var body: some View {
        Form {
            Section(header: Text("Post Notification")) {
                TextField("Message", text: $message)
                Button("Post") {
                    viewModel.addNotification(message: message)
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

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(viewModel: NotificationViewModel())
    }
}
