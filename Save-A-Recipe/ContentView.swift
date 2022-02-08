//
//  ContentView.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var cookBook : CookBook
    
    @State var showInfo : Bool = false
    
    
    var db = Firestore.firestore()
    @ObservedObject private var viewModel = RecipeViewModel()
    
    var body: some View {
        NavigationView{
            VStack {
                List(){
                    ForEach(viewModel.recipes) { recipe in
                        NavigationLink(destination: RecipeView(recipe: recipe)) {
                            RowView(recipe: recipe)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        cookBook.recipes.remove(atOffsets: indexSet)
                    })
                }
                .navigationTitle("Recipes")
                .onAppear() {
                    self.viewModel.fetchData()
                }
                .navigationBarItems(leading: NavigationLink(destination: RecipeView()){
                    Image(systemName: "plus")
                })
                .navigationBarItems(trailing: NavigationLink(destination: ShoppingCartView()){
                    Image(systemName: "cart")
                })
            }
        }.navigationViewStyle(.stack)
    }
}

struct RowView : View {
    var recipe : Recipe
    
    
    var body: some View {
        
        ZStack(alignment: .top){
            
            recipe.image
                .resizable()
                .aspectRatio(contentMode: .fit)
            //.frame(maxWidth: 40)
            Text(recipe.name)
                .font(.largeTitle)
                .background(Color.black)
                .opacity(0.6)
                .cornerRadius(4)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

