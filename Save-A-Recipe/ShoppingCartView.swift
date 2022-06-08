//
//  ShoppingCartView.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import SwiftUI
import Firebase

struct ShoppingCartView: View {
    /*
     When clicking shopping icon, this view opens.
     It works like a "to-do" list.
     */
    @State var productList = [Product]()
    @State var newProduct = ""
    
    var body: some View {
        VStack {
            addingProduct
            
            List {
                ForEach(productList) { product in
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
                        let product = productList[index]
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
    
    var addingProduct: some View{
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
                    productList.removeAll()
                    for document in snapshot.documents {
                        let result = Result {
                            try document.data(as: Product.self)
                        }
                        switch result {
                        case .success(let ingredient) :
                            if let ingredient = ingredient {
                               
                                productList.append(ingredient)
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
