//
//  RecipeView.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import ToastUI

struct RecipeView : View {
    /*
     When the user selects a specific recipe, this view opens and shows all the text that the user has entered for the specific recipe.
     */

    var recipe : Recipe? = nil
    @Environment(\.presentationMode) var presentationMode
    @State  var howTo = false
    @State var recipeIngredients = [String]()
    @State var product : Product?
    @State var products = [Product]()
    @State private var presentingToast: Bool = false
    
    var body: some View {
        
        VStack {
            if let recipe = recipe {
                Text(recipe.name)
                    .font(.system(size: 34, weight: .heavy))
                WebImage(url: URL(string: recipe.image))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            Picker(selection: $howTo, label: Text("Picker here")) {
                Text("Ingredients")
                    .tag(false)
                Text("How to cook")
                    .tag(true)
            }.pickerStyle(SegmentedPickerStyle())
            
            if !howTo {
                ScrollView{
                    if let recipe = recipe {
                        ForEach(0..<recipe.ingredient.count) { each in
                            VStack {
                                Text(recipe.ingredient[each])
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            } else {
                if let recipe = recipe {
                    ScrollView{
                        if let recipe = recipe {
                            ForEach(0..<recipe.howToCook.count) { each in
                                Text(recipe.howToCook[each])
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                            }
                        }
                    }
                }
            }
        }.navigationBarItems(trailing: Button {
            presentingToast = true
            addRecipeToCart()
        } label: {
            Image(systemName: "cart.badge.plus")
        }.toast(isPresented: $presentingToast, dismissAfter: 1.0, onDismiss: nil ) {
            ToastView("Ingredients added to shopping cart!")
                .toastViewStyle(SuccessToastViewStyle())
        })
    }
    
    func addRecipeToCart() {
        if let recipe = recipe {
            recipeIngredients.append(contentsOf: recipe.ingredient)
        }
        print(recipeIngredients)
        
        for ingredient in recipeIngredients {
            if let uid = FirebaseManager.shared.auth.currentUser?.uid {
                let product = Product(name: ingredient)
                do {
                    _ = try FirebaseManager.shared.firestore.collection("user").document(uid).collection("shoppingCart").addDocument(from: product)
                } catch {
                    print("Error saving to DB")
                }
            }
        }
    }
}


