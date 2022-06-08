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


class RecipeDataManger: ObservableObject {
    @Published var recipes = [Recipe]()
    @Published var errorMessage = ""
    @Published var isUserCurrentlyLoggedOut = false
    
    init() {
        
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = Auth.auth().currentUser?.uid == nil
            
        }
        postRecipe()
    }
    
    
    private var db = Firestore.firestore()
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? Auth.auth().signOut()
    }
    
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func postRecipe() {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("user").document(uid).collection("recipes").addSnapshotListener { snapshot, err in
                
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


