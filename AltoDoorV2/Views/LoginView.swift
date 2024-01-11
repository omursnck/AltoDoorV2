//
//  LoginView.swift
//  AltoDoorV2
//
//  Created by Ömür Şenocak on 13.12.2023.
//

import SwiftUI
import Firebase
import SwiftUI
import Firebase

struct LoginView: View {
    @State var email: String = ""
    @State private var password: String = ""
    @State private var loginError: String?
    @State private var showRegisterView = false

    @ObservedObject var ViewModel: AuthViewModel
    var body: some View {
        if ViewModel.isLoggedIn != true{
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
   
                
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

                
                Button(action: {
                    // Add your login logic here
                    ViewModel.login(email: email, password: password)
                    print("Login button tapped")
                    password = ""
                    // You may want to call a function to handle the registration process
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150, height: 40)
                        .background(Color.purple)
                        .cornerRadius(8)
                }
                .padding(.vertical)
                    
                Button{
                    showRegisterView = true
                }label:{
                    Text("Doesn't have an account? Register Now!")
                                 .foregroundColor(.blue)
                                 .padding(.top, 16)
                }
                
                Spacer()
            }
            .sheet(isPresented: $showRegisterView, content: {
                RegisterView(ViewModel: ViewModel)
                
                  })
            .onChange(of: ViewModel.registrationSuccess) { success in
                          if success {
                              // Handle successful registration here
                              showRegisterView = false
                          }
                      }
            .padding()
            .frame(maxWidth: UIScreen.main.bounds.width/2, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
        }else{
            ContentView(email: $email, ViewModel: ViewModel)
        }
        }
    


}
