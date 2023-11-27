//
//  StainlessDoors.swift
//  AltoDoorApp
//
//  Created by Ömür Şenocak on 26.11.2023.
//


import SwiftUI
import Firebase
import FirebaseStorage
import SDWebImageSwiftUI

struct StainlessDoors: View {
    @StateObject private var viewModel = AllViewModel()
    @State private var orientation = UIDeviceOrientation.unknown
    @State private var searchText = ""

    var body: some View {
        VStack {
            HStack(){
                Spacer()
                Text("Stainless Coated Doors")
                    .padding(.leading)
                    .font(Font.custom("IBMPlexSans-Medium", size: 30))
                
             
                
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .frame(width: UIScreen.main.bounds.width / 4)
                

            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(filteredImages, id: \.self) { index in
                        if let url = index {
                            NavigationLink(destination: DoorDetailsView(imageURL: url)) {
                                AnimatedImage(url: url)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame( width: 800)
                                    .clipped()
                                    .id(index)
                            }
                        }  else {
                            ProgressView() // Show a loading indicator while the image is being fetched
                                .frame(width: 800, height: 800) // Adjust the size as needed
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchStainlessImageURLs()
                orientation = UIDevice.current.orientation
                
            }
            .onRotate { newOrientation in
                if UIDevice.current.orientation.rawValue <= 4{
                    orientation = UIDevice.current.orientation
                }
                print("New Orientation: \(newOrientation)")
                
            }
        }
    }
    var filteredImages: [URL?] {
        if searchText.isEmpty {
            return viewModel.StainlessImageUrls
        } else {
            return viewModel.StainlessImageUrls.filter { $0?.lastPathComponent.lowercased().contains(searchText.lowercased()) ?? false }
        }
    }
}

#Preview {
    StainlessDoors()
}
