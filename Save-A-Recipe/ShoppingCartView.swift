//
//  ShoppingCartView.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import SwiftUI
import Firebase

struct ShoppingCartView: View {
    @State var products = [Product]()
    @State var newProduct = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Product",text: $newProduct ).padding()
                
                Button(action: {
                    if newProduct != "" {
                        saveToFirestore(productName: newProduct)
                        newProduct = ""
                    }
                }, label: {
                    Text("Add to cart")
                }).padding()
                    .onAppear() {
                        listenToFirestore()
                    }
            }
            List {
                ForEach(products) { product in
                    HStack {
                        Text(product.name)
                        Spacer()
                        Button(action: {
                            
                            if let id = product.id {
                                if let uid = FirebaseManager.shared.auth.currentUser?.uid {
                                    FirebaseManager.shared.firestore.collection("user").document(uid).collection("shoppingCart").document(id).updateData(["done" : !product.done ] )
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        FirebaseManager.shared.firestore.collection("user").document(uid).collection("shoppingCart").document(id).delete()
                                    }
                                }
                            }
                        }, label: {
                            Image(systemName: product.done ? "checkmark.square" : "square").font(.system(size: 25))
                        })
                    }
                }.onDelete() { indexSet in
                    for index in indexSet {
                        let product = products[index]
                        if let id = product.id {
                            if let uid = FirebaseManager.shared.auth.currentUser?.uid {
                                FirebaseManager.shared.firestore.collection("user").document(uid).collection("shoppingCart").document(id).delete()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func saveToFirestore(productName: String) {
        let product = Product(name: productName)
        
        if let uid = FirebaseManager.shared.auth.currentUser?.uid {
            do {
                _ = try FirebaseManager.shared.firestore.collection("user").document(uid).collection("shoppingCart").addDocument(from: product)
            } catch {
                print("Error saving to DB")
            }
        }
    }
    
    func listenToFirestore() {
        if let uid = FirebaseManager.shared.auth.currentUser?.uid {
            FirebaseManager.shared.firestore.collection("user").document(uid).collection("shoppingCart").addSnapshotListener { snapshot, err in
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
