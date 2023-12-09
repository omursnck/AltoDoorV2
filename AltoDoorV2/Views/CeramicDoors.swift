//
//  CeramicDoors.swift
//  AltoDoorApp
//
//  Created by Ömür Şenocak on 26.11.2023.
//

import SwiftUI
import Firebase
import FirebaseStorage
import SDWebImageSwiftUI
struct CeramicDoors: View {
    @StateObject private var viewModel = AllViewModel()
    @State private var orientation = UIDeviceOrientation.unknown
    @State private var searchText = ""

    var body: some View {
        VStack {
            HStack(){
                Image("Altosquare")
                   .resizable()
                   .scaledToFit()
                   .frame(width: 50, height: 50)
                   .cornerRadius(10)
                   .padding(.horizontal)
                
                Text("Ceramic Coated Doors")
                    .padding(.leading)
                    .font(Font.custom("IBMPlexSans-Medium", size: 30))
                
                Spacer()

                
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .frame(width: UIScreen.main.bounds.width / 4)
            
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(filteredImages, id: \.self) { index in
                        if let url = index {
                            let doorFilename = viewModel.extractDocumentID(from: url) // Extract the correct document ID

                            NavigationLink(destination: DoorDetailsView(imageURL: url, doorFilename: doorFilename)) {
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
                viewModel.fetchCeramicImageURLs()
                viewModel.addCeramicDoors()
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
            return viewModel.CeramicImageUrls
        } else {
            return viewModel.CeramicImageUrls.filter { url in
                if let lastPathComponent = url?.lastPathComponent {
                    let imageNameWithoutResolution = lastPathComponent.components(separatedBy: "_").first ?? ""
                    return imageNameWithoutResolution.lowercased().contains(searchText.lowercased())
                }
                return false
            }
        }
    }
}





#Preview {
    CeramicDoors()
}
