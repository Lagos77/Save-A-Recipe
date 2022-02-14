//
//  RecipeViewModel.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import Firebase



class RecipeViewModel: ObservableObject {
    @Published var recipes = [Recipe]()
    
    private var db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    
    func logout() {
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
    }
    
    func fetchData() {
        if let uid = uid {
        db.collection("user").document(uid).collection("recipes").addSnapshotListener { snapshot, err in
         //   db.collection("recipes").addSnapshotListener { snapshot, err in
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
}

