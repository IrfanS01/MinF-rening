//
//  SignUpView.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-29.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @Binding var signedIn: Bool
    @Binding var userType: Int?
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole = "User"
    @State private var showAlert = false
    @State private var alertMessage: String? = nil
    var auth = Auth.auth()
    var db = Firestore.firestore()
    let roles = ["User", "Association"]

    var body: some View {
        VStack {
            Spacer()

            VStack(alignment: .leading, spacing: 15) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                if let alertMessage = alertMessage {
                    Text(alertMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                }

                Text("Username")
                    .font(.headline)
                TextField("Enter your username", text: $username)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                Text("Email")
                    .font(.headline)
                TextField("Enter your email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                Text("Password")
                    .font(.headline)
                SecureField("Enter your password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                Text("Role")
                    .font(.headline)
                Picker("Select your role", selection: $selectedRole) {
                    ForEach(roles, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            }
            .padding(.horizontal, 20)

            Button(action: {
                signUp()
            }, label: {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            .padding(.top, 20)
            .padding(.horizontal, 20)

            Spacer()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }

    func signUp() {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                if let user = authResult?.user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = username
                    changeRequest.commitChanges { error in
                        if let error = error {
                            alertMessage = error.localizedDescription
                            showAlert = true
                        } else {
                            let userTypeValue = selectedRole == "User" ? 1 : 2
                            saveUserProfile(uid: user.uid, username: username, email: email, userType: userTypeValue)
                            self.userType = userTypeValue
                            self.signedIn = true
                        }
                    }
                }
            }
        }
    }

    func saveUserProfile(uid: String, username: String, email: String, userType: Int) {
        let userData: [String: Any] = [
            "username": username,
            "email": email,
            "usertype": userType,
            "uid": uid
        ]

        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                alertMessage = error.localizedDescription
            } else {
                print("User profile saved successfully")
            }
        }
    }
}
