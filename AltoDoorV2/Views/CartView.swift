//
//  CartView.swift
//  AltoDoorV2
//
//  Created by Ömür Şenocak on 15.12.2023.
//

import SwiftUI
import Firebase
import FirebaseStorage
import SDWebImageSwiftUI

struct CartView: View {
    @StateObject private var viewModel = AllViewModel()

    var body: some View {
        
            List(viewModel.cartItems, id: \.id) { cartItem in
                HStack{
                    if let imageURL = cartItem.imageURL {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50) // Adjust the size as needed
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50) // Placeholder image for failure
                            }
                        }
                    } else {
                        // Placeholder if imageURL is nil
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                    CartItemCell(cartItem: cartItem, viewModel: viewModel)
                }
            }
            .navigationTitle("Cart")
            .onAppear {
                viewModel.fetchCartItems()
            }
        
    }
    
}
