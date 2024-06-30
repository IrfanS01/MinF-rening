//
//  SignInView.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-30.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct SignInView: View {
    @Binding var signedIn: Bool
    @Binding var userType: Int?
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("background_image")
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 3)
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    VStack {
                        Text("Min Förening")
                            .font(.system(size: 50, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding(.bottom, 20)

                        VStack(alignment: .leading, spacing: 15) {
                            Text("Email")
                                .font(.headline)
                            TextField("Enter your email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )

                            Text("Password")
                                .font(.headline)
                            
                            ZStack {
                                if isPasswordVisible {
                                    TextField("Enter your password", text: $password)
                                        .padding()
                                        .background(Color(.secondarySystemBackground))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                } else {
                                    SecureField("Enter your password", text: $password)
                                        .padding()
                                        .background(Color(.secondarySystemBackground))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                }

                                HStack {
                                    Spacer()
                                    Button(action: {
                                        isPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 10)
                                    }
                                }
                            }
                        }
                        .padding()

                        if showAlert {
                            Text(alertMessage)
                                .foregroundColor(.red)
                                .padding(.horizontal, 20)
                        }

                        HStack {
                            Text("Don't have an account?")
                                .font(.footnote)
                            NavigationLink(destination: SignUpView(signedIn: $signedIn, userType: $userType)) {
                                Text("Sign Up")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            .zIndex(1)  // Ensuring the NavigationLink is clickable
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 10)

                        Button(action: {
                            signIn()
                        }, label: {
                            Text("Sign In")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        })
                        .shadow(radius: 5)
                    }
                    .padding()
                    .background(Color(.systemGroupedBackground).opacity(0.9))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: geometry.size.width * 0.9)

                    Spacer()

                    GoogleSignInButton(signedIn: $signedIn)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.bottom, 20)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                // Handle successful sign-in
                signedIn = true
            }
        }
    }
}
