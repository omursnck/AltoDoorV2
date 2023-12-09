//
//  ContentView.swift
//  AltoDoorApp
//
//  Created by Ömür Şenocak on 26.11.2023.
//


import SwiftUI

struct ContentView: View {

    var body: some View {
       
        NavigationView {
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
                        }                                    }
                }
                .listStyle(SidebarListStyle())
                .navigationTitle("Categories")
            AluminumDoors()
            
            }
        .navigationViewStyle(DefaultNavigationViewStyle())
        
      
         
    }
   
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
