//
//  RegisterView.swift
//  AltoDoorV2
//
//  Created by Ömür Şenocak on 13.12.2023.
//

import SwiftUI


struct RegisterView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var registrationError: String?
    @ObservedObject var ViewModel: AuthViewModel
    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Divider()

            TextField("Username", text: $username)
                .padding()
                .frame(height: 30)
                .autocapitalization(.none)

            
                .padding(.bottom, 8)

                Divider()
            TextField("Email", text: $email)
                .padding()
                .frame(height: 30)
                .autocapitalization(.none)

            
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.bottom, 8)
            Divider()

            SecureField("Password", text: $password)
                .padding()
                .frame(height: 30)
            
            
                .padding(.bottom, 16)
            Divider()

            Button(action: {
                // Add your registration logic here
                ViewModel.register(email: email, password: password)
                print("Registration button tapped")
                // You may want to call a function to handle the registration process
            }) {
                Text("Register")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 150, height: 40)
                    .background(Color.purple)
                    .cornerRadius(8)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: UIScreen.main.bounds.width/2, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }
}

