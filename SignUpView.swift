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
    @State private var confirmPassword = ""
    @State private var apartmentNumber = ""
    @State private var phoneNumber = ""
    @State private var adminEmail = "" // New field for administrator email
    @State private var selectedRole = "User"
    @State private var showAlert = false
    @State private var alertMessage: String? = nil
    @State private var showSuccessAlert = false
    var auth = Auth.auth()
    var db = Firestore.firestore()
    let roles = ["User", "Admin"]

    var body: some View {
        ScrollView {
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

                    Text("Confirm Password")
                        .font(.headline)
                    SecureField("Confirm your password", text: $confirmPassword)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)

                    Text("Apartment Number")
                        .font(.headline)
                    TextField("Enter your apartment number", text: $apartmentNumber)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)

                    Text("Phone Number")
                        .font(.headline)
                    TextField("Enter your phone number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)

                    if selectedRole == "User" {
                        Text("Administrator Email")
                            .font(.headline)
                        TextField("Enter administrator email", text: $adminEmail)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }

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
        .alert(isPresented: $showSuccessAlert) {
            Alert(title: Text("Request Sent"), message: Text("Your request has been sent. Please wait for approval."), dismissButton: .default(Text("OK")))
        }
    }

    func signUp() {
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }

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
                            if userTypeValue == 2 {
                                // Direct registration for Admin
                                registerAdmin(uid: user.uid, username: username, email: email, apartmentNumber: apartmentNumber, phoneNumber: phoneNumber)
                            } else {
                                // Validate admin email and send access request for User
                                validateAdminEmailAndSendRequest(uid: user.uid, username: username, email: email, apartmentNumber: apartmentNumber, phoneNumber: phoneNumber, adminEmail: adminEmail, userType: userTypeValue)
                            }
                        }
                    }
                }
            }
        }
    }

    func registerAdmin(uid: String, username: String, email: String, apartmentNumber: String, phoneNumber: String) {
        let adminData: [String: Any] = [
            "uid": uid,
            "username": username,
            "email": email,
            "apartmentNumber": apartmentNumber,
            "phoneNumber": phoneNumber,
            "usertype": 2 // Admin user type
        ]

        db.collection("users").document(uid).setData(adminData) { error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                print("Admin registered successfully")
                self.signedIn = true
                self.userType = 2
            }
        }
    }

    func validateAdminEmailAndSendRequest(uid: String, username: String, email: String, apartmentNumber: String, phoneNumber: String, adminEmail: String, userType: Int) {
        db.collection("users").whereField("email", isEqualTo: adminEmail).whereField("usertype", isEqualTo: 2).getDocuments { (querySnapshot, error) in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                if querySnapshot?.documents.count == 0 {
                    alertMessage = "Administrator with this email not found."
                    showAlert = true
                } else {
                    sendAccessRequest(uid: uid, username: username, email: email, apartmentNumber: apartmentNumber, phoneNumber: phoneNumber, adminEmail: adminEmail, userType: userType)
                    self.showSuccessAlert = true // Show success alert for user
                }
            }
        }
    }

    func sendAccessRequest(uid: String, username: String, email: String, apartmentNumber: String, phoneNumber: String, adminEmail: String, userType: Int) {
        let requestData: [String: Any] = [
            "uid": uid,
            "username": username,
            "email": email,
            "apartmentNumber": apartmentNumber,
            "phoneNumber": phoneNumber,
            "adminEmail": adminEmail, // Include admin email
            "userType": userType, // Include user type
            "status": "pending"
        ]

        db.collection("accessRequests").document(uid).setData(requestData) { error in
            if let error = error {
                alertMessage = error.localizedDescription
            } else {
                print("Access request sent successfully")
            }
        }
    }
}
