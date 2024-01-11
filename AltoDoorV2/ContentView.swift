//
//  ContentView.swift
//  AltoDoorApp
//
//  Created by Ömür Şenocak on 26.11.2023.
//


import SwiftUI
import Firebase
struct ContentView: View {
    @Binding var email: String
    @State private var loginError: String?
    @ObservedObject var ViewModel: AuthViewModel
    var body: some View {
        
        NavigationView {
            
            VStack{
                List {
                    
                    NavigationLink(destination: AluminumDoors()) {
                        HStack {
                            Image("Aluminum") // Use the asset name here
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24) // Adjust the size as needed
                            
                            Text("Aluminum")
                                .font(.headline)
                        }
                    }
                    
                    NavigationLink(destination: GlassDoors()) {
                        HStack {
                            Image("Glass") // Use the asset name here
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24) // Adjust the size as needed
                            
                            Text("Glass")
                                .font(.headline)
                        }
                    }
                    NavigationLink(destination: MixDoors()) {
                        HStack {
                            Image("Mix") // Use the asset name here
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24) // Adjust the size as needed
                            
                            Text("Mix")
                                .font(.headline)
                        }                                    }
                    NavigationLink(destination: CeramicDoors()) {
                        HStack {
                            Image("Ceramic") // Use the asset name here
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24) // Adjust the size as needed
                            
                            Text("Ceramic")
                                .font(.headline)
                        }                                    }
                    NavigationLink(destination: KompaktDoors()) {
                        HStack {
                            Image("Kompakt") // Use the asset name here
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24) // Adjust the size as needed
                            
                            Text("Compact")
                                .font(.headline)
                        }                                    }
                    NavigationLink(destination: StainlessDoors()) {
                        HStack {
                            Image("Stainless") // Use the asset name here
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24) // Adjust the size as needed
                            
                            Text("Stainless")
                                .font(.headline)
                        }
                    }
                    
                    NavigationLink(destination: CartView()) {
                        HStack {
                            Image(systemName: "cart.fill") // Use the asset name here
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24) // Adjust the size as needed
                            
                            Text("Cart")
                                .font(.headline)
                        }
                    }
                    
                }
                Spacer()
                
          
                    HStack{
                        
                        Text("Welcome \(email)")
                            .padding()
                        Button{
                            ViewModel.logout()
                        }label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .padding()
                        }
                        
                        
                        
                    }
                }
                .listStyle(SidebarListStyle())
                .navigationTitle("Categories")
                AluminumDoors()
                
            }
            .navigationViewStyle(DefaultNavigationViewStyle())
            
            
            
        }
        
        
    }
    
    

