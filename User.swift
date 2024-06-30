//
//  User.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-18.
//

import Foundation

struct User: Identifiable {
    var id = UUID()
    var apartmentNumber: String
    var email: String
}
