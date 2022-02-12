//
//  RecipeView.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeView : View {
    @EnvironmentObject var cookBook : CookBook
    var recipe : Recipe? = nil
    @Environment(\.presentationMode) var presentationMode
    
    @State  var howTo = false
    
    var body: some View {
        
        VStack {
            if let recipe = recipe {
                Text(recipe.name)
                    .font(.system(size: 40))
                WebImage(url: URL(string: recipe.image))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
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
            
            List{
                if let recipe = recipe {
                    ForEach(0..<recipe.ingredient.count) { each in
                        Text(recipe.ingredient[each])
                    }
                }
            }
        } else {
            if let recipe = recipe {
                List{
                    if let recipe = recipe {
                        ForEach(0..<recipe.howToCook.count) { each in
                            Text(recipe.howToCook[each])
                        }
                    }
                }
            }
        }
    }
}
