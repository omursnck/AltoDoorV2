//
//  DoorDetailsView.swift
//  AltoDoorV2
//
//  Created by Ömür Şenocak on 27.11.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DoorDetailsView: View {
    @State private var orientation = UIDeviceOrientation.unknown

    let imageURL: URL

    var body: some View {
      
            HStack{
                
                AnimatedImage(url: imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            }
            .offset(x: {
                if orientation.isFlat {
                    return 450
                } else {
                    return orientation.isPortrait ? 200 : 450
                }
            }())            .animation(.easeInOut) // Adjust the animation type as needed

            .onAppear {
                orientation = UIDevice.current.orientation

            }
            .onRotate { newOrientation in
        if UIDevice.current.orientation.rawValue <= 5{
            orientation = UIDevice.current.orientation
        }
        print("New DetailView Orientation: \(newOrientation)")

    }
        
     

    }
    
    
}
