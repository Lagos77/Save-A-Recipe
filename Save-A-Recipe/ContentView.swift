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

struct ContentView: View {
    @EnvironmentObject var cookBook : CookBook
   // @Environment(\.presentationMode) var presentationMode
    
    @State var showInfo : Bool = false
    
    @State var shouldShowLogOutOptions = false
    @State var showAddRecipe = false
    
    
    var db = Firestore.firestore()
    var uid = Auth.auth().currentUser?.uid
    @ObservedObject private var viewModel = RecipeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
//                Text(uid ?? "No user")
                HStack(spacing: 16) {
//                    Button {
//                        //go to cart
//                    } label: {
//                        Image(systemName: "cart")
//                            .font(.system(size: 24, weight: .bold))
//                            .foregroundColor(Color(.label))
//                    }
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
                            print("handle sign out")
                            viewModel.handleSignOut()
                        }),
                        .cancel()
                    ])
                }
                .fullScreenCover(isPresented: $viewModel.isUserCurrentlyLoggedOut, onDismiss: nil) {
                    LoginView(didCompleteLoginProcess: {
                        self.viewModel.isUserCurrentlyLoggedOut = false
                        self.viewModel.fetchData()
                       // self.viewModel.fetchCurrentUser()
                    })
                }
                
                
                
                List {
                    ForEach(viewModel.recipes) { recipe in
                        NavigationLink(destination: RecipeView(recipe: recipe)) {
                            RowView(recipe: recipe)
                        }
                    }
                    .onDelete() { indexSet in
                            
                                        for index in indexSet {
                                            let recipe = viewModel.recipes[index]
                                            if let id = recipe.id {
                                                if let uid = uid {
                                               // db.collection("recipes").document(id).delete()
                                                db.collection("user").document(uid).collection("recipes").document(id).delete()
                                            }
                                            }
                                        }
                                    }
                }
                .navigationTitle("Recipes")
//                .onAppear() {
//                    self.viewModel.fetchData()
//
//                }
                
                
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
            
            //   .navigationTitle("CookBook")
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}






/* List(){
     ForEach(viewModel.recipes) { recipe in
         NavigationLink(destination: RecipeView(recipe: recipe)) {
             RowView(recipe: recipe)
         }
     }
     .onDelete() { indexSet in
             
                         for index in indexSet {
                             let recipe = viewModel.recipes[index]
                             if let id = recipe.id {
                                 if let uid = uid {
                                // db.collection("recipes").document(id).delete()
                                 db.collection("user").document(uid).collection("recipes").document(id).delete()
                             }
                             }
                         }
                     }
 }
 .navigationTitle("Recipes")
 .onAppear() {
     self.viewModel.fetchData()
 }
 
*/
