//
//  ShoppingCartView.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import SwiftUI
import Firebase

struct ShoppingCartView: View {
    
    
        var db = Firestore.firestore()
        @State var ingredients = [Ingredient]()
        @State var newIngredient = ""
        let uid = Auth.auth().currentUser?.uid
        
        var body: some View {
            VStack {
                List {
                    ForEach(ingredients) { ingredient in
                        HStack {
                            Text(ingredient.name)
                            Spacer()
                            Button(action: {
                                
                                if let id = ingredient.id {
                                    if let uid = uid {
                                    db.collection("user").document(uid).collection("shoppingCart").document(id).updateData(["done" : !ingredient.done ] ) //------------------------ ändras
                                    }
                                }
                                    
                            }, label: {
                                Image(systemName: ingredient.done ? "checkmark.square" : "square")
                            })
                        }
                    }.onDelete() { indexSet in
            
                        for index in indexSet {
                            let ingredient = ingredients[index]
                            if let id = ingredient.id {
                                if let uid = uid {
                                db.collection("user").document(uid).collection("shoppingCart").document(id).delete() //------------------------ ändras
                                }
                            }
                        }
                    }
                }
                HStack {
                    TextField("Ingredient",text: $newIngredient ).padding()
                    Spacer()
                    Button(action: {
                        saveToFirestore(ingredientName: newIngredient)
                        newIngredient = ""
                    }, label: {
                        Text("Save")
                    }).padding()
                    .onAppear() {
                        listenToFirestore()
                    }
                }
            }
        }
        
        func saveToFirestore(ingredientName: String) {
            let ingredient = Ingredient(name: ingredientName)
            if let uid = uid {
            do {
                _ = try db.collection("user").document(uid).collection("shoppingCart").addDocument(from: ingredient) //------------------------ ändras
            } catch {
                print("Error saving to DB")
            }
           
            /*
             db.collection("user").document(uid).collection("recipes")
             */
            }
        }
        
        func listenToFirestore() {
            if let uid = uid {
            db.collection("user").document(uid).collection("shoppingCart").addSnapshotListener { snapshot, err in //------------------------ ändras
                guard let snapshot = snapshot else { return }
                
                if let err = err {
                    print("Error getting document \(err)")
                } else {
                    ingredients.removeAll()
                    for document in snapshot.documents {
                        let result = Result {
                            try document.data(as: Ingredient.self)
                        }
                        switch result {
                        case .success(let ingredient) :
                            if let ingredient = ingredient {
                                //print("Item: \(item)")
                                ingredients.append(ingredient)
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


struct ShoppingCartView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingCartView()
    }
}
