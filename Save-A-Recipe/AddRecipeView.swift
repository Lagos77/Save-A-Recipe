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
            
            Button(action: {addIngredientToRecipe(); presentationMode.wrappedValue.dismiss()}, label: {
                Text("Add to list of recipes")
            })
        }
    }
    
    func addIngredientToRecipe() {
        //        newRecipeIngredients.append(newIngredient)
        //        newHowToCookSteps.append(newHowToCookStep)
        print(newRecipeIngredients)
        db.collection("recipes").addDocument(data: ["name" : newRecipeName, "ingredient" : newRecipeIngredients, "howToCook" : newHowToCookSteps])
        //db.collection("recipes").addDocument(data: ["ingredient" : newRecipeIngredients])
    }
    
    func addRecipeToFB(){
        
    }
    
}

//struct AddRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddRecipeView()
//    }
//}


