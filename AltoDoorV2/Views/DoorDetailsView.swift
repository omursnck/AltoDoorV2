//
//  DoorDetailsView.swift
//  AltoDoorV2
//
//  Created by Ömür Şenocak on 27.11.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DoorDetailsView: View {
    let imageURL: URL

    var body: some View {
        HStack{
            Spacer()
        AnimatedImage(url: imageURL)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .edgesIgnoringSafeArea(.all)
            
        }
        
     

    }
    
}
