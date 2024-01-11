//
//  CartItemCell.swift
//  AltoDoorV2
//
//  Created by Ömür Şenocak on 15.12.2023.
//

import SwiftUI
import Firebase
import FirebaseStorage
import SDWebImageSwiftUI
import Foundation  // or import YourModuleName

struct CartItemCell: View {
    
    let cartItem: AllViewModel.CartModel
    @ObservedObject var viewModel: AllViewModel
    var body: some View {
        // Design your cart cell layout using cartItem properties
        // Example:
        VStack(alignment: .leading) {
            if let selectedImageURL = viewModel.selectedImageURL {
                      // Use the selectedImageURL to display the image in your CartView
                       AnimatedImage(url: selectedImageURL)
                  }
            Text("Kaplama Modeli: \(cartItem.KaplamaModeli ?? "")")
            Text("En Boy: \(cartItem.EnBoy ?? "")")
            Text("ID: \(cartItem.id ?? "")")
            Text("Fiyat: \(cartItem.Fiyat ?? "")")
            // Add other properties as needed
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}


