//
//  DoorInfoView.swift
//  AltoDoorV2
//
//  Created by Ömür Şenocak on 28.11.2023.
//

import SwiftUI

struct DoorInfoView: View {
    let doorFilename: String
    @StateObject private var viewModel = AllViewModel()
    @State private var doorInfo: AllViewModel.Door? // Make it an optional

    var body: some View {
        GeometryReader { geometry in
            
            HStack{
                VStack(alignment:.leading, spacing: 40) {
                    if let doorInfo = doorInfo {
                        
                        
                        Divider()
                        HStack{
                            Text("DOOR CODE:")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Text(" \(doorInfo.id ?? "")")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .frame(maxWidth: 200)
                        }
                        
                        Divider()
                        HStack{
                            Text("COATING MODEL:")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Text(" \(doorInfo.KaplamaModeli ?? "")")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .frame(maxWidth: 200)
                        }
                        Divider()
                        
                        HStack{
                            
                            Text("WIDTH X HEIGHT:")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Text(" \(doorInfo.EnBoy ?? "")")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .frame(maxWidth: 200)
                        }
                        
                        Divider()
                        
                        HStack{
                            Text("OUTER COATING MATERIAL:")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Text(" \(doorInfo.DisMalzeme ?? "")")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .frame(maxWidth: 230)
                        }
                        Divider()
                        
                        HStack{
                            
                            Text("INNER COATING MATERIAL:")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Text(" \(doorInfo.IcMalzeme ?? "")")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .frame(maxWidth: 230)
                        }
                        Divider()
                        HStack{
                            
                            Text("PRICE:")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Text(" \(doorInfo.Fiyat ?? "")")
                                .font(.system(size: 18))  // Adjust the font size as needed
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .frame(maxWidth: 200)
                        }
                        Divider()
                        
                    } else {
                        ProgressView() // Show a loading indicator while the image is being fetched
                            .frame(width: 80, height: 80)
                    }
                }
                .frame(width: geometry.size.width / 2 ,height:  geometry.size.height * 0.9) // Use GeometryReader to dynamically set the width
                Spacer()
            }
            .padding()
            .cornerRadius(10)
            .onAppear {
                fetchDoorInfo()
            }
        }
    }

    private func fetchDoorInfo() {
        viewModel.fetchDoorInfoFromFirestore(filename: doorFilename) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let door):
                    self.doorInfo = door
                case .failure(let error):
                    print("Error fetching door info: \(error.localizedDescription)")
                    // Optionally handle the error, e.g., show an error message to the user
                }
            }
        }

    }
}

