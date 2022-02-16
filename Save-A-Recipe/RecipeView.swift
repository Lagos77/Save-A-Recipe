//
//  RecipeView.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct RecipeView : View {
    @EnvironmentObject var cookBook : CookBook
    var recipe : Recipe? = nil
    @Environment(\.presentationMode) var presentationMode
    
    @State  var howTo = false
    @State var recipeIngredients = [String]()
    @State var product : Product?
    @State var products = [Product]()
    var db = Firestore.firestore()
    @State var uid = Auth.auth().currentUser?.uid
    
    var body: some View {
        
        Button {
            addRecipeToCart()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color(.label))
        }
        
        VStack {
            if let recipe = recipe {
                Text(recipe.name)
                    .font(.system(size: 40))
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
        }
    }
    
    func addRecipeToCart() {
        if let recipe = recipe {
            recipeIngredients.append(contentsOf: recipe.ingredient)
        }
        print(recipeIngredients)
        
        for ingredient in recipeIngredients {
            if let uid = uid {
            let product = Product(name: ingredient)
            do {
              //  _ = try db.collection("recipes").addDocument(from: recipe)
                _ = try db.collection("user").document(uid).collection("shoppingCart").addDocument(from: product)
            } catch {
                print("Error saving to DB")
            }
        }
        }
        
        
    }
}
    
    
    
    
    /*
     HStack{
     Button(action: {
     howTo = false
     
     }, label: {Text("Ingredienser")
     })  .padding(4)
     .background(howTo ? Color.white : Color(red: 238 / 255, green: 232 / 255, blue: 234 / 255))
     
     Button(action: {
     howTo = true
     }, label: {Text("Tillagning")
     })
     .padding(4)
     .background(howTo ? Color(red: 238 / 255, green: 232 / 255, blue: 234 / 255): Color.white)
     }
     }
     if !howTo {
     
     ScrollView{
     if let recipe = recipe {
     ForEach(0..<recipe.ingredient.count) { each in
     Text(recipe.ingredient[each])
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
     */

