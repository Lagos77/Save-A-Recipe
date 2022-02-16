//
//  ShoppingCartViewModel.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-15.
//

import Foundation
import Firebase

class ShoppingCartViewModel: ObservableObject {

    var db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    @Published var products = [Product]()
    @Published var newProduct = ""
    
    
    func saveToFirestore(productName: String) {
        let product = Product(name: productName)
        if let uid = uid {
        do {
            _ = try db.collection("user").document(uid).collection("shoppingCart").addDocument(from: product)
        } catch {
            print("Error saving to DB")
        }
    }
       // db.collection("tmp").addDocument(data: ["name" : "David"])
    }
    
    func listenToFirestore() {
        db.collection("items").addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else { return }
            
            if let err = err {
                print("Error getting document \(err)")
            } else {
                self.products.removeAll()
                for document in snapshot.documents {
                    let result = Result {
                        try document.data(as: Product.self)
                    }
                    switch result {
                    case .success(let ingredient) :
                        if let ingredient = ingredient {
                            //print("Item: \(item)")
                            self.products.append(ingredient)
                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding item: \(error)")
                    }
                }
            }
        }
    }
    
}
