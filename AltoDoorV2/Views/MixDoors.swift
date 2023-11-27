//
//  MixDoors.swift
//  AltoDoorApp
//
//  Created by Ömür Şenocak on 26.11.2023.
//


import SwiftUI
import Firebase
import FirebaseStorage
import SDWebImageSwiftUI
struct MixDoors: View {
    
    @StateObject private var viewModel = AllViewModel()

    var body: some View {
        VStack {
            Text("Mix Coated Doors")
                .font(Font.custom("IBMPlexSans-Medium", size: 30))
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(0..<30, id: \.self) { index in
                        if let url = viewModel.imageMixURL(forIndex: index) {
                            NavigationLink(destination: DoorDetailsView(imageURL: url)) {
                                AnimatedImage(url: url)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 800, height: 800)
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
                viewModel.fetchMixImageURLs()
        }
        }
    }
}



#Preview {
    MixDoors()
}
