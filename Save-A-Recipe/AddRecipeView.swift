//
//  AddRecipeView.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import SwiftUI
import Foundation
import Firebase

struct AddRecipeView: View {
    
    @State var newIngredient: String = ""
    @State var newRecipeIngredients : [String] = []
    @State var newRecipeName: String = ""
    @State var newHowToCookStep: String = ""
    @State var newHowToCookSteps: [String]
    @State var recipe : Recipe?
    var db = Firestore.firestore()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack(alignment: .center){
            Text("Add a recipe:")//.frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            Spacer()
            TextField("Name your recipe", text: $newRecipeName)
                .multilineTextAlignment(TextAlignment.center)
                .textFieldStyle(.roundedBorder)
            Spacer()
            VStack(alignment: .center){
                
                HStack(alignment: .center){
                    Spacer()
                    TextField("Add ingredient", text: $newIngredient)
                        .multilineTextAlignment(TextAlignment.center)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(action: {newRecipeIngredients.append(newIngredient); newIngredient = ""}, label: {Image(systemName: "text.badge.plus")})
                    TextField("Add step", text: $newHowToCookStep)
                        .multilineTextAlignment(TextAlignment.center)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(action: {newHowToCookSteps.append(newHowToCookStep); newHowToCookStep = ""}, label: {Image(systemName: "text.badge.plus")})
                    Spacer()
                }
            }
            HStack{
                List(newRecipeIngredients, id: \.self) { recipe in
                    Text(recipe)
                }.onAppear() {
                    UITableView.appearance().backgroundColor = UIColor.clear
                    UITableViewCell.appearance().backgroundColor = UIColor.clear
                }
                List(newHowToCookSteps, id: \.self) { step in
                    Text(step)
                }
            }
            
            Button(action: {saveToFirestore(recipeName: newRecipeName, recipeIngredient: newRecipeIngredients, newHowToCook: newHowToCookSteps); presentationMode.wrappedValue.dismiss()
                
            }
                   , label: {
                Text("Add to list of recipes")
            })
        }
    }
    

    
    func addRecipeToFB(){
        
    }
    
    func saveToFirestore(recipeName: String, recipeIngredient: [String], newHowToCook : [String]) {
        let recipe = Recipe(name: recipeName, ingredient: recipeIngredient, howToCook: newHowToCook, image: "https://firebasestorage.googleapis.com/v0/b/save-a-recipe2.appspot.com/o/new.jpeg?alt=media&token=af1a3dc8-6959-4d35-bd20-d4946229ebd6")
        
        do {
                   _ = try db.collection("recipes").addDocument(from: recipe)
               } catch {
                   print("Error saving to DB")
               }
    }
    
}

//struct AddRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddRecipeView()
//    }
//}


