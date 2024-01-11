
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
import FirebaseFirestore
import FirebaseFirestoreSwift

class AllViewModel: ObservableObject{
    @Published var AluminumImageUrls: [URL?] = Array(repeating: nil, count: 29)
    @Published var GlassImageUrls: [URL?] = Array(repeating: nil, count: 20)
    @Published var CeramicImageUrls: [URL?] = Array(repeating: nil, count: 3)
    @Published var KompaktImageUrls: [URL?] = Array(repeating: nil, count: 31)
    @Published var MixImageUrls: [URL?] = Array(repeating: nil, count: 30)
    @Published var StainlessImageUrls: [URL?] = Array(repeating: nil, count: 2)
    @Published var selectedImageURL: URL?

    @Published var cartItems: [CartModel] = []

    struct CartModel: Codable {
        // Define properties based on your cart item structure
        var id: String?
        var KaplamaModeli: String?
        var EnBoy: String?
        var Fiyat: String?
        var imageURL: URL?  // Add the image URL property

        // Add other properties as needed
    }
    func setSelectedImageURL(_ url: URL?) {
         selectedImageURL = url
     }
    
    func fetchCartItems() {
        guard let userUID = Auth.auth().currentUser?.uid else {
              print("User is not logged in.")
              return
          }
        let cartCollection = Firestore.firestore().collection("users").document(userUID).collection("cart")

        
        cartCollection.getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching cart items: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Parse documents into your CartModel or use your existing data model
            let cartItems = documents.compactMap { document -> CartModel? in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: document.data())
                    var cartItem = try JSONDecoder().decode(CartModel.self, from: jsonData)
                    
                    // Extract the document ID from the image's filename
                    if let imageURLString = document.get("imagePath") as? String,
                       let imageURL = URL(string: imageURLString) {
                        cartItem.imageURL = imageURL
                    } else {
                        // Handle the case where the imagePathString is nil or URL creation fails
                        cartItem.imageURL = nil
                    }


                    
                    return cartItem
                } catch {
                    print("Error decoding cart item: \(error.localizedDescription)")
                    return nil
                }
            }
            
            DispatchQueue.main.async {
                self.cartItems = cartItems
            }
        }
    }

    
    func addToCart(door: Door) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("User is not logged in.")
            return
        }

        // Assuming you have a Firestore collection reference for the cart specific to each user
        let userCartCollection = Firestore.firestore().collection("users").document(userUID).collection("cart")

        // Convert the door data to a dictionary
        let doorData: [String: Any] = [
            "id": door.id ?? "",
            "KaplamaModeli": door.KaplamaModeli ?? "",
            "EnBoy": door.EnBoy ?? "",
            "Fiyat": door.Fiyat ?? ""
            // Add other properties as needed
        ]

        // Add the door data to the user's cart collection
        userCartCollection.addDocument(data: doorData) { error in
            if let error = error {
                print("Error adding to cart: \(error.localizedDescription)")
            } else {
                print("Item added to cart successfully!")
            }
        }
    }

    struct Door: Identifiable, Decodable {
        @DocumentID var id: String?
        var IcMalzeme: String
        var DisMalzeme: String
        var EnBoy: String
        var KaplamaModeli: String
        var Fiyat: String
        enum CodingKeys: String, CodingKey {
               
               case IcMalzeme
               case DisMalzeme
               case EnBoy
               case KaplamaModeli
               case Fiyat
            case id
           }
    }
    

    func extractDocumentID(from imageURL: URL) -> String {
        // Extract the document ID from the image's filename
        let imageName = imageURL.lastPathComponent
        let components = imageName.components(separatedBy: "_")
        
        // Assuming your document ID is the first part before the underscore
        if let documentID = components.first {
            // Remove the dot from the document ID
            let cleanedDocumentID = documentID.replacingOccurrences(of: ".", with: "")
            return cleanedDocumentID
        } else {
            return ""
        }
    }
    private var db = Firestore.firestore()
    
    func fetchDoorInfoFromFirestore(filename: String, completion: @escaping (Result<Door?, Error>) -> Void) {
        let collections = ["AluminumDoors", "GlassDoors", "MixDoors", "StainlessDoors", "KompaktDoors", "CeramicDoors"]
        var index = 0

        // Define a recursive function to try fetching from each collection
        func fetchFromCollection() {
            guard index < collections.count else {
                // If we have tried all collections and haven't found the data, complete with nil
                completion(.success(nil))
                return
            }

            let collection = collections[index]
            index += 1

            db.collection(collection).document(filename).getDocument { document, error in
                if let error = error {
                    completion(.failure(error))
                } else if let document = document, document.exists {
                    do {
                        guard let data = try? document.data(as: Door.self) else {
                            // If data cannot be decoded, move on to the next collection
                            fetchFromCollection()
                            return
                        }

                        // If data is successfully decoded, complete with the data
                        completion(.success(data))
                    } catch {
                        // If an error occurs during decoding, move on to the next collection
                        fetchFromCollection()
                    }
                } else {
                    // If document does not exist, move on to the next collection
                    fetchFromCollection()
                }
            }
        }

        // Start fetching from the first collection
        fetchFromCollection()
    }

  
    func addAluminumDoors() {
        let doorData = [
            "KaplamaModeli": "Aluminum Coating",
            "EnBoy": "1200 x 2300 mm",
            "DisMalzeme": "3mm Aluminum",
            "IcMalzeme": "3mm Aluminum"
        ]

        let baseID = "APD1001A"  // Set the starting ID
        var currentID = baseID

        let predefinedPrices = [1815.00,2019.60,1927.20,1927.20,2032.80,1927.20,2032.80,1927.20,1927.20,2204.40,1927.20,2125.20,2125.20,1927.20,1927.20,2125.20,1927.20,1927.20,2125.20,2125.20,1927.20,2125.20,2191.20,2019.60,2257.20,2204.40,2178.00,2125.20,2125.20]  // Your predefined list of prices

        for index in 1...29 {
            do {
                // Add the currentID to the doorData
                var dataWithID = doorData
                dataWithID["id"] = currentID

                // Use the predefined price based on the index (adjust as needed)
                let priceIndex = (index - 1) % predefinedPrices.count
                dataWithID["Fiyat"] = "\(predefinedPrices[priceIndex]) €"

                // Add the document to Firestore
                _ = try db.collection("AluminumDoors").document(currentID).setData(dataWithID)

                // Update the currentID for the next iteration
                if let numericPart = Int(currentID.dropFirst(3).dropLast(1)) {
                    currentID = "APD" + String(numericPart + 1) + "A"
                } else {
                    print("Error parsing numeric part of ID")
                    break
                }
            } catch {
                print("Error adding door: \(error.localizedDescription)")
            }
        }
    }

    func addGlassDoors() {
        let doorData = [
            "KaplamaModeli": "Glass Coating",
            "EnBoy": "1200 x 2300 mm",
            "DisMalzeme": "6mm Tempered glass or 6mm Laminated Tempered UV Flatbed printed, 1mm painted Aluminum plate",
            "IcMalzeme": "3mm Aluminum or 4mm Compact"
        ]

        let baseID = "APD1001G"  // Set the starting ID
        var currentID = baseID

        let predefinedPrices = [3062.40, 2943.60, 3003.00, 2943.60, 3062.40,2943.60,3062.40,3062.40,3062.40,2943.60,3003.00,3003.00,2943.60,3062.40,3062.40,3003.00,2943.60,2943.60,3062,40,2943.60]  // Your predefined list of prices

        for index in 1...20 {
            do {
                // Add the currentID to the doorData
                var dataWithID = doorData
                dataWithID["id"] = currentID

                // Use the predefined price based on the index (adjust as needed)
                let priceIndex = (index - 1) % predefinedPrices.count
                dataWithID["Fiyat"] = "\(predefinedPrices[priceIndex]) €"

                // Add the document to Firestore
                _ = try db.collection("GlassDoors").document(currentID).setData(dataWithID)

                // Update the currentID for the next iteration
                if let numericPart = Int(currentID.dropFirst(3).dropLast(1)) {
                    currentID = "APD" + String(numericPart + 1) + "G"
                } else {
                    print("Error parsing numeric part of ID")
                    break
                }
            } catch {
                print("Error adding door: \(error.localizedDescription)")
            }
        }
    }

    func addKompaktDoors() {
        let doorData = [
            "KaplamaModeli": "Compact Coating",
            "EnBoy": "1200 x 2300 mm",
            "DisMalzeme": "6mm Compact UV Resistant",
            "IcMalzeme": "3mm Aluminum or 4mm Compact"
        ]

        let baseID = "APD1001C"  // Set the starting ID
        var currentID = baseID

        let predefinedPrices = [2323.20, 2323.20, 2323.20 , 2323.20 , 2481.60, 2323.20 , 2323.20 , 2323.20 , 2323.20 , 2323.20, 2481.60,2323.20, 2481.60,2481.60,2323.20,2323.20,2481.60,2481.60,2323.20,2323.20,2323.20,2323.20,2323.20,2323.20,2323.20,2481.60,2323.20,2323.20,2481.60 ,2323.20,2323.20,]  // Your predefined list of prices

        for index in 1...31 {
            do {
                // Add the currentID to the doorData
                var dataWithID = doorData
                dataWithID["id"] = currentID

                // Use the predefined price based on the index (adjust as needed)
                let priceIndex = (index - 1) % predefinedPrices.count
                dataWithID["Fiyat"] = "€ \(predefinedPrices[priceIndex])"

                // Add the document to Firestore
                _ = try db.collection("KompaktDoors").document(currentID).setData(dataWithID)

                // Update the currentID for the next iteration
                if let numericPart = Int(currentID.dropFirst(3).dropLast(1)) {
                    currentID = "APD" + String(numericPart + 1) + "C"
                } else {
                    print("Error parsing numeric part of ID")
                    break
                }
            } catch {
                print("Error adding door: \(error.localizedDescription)")
            }
        }
    }

    func addMixDoors() {
        let doorData = [
            "KaplamaModeli": "Mix Coating",
            "EnBoy": "1200 x 2300 mm",
            "IcMalzeme": "3mm Aluminum or 4mm Compact"
        ]

        let baseID = "APD1001M"  // Set the starting ID
        var currentID = baseID

        let predefinedDisMalzemeOptions = [
            "Compact and Aluminum coating on the outside, 1mm Aluminum plate on the back",
                  "Compact and Glass coating on the outside, 1mm Aluminum plate on the back",
                  "Compact and Glass coating on the outside, 1mm Aluminum plate on the back",
                  "Compact and Aluminum coating on the outside, 1mm Aluminum plate on the back",
                  "Compact and Aluminum coating on the outside, 1mm Aluminum plate on the back",
                  "Compact and Aluminum coating on the outside, 1mm Aluminum plate on the back",
                  "Compact and Stainless Steel coating on the outside, 1mm Aluminum plate on the back",
                  "Compact and Stainless Steel coating on the outside, 1mm Aluminum plate on the back",
                  "Compact and Aluminum coating on the outside, 1mm Aluminum plate on the back",
                  "Compact and Enamel painted glass on the outside, 1mm Aluminum plate on the back",
                  "Compact and Enamel painted glass on the outside, 1mm Aluminum plate on the back",
                  "Compact and Aluminum coating on the outside, 1mm Aluminum plate on the back",
                  "Marble and Compact coating on the outside, 1mm Aluminum plate on the back",
                  "Marble and Compact coating on the outside, 1mm Aluminum plate on the back",
                  "Marble and Compact coating on the outside, 1mm Aluminum plate on the back",
                  "Marble and Compact coating on the outside, 1mm Aluminum plate on the back",
                  "Compact and Enamel painted glass on the outside, 1mm Aluminum plate on the back",
                  "Compact and Enamel painted glass on the outside, 1mm Aluminum plate on the back",
                  "Compact and Aluminum coating on the outside, 1mm Aluminum plate on the back",
                  "Compact and Enamel painted glass on the outside, 1mm Aluminum plate on the back",
                  "Aluminum and Enamel painted glass on the outside, 1mm Aluminum plate on the back",
                  "Compact and Aluminum coating on the outside, 1mm Aluminum plate on the back",
                  "Aluminum and Enamel painted glass on the outside, 1mm Aluminum plate on the back",
                  "Aluminum and Enamel painted glass on the outside, 1mm Aluminum plate on the back",
                  "Compact and Aluminum coating on the outside, 1mm Aluminum plate on the back",
                  "Ceramic and Aluminum coating on the outside, 1mm Aluminum plate on the back",
                  "Ceramic and Aluminum coating on the outside, 1mm Aluminum plate on the back",
                  "Compact and Enamel painted glass on the outside, 1mm Aluminum plate on the back",
                  "Compact and Enamel painted glass on the outside, 1mm Aluminum plate on the back",
                  "Marble and Aluminum coating on the outside, 1mm Aluminum plate on the back"
        ]

        let predefinedPrices = [
            2521.20, 2475.00, 2475.00, 2560.80, 2560.80, 2521.20, 2626.80, 2521.20, 2475.00, 2475.00,
            2494.80, 2475.00, 2475.00, 2475.00, 2475.00, 2521.20, 2521.20, 2475.00, 2475.00, 2475.00,
            2521.20, 2475.00, 2560.80, 2521.20, 2560.80, 2475.00, 2521.20, 2521.20, 2521.20, 2521.20
        ]  // Your predefined list of prices

        for index in 0..<predefinedDisMalzemeOptions.count {
            do {
                // Add the currentID, DisMalzeme, and Fiyat to the doorData
                var dataWithID = doorData
                dataWithID["id"] = currentID
                dataWithID["DisMalzeme"] = predefinedDisMalzemeOptions[index]

                // Use the predefined price based on the index
                let priceIndex = index % predefinedPrices.count
                dataWithID["Fiyat"] = "\(predefinedPrices[priceIndex]) €"

                // Add the document to Firestore
                _ = try db.collection("MixDoors").document(currentID).setData(dataWithID)

                // Update the currentID for the next iteration
                if let numericPart = Int(currentID.dropFirst(3).dropLast(1)) {
                    currentID = "APD" + String(numericPart + 1) + "M"
                } else {
                    print("Error parsing numeric part of ID")
                    break
                }
            } catch {
                print("Error adding door: \(error.localizedDescription)")
            }
        }
    }


    func addStainlessDoors() {
        let doorData = [
            "KaplamaModeli": "Stainless Steel Coating",
            "EnBoy": "1200 x 2300 mm",
            "DisMalzeme": "0.80mm Textured Stainless Plate",
            "IcMalzeme": "3mm Aluminum or 4mm Compact"
        ]

        let baseID = "APD1001S"  // Set the starting ID
        var currentID = baseID

        let predefinedPrices = [2824.80, 2824.80]  // Your predefined list of prices

        for index in 1...2 {
            do {
                // Add the currentID to the doorData
                var dataWithID = doorData
                dataWithID["id"] = currentID

                // Use the predefined price based on the index (adjust as needed)
                let priceIndex = (index - 1) % predefinedPrices.count
                dataWithID["Fiyat"] = "\(predefinedPrices[priceIndex]) €"

                // Add the document to Firestore
                _ = try db.collection("StainlessDoors").document(currentID).setData(dataWithID)

                // Update the currentID for the next iteration
                if let numericPart = Int(currentID.dropFirst(3).dropLast(1)) {
                    currentID = "APD" + String(numericPart + 1) + "S"
                } else {
                    print("Error parsing numeric part of ID")
                    break
                }
            } catch {
                print("Error adding door: \(error.localizedDescription)")
            }
        }
    }

    func addCeramicDoors() {
             let doorData = [
                 "KaplamaModeli": "Ceramic Coating",
                 "EnBoy": "1200 x 2300 mm",
                 "DisMalzeme": "8-10mm Ceramic Plate behind 1mm Aluminum Plate",
                 "IcMalzeme": "3mm Aluminum or 4mm Compact"
             ]

             let baseID = "APD1001CC"  // Set the starting ID
             var currentID = baseID

        let predefinedPrices = [3115.20, 3115.20, 3115.20]  // Your predefined list of prices

             for index in 1...3 {
                 do {
                     // Add the currentID to the doorData
                     var dataWithID = doorData
                     dataWithID["id"] = currentID

                     // Use the predefined price based on the index (adjust as needed)
                     let priceIndex = (index - 1) % predefinedPrices.count
                     dataWithID["Fiyat"] = "\(predefinedPrices[priceIndex]) €"

                     // Add the document to Firestore
                     _ = try db.collection("CeramicDoors").document(currentID).setData(dataWithID)

                     // Update the currentID for the next iteration
                     if let numericPart = Int(currentID.dropFirst(3).dropLast(2)) {
                         currentID = "APD" + String(numericPart + 1) + "CC"
                     } else {
                         print("Error parsing numeric part of ID")
                         break
                     }
                 } catch {
                     print("Error adding door: \(error.localizedDescription)")
                 }
             }
         }

    
    func fetchGlassImageURLs() {
        for index in 1001...1021 {
            let imageName = String(format: "APD.\(index)G_1024x1024.png", index)
            getGlassURL(path: imageName, index: index - 1001)
        }
    }
    func fetchAluminumImageURLs() {
        for index in 1001...1029 {
            let imageName = String(format: "APD.\(index)A_1024x1024.png", index)
            getAluminumURL(path: imageName, index: index - 1001)
        }
    }
    func fetchStainlessImageURLs() {
        for index in 1001...1002 {
            let imageName = String(format: "APD.\(index)S_1024x1024.png", index)
            getStainlessURL(path: imageName, index: index - 1001)
        }
    }
    func fetchCeramicImageURLs() {
        for index in 1001...1003 {
            let imageName = String(format: "APD.\(index)CC_1024x1024.png", index)
            getCeramicURL(path: imageName, index: index - 1001)
        }
    }
    func fetchKompaktImageURLs() {
        for index in 1001...1031 {
            let imageName = String(format: "APD.\(index)C_1024x1024.png", index)
            getKompaktURL(path: imageName, index: index - 1001)
        }
    }
    func fetchMixImageURLs() {
        for index in 1001...1030 {
            let imageName = String(format: "APD.\(index)M_1024x1024.png", index)
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
