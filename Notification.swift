//
//  Notification.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-18.
//

import Foundation

struct Notification: Identifiable {
    var id = UUID()
    var message: String
    var date: Date
}
