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
    @Published var ingredients = [Ingredient]()
    @Published var newIngredient = ""
    
    
    func saveToFirestore(ingredientName: String) {
        let ingredient = Ingredient(name: ingredientName)
        
        do {
            _ = try db.collection("items").addDocument(from: ingredient)
        } catch {
            print("Error saving to DB")
        }
       // db.collection("tmp").addDocument(data: ["name" : "David"])
    }
    
    func listenToFirestore() {
        db.collection("items").addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else { return }
            
            if let err = err {
                print("Error getting document \(err)")
            } else {
                self.ingredients.removeAll()
                for document in snapshot.documents {
                    let result = Result {
                        try document.data(as: Ingredient.self)
                    }
                    switch result {
                    case .success(let ingredient) :
                        if let ingredient = ingredient {
                            //print("Item: \(item)")
                            self.ingredients.append(ingredient)
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
