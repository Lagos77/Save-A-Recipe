//
//  ContentView.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import SwiftUI
import Firebase
import SDWebImage
import SDWebImageSwiftUI

struct UserLogged: View {
    @ObservedObject private var recipeDataManger = RecipeDataManger()

    @State var shouldShowLogOutOptions = false
    @State var showAddRecipe = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack(spacing: 16) {
                    NavigationLink(destination: ShoppingCartView()) {
                        Image(systemName: "cart")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(.label))
                    }
                    
                    Spacer()
                    Text("Recipes")
                        .font(.system(size: 34, weight: .heavy))
                    Spacer()
                    Button {
                        shouldShowLogOutOptions.toggle()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(.label))
                    }
                }
                
                
                .padding()
                .actionSheet(isPresented: $shouldShowLogOutOptions) {
                    .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                        .destructive(Text("Sign Out"), action: {
                            recipeDataManger.handleSignOut()
                        }),
                        .cancel()
                    ])
                }
                .fullScreenCover(isPresented: $recipeDataManger.isUserCurrentlyLoggedOut, onDismiss: nil) {
                    LoginView(didCompleteLoginProcess: {
                        self.recipeDataManger.isUserCurrentlyLoggedOut = false
                        self.recipeDataManger.postRecipe()
                    })
                }
                
                List {
                    ForEach(recipeDataManger.recipes) { recipe in
                        NavigationLink(destination: RecipeView(recipe: recipe)) {
                            RowView(recipe: recipe)
                        }
                    }
                    .onDelete() { indexSet in
                        
                        for index in indexSet {
                            let recipe = recipeDataManger.recipes[index]
                            if let id = recipe.id {
                                if let uid = FirebaseManager.shared.auth.currentUser?.uid {
                                    FirebaseManager.shared.firestore.collection("user").document(uid).collection("recipes").document(id).delete()
                                }
                            }
                        }
                    }
                }
                .onAppear() {
                    UITableView.appearance().backgroundColor = UIColor.clear
                    UITableViewCell.appearance().backgroundColor = UIColor.clear
                }
                .navigationTitle("Recipes")
            }
            .overlay(Button {
                showAddRecipe.toggle()
            } label: {
                HStack {
                    Spacer()
                    Text("Add new recipe")
                        .font(.system(size: 15, weight: .bold))
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.vertical)
                .background(Color.blue)
                .cornerRadius(32)
                .padding(.horizontal)
            }, alignment: .bottom)
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $showAddRecipe, onDismiss: nil) {
            AddRecipeView(newHowToCookSteps: [])}
    }
}

struct RowView : View {
    var recipe : Recipe
    
    var body: some View {
        
        ZStack(alignment: .top){
            WebImage(url: URL(string: recipe.image))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
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









