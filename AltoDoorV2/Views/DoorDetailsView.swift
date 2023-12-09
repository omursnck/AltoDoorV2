//
//  DoorDetailsView.swift
//  AltoDoorV2
//
//  Created by Ömür Şenocak on 27.11.2023.
//
import SwiftUI
import SDWebImageSwiftUI

struct DoorDetailsView: View {
    @State private var offset: CGSize = CGSize(width: 180, height: -60)
    @State private var initialOffset: CGSize = CGSize(width: 200, height: -40)
    @GestureState private var scale: CGFloat = 1.0
    @State private var finalScale: CGFloat = 1.0
    @State private var isPortrait = true
    @State private var isLandscape = false
    @State private var isFlat = false
    @State private var wasItLandscape = false

    let imageURL: URL
    let doorFilename: String

    var body: some View {
        ZStack {
            // Place DoorInfoView in the background
            DoorInfoView(doorFilename: doorFilename)

            HStack {
                // Display the AnimatedImage on top
                AnimatedImage(url: imageURL)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale * finalScale)
                    .frame(width: UIScreen.main.bounds.width, height: imageSize())
                    .offset(offset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = CGSize(width: initialOffset.width + gesture.translation.width,
                                                height: initialOffset.height + gesture.translation.height)
                            }
                            .onEnded { _ in
                                initialOffset = offset
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .updating($scale) { value, scale, _ in
                                                 scale = value
                                             }
                                             .onEnded { value in
                                                 finalScale *= value
                                             }                    )
            }
        }
        .animation(.easeInOut)
        .onAppear {
            updateOrientation()
        }
        .onRotate { newOrientation in
            isPortrait = newOrientation.isPortrait
            isLandscape = newOrientation.isLandscape
            isFlat = newOrientation.isFlat
        }
    }

    private func updateOrientation() {
        isPortrait = UIDevice.current.orientation.isPortrait
        isLandscape = UIDevice.current.orientation.isLandscape
        isFlat = UIDevice.current.orientation.isFlat
    }

    private func imageSize() -> CGFloat {
        if isPortrait {
            return UIScreen.main.bounds.width
        } else if isLandscape {
            return UIScreen.main.bounds.height 
        } else {
            return UIScreen.main.bounds.height
        }
    }
}
