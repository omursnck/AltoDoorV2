//
//  AluminumView.swift
//  AltoDoorApp
//
//  Created by Ömür Şenocak on 26.11.2023.
//

import SwiftUI
import Firebase
import FirebaseStorage
import SDWebImageSwiftUI

struct AluminumDoors: View {
    @StateObject private var viewModel = AllViewModel()
    @State private var orientation = UIDeviceOrientation.unknown
    
    var body: some View {
        VStack {
            Text("Aluminum Coated Doors")
                .font(Font.custom("IBMPlexSans-Medium", size: 30))
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(0..<30, id: \.self) { index in
                        if let url = viewModel.imageAluminumURL(forIndex: index) {
                            NavigationLink(destination: DoorDetailsView(imageURL: url)) {
                                AnimatedImage(url: url)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                
                                    .frame( width: orientation.isPortrait ? 800 : 600, height: orientation.isPortrait ? 800 : 600)
                                    .clipped()
                                    .id(index)
                            }
                        } else {
                            ProgressView() // Show a loading indicator while the image is being fetched
                                .frame(width: 600, height: 600) // Adjust the size as needed
                        }
                    }
                }
            }.onAppear {
                viewModel.fetchAluminumImageURLs()
                
            }
            .onRotate { newOrientation in
                orientation = newOrientation
            }
         
            
        }
        
    }
}




#Preview {
    AluminumDoors()
}
