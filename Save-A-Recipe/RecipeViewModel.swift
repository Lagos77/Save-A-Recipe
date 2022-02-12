//
//  RecipeViewModel.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import Foundation
import FirebaseFirestore
import SwiftUI



class RecipeViewModel: ObservableObject {
    @Published var recipes = [Recipe]()
    
    private var db = Firestore.firestore()
    

    
    func fetchData() {
            db.collection("recipes").addSnapshotListener { snapshot, err in
                guard let snapshot = snapshot else { return }
                
                if let err = err {
                    print("Error getting document \(err)")
                } else {
                    self.recipes.removeAll()
                    for document in snapshot.documents {
                        let result = Result {
                            try document.data(as: Recipe.self)
                        }
                        switch result {
                        case .success(let recipe) :
                            if let recipe = recipe {
                                //print("Item: \(item)")
                                self.recipes.append(recipe)
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

