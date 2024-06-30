//
//  ContentView.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-14.
//

import SwiftUI

struct ContentView: View {
    @State private var signedIn = false
    @State private var userType: Int? = nil
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var associationViewModel = AssociationViewModel()

    var body: some View {
        NavigationView {
            if signedIn {
                MainView(userViewModel: userViewModel, associationViewModel: associationViewModel)
            } else {
                SignInView(signedIn: $signedIn, userType: $userType)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
