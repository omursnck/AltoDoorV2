//
//  GlassDoor.swift
//  AltoDoorApp
//
//  Created by Ömür Şenocak on 26.11.2023.
//

import SwiftUI
import Firebase
import FirebaseStorage
import SDWebImageSwiftUI

struct GlassDoors: View {
    @StateObject private var viewModel = AllViewModel()
    @State private var searchText = ""

    var body: some View {
        VStack {
           
            
            Text("Glass Coated Doors")
                .font(Font.custom("IBMPlexSans-Medium", size: 30))

            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(0..<29, id: \.self) { index in
                        if let url = viewModel.imageGlassURL(forIndex: index) {
                            NavigationLink(destination: DoorDetailsView(imageURL: url)) {
                                AnimatedImage(url: url)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 800, height: 800)
                                    .clipped()
                                    .id(index)
                            }
                        } else {
                            ProgressView()
                                .frame(width: 600, height: 600)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchGlassImageURLs()
            }
        }
    }

    var filteredImages: [URL?] {
        if searchText.isEmpty {
            return viewModel.GlassImageUrls
        } else {
            return viewModel.GlassImageUrls.filter { $0?.lastPathComponent.lowercased().contains(searchText.lowercased()) ?? false }
        }
    }
}




#Preview {
    GlassDoors()
}
