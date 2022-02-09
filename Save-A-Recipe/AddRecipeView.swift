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

    var body: some View {
     //   Text("Här kan man lägga till nya recept")
        VStack{
            TextField("Name", text: $newRecipeName)

            TextField("Add ingredient", text: $newIngredient)
            Button(action: {newRecipeIngredients.append(newIngredient); print(newRecipeIngredients)}, label: {Text("add ingredient")})
            
            TextField("Add step", text: $newHowToCookStep)
            Button(action: {newHowToCookSteps.append(newHowToCookStep); print(newHowToCookSteps)}, label: {Text("add step")})

            Button(action: {addIngredientToRecipe()}, label: {
                Text("Add")
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


