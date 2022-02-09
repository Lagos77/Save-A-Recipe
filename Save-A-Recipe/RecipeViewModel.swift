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
        db.collection("recipes").addSnapshotListener { (querySnapshot ,error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            self.recipes = documents.map {(queryDocumentSnapshot) -> Recipe in
          let data = queryDocumentSnapshot.data()
                
                let name = data["name"] as? String ?? ""
                let ingredient = data["ingredient"] as? Array ?? [""]
                let howToCook = data["howToCook"] as? Array ?? [""]
                let image = data["image"] as? String ?? "Varför är du tom?"
                
                
                //return Recipe(name: name, ingredient: ingredient, howToCook: howToCook, image: Image(image))
                return Recipe(name: name, ingredient: ingredient, howToCook: howToCook, image: image)
    }
    }
}
}

