//
//  AuthView.swift
//  AltoDoorV2
//
//  Created by Ömür Şenocak on 13.12.2023.
//


import Firebase
import FirebaseAuth
import SwiftUI


class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var loginError: String?
    @Published var registrationError: String?
    @Published var registrationSuccess = false  // New property to signal successful registration
    @StateObject var allViewModel: AllViewModel = AllViewModel()

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                // Handle login error
                self.loginError = "Login failed: \(error.localizedDescription)"
            } else {
                // Login successful
                print("User logged in successfully")
                self.isLoggedIn = true
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            print("Logged out succesfully!")
            allViewModel.cartItems.removeAll()
            
        } catch {
            print("Logout failed: \(error.localizedDescription)")
        }
    }

    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                // Handle registration error
                self.registrationError = "Registration failed: \(error.localizedDescription)"
            } else {
                // Registration successful
                print("User registered successfully")
                self.registrationSuccess = true
            }
        }
    }
}
