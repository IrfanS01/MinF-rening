//
//  GoogleSignInButton.swift
//  BHFArenan
//
//  Created by Irfan Sarac on 2024-06-29.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct GoogleSignInButton: View {
    @Binding var signedIn: Bool

    var body: some View {
        Button(action: {
            signInWithGoogle()
        }) {
            HStack {
                Image(systemName: "g.circle")
                Text("Sign in with Google")
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(10)
        }
    }

    func signInWithGoogle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            if let error = error {
                print("Error during Google sign-in: \(error.localizedDescription)")
                return
            }

            guard let user = signInResult?.user, let idToken = user.idToken else {
                print("Google sign-in returned no user or idToken")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase sign-in with Google credential failed: \(error.localizedDescription)")
                } else {
                    signedIn = true
                }
            }
        }
    }
}
