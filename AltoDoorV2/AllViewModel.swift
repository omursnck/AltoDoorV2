
//
//  AllViewModel.swift
//  AltoDoorApp
//
//  Created by Ömür Şenocak on 27.11.2023.
//

import Foundation
import Firebase
import FirebaseStorage
import SDWebImageSwiftUI

class AllViewModel: ObservableObject{
    @Published var AluminumImageUrls: [URL?] = Array(repeating: nil, count: 30)
    @Published var GlassImageUrls: [URL?] = Array(repeating: nil, count: 30)
    @Published var CeramicImageUrls: [URL?] = Array(repeating: nil, count: 30)
    @Published var KompaktImageUrls: [URL?] = Array(repeating: nil, count: 31)
    @Published var MixImageUrls: [URL?] = Array(repeating: nil, count: 30)
    @Published var StainlessImageUrls: [URL?] = Array(repeating: nil, count: 30)
    
    func fetchGlassImageURLs() {
        for index in 1001...1021 {
            let imageName = String(format: "ADPG.\(index)_1024x1024.png", index)
            getGlassURL(path: imageName, index: index - 1001)
        }
    }
    func fetchAluminumImageURLs() {
        for index in 1001...1029 {
            let imageName = String(format: "APDA.\(index)_1024x1024.png", index)
            getAluminumURL(path: imageName, index: index - 1001)
        }
    }
    func fetchStainlessImageURLs() {
        for index in 1001...1002 {
            let imageName = String(format: "APDS.\(index)_1024x1024.png", index)
            getStainlessURL(path: imageName, index: index - 1001)
        }
    }
    
    func fetchCeramicImageURLs() {
        for index in 1001...1003 {
            let imageName = String(format: "APDC.\(index)_1024x1024.png", index)
            getCeramicURL(path: imageName, index: index - 1001)
        }
    }
    
    func fetchKompaktImageURLs() {
        for index in 1001...1031 {
            let imageName = String(format: "APDK.\(index)_1024x1024.png", index)
            getKompaktURL(path: imageName, index: index - 1001)
        }
    }
    
    func fetchMixImageURLs() {
        for index in 1001...1030 {
            let imageName = String(format: "ADPM.\(index)_1024x1024.png", index)
            getMixURL(path: imageName, index: index - 1001)
        }
    }


    func getAluminumURL(path: String, index: Int) {
        let storage = Storage.storage()
        let reference = storage.reference().child("Coats/\(path)")

        reference.downloadURL { url, error in
            DispatchQueue.main.async {
                if let url = url, error == nil {
                    self.AluminumImageUrls[index] = url
                } else {
                    print("Error getting download URL for image \(index + 1): \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    func getGlassURL(path: String, index: Int) {
        let storage = Storage.storage()
        let reference = storage.reference().child("Coats/\(path)")

        reference.downloadURL { url, error in
            DispatchQueue.main.async {
                if let url = url, error == nil {
                    self.GlassImageUrls[index] = url
                } else {
                    print("Error getting download URL for image \(index + 1): \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    func getCeramicURL(path: String, index: Int) {
        let storage = Storage.storage()
        let reference = storage.reference().child("Coats/\(path)")

        reference.downloadURL { url, error in
            DispatchQueue.main.async {
                if let url = url, error == nil {
                    self.CeramicImageUrls[index] = url
                } else {
                    print("Error getting download URL for image \(index + 1): \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    func getMixURL(path: String, index: Int) {
        let storage = Storage.storage()
        let reference = storage.reference().child("Coats/\(path)")

        reference.downloadURL { url, error in
            DispatchQueue.main.async {
                if let url = url, error == nil {
                    self.MixImageUrls[index] = url
                } else {
                    print("Error getting download URL for image \(index + 1): \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    func getStainlessURL(path: String, index: Int) {
        let storage = Storage.storage()
        let reference = storage.reference().child("Coats/\(path)")

        reference.downloadURL { url, error in
            DispatchQueue.main.async {
                if let url = url, error == nil {
                    self.StainlessImageUrls[index] = url
                } else {
                    print("Error getting download URL for image \(index + 1): \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    func getKompaktURL(path: String, index: Int) {
        let storage = Storage.storage()
        let reference = storage.reference().child("Coats/\(path)")

        reference.downloadURL { url, error in
            DispatchQueue.main.async {
                if let url = url, error == nil {
                    self.KompaktImageUrls[index] = url
                } else {
                    print("Error getting download URL for image \(index + 1): \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
  

    func imageAluminumURL(forIndex index: Int) -> URL? {
        return AluminumImageUrls[index]
    }
    func imageGlassURL(forIndex index: Int) -> URL? {
        return GlassImageUrls[index]
    }
    func imageKompaktURL(forIndex index: Int) -> URL? {
        return KompaktImageUrls[index]
    }
    func imageMixURL(forIndex index: Int) -> URL? {
        return MixImageUrls[index]
    }
    func imageCeramicURL(forIndex index: Int) -> URL? {
        return CeramicImageUrls[index]
    }
    func imageStainlessURL(forIndex index: Int) -> URL? {
        return StainlessImageUrls[index]
    }
}
