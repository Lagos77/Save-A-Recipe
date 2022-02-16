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
        @State var products = [Product]()
        @State var newProduct = ""
        let uid = Auth.auth().currentUser?.uid
        
        var body: some View {
            VStack {
                List {
                    ForEach(products) { product in
                        HStack {
                            Text(product.name)
                            Spacer()
                            Button(action: {
                                
                                if let id = product.id {
                                    if let uid = uid {
                                    db.collection("user").document(uid).collection("shoppingCart").document(id).updateData(["done" : !product.done ] ) //------------------------ ändras
                                    }
                                }
                                    
                            }, label: {
                                Image(systemName: product.done ? "checkmark.square" : "square")
                            })
                        }
                    }.onDelete() { indexSet in
            
                        for index in indexSet {
                            let product = products[index]
                            if let id = product.id {
                                if let uid = uid {
                                db.collection("user").document(uid).collection("shoppingCart").document(id).delete() //------------------------ ändras
                                }
                            }
                        }
                    }
                }
                HStack {
                    TextField("Product",text: $newProduct ).padding()
                    Spacer()
                    Button(action: {
                        saveToFirestore(productName: newProduct)
                        newProduct = ""
                    }, label: {
                        Text("Save")
                    }).padding()
                    .onAppear() {
                        listenToFirestore()
                    }
                }
            }
        }
        
        func saveToFirestore(productName: String) {
            let product = Product(name: productName)
            if let uid = uid {
            do {
                _ = try db.collection("user").document(uid).collection("shoppingCart").addDocument(from: product) //------------------------ ändras
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
                    products.removeAll()
                    for document in snapshot.documents {
                        let result = Result {
                            try document.data(as: Product.self)
                        }
                        switch result {
                        case .success(let ingredient) :
                            if let ingredient = ingredient {
                                //print("Item: \(item)")
                                products.append(ingredient)
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
