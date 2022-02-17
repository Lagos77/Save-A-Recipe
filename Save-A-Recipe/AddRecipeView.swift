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
    @State var recipe = Recipe(name: "", ingredient: [], howToCook: [], image: "")
    @State var addIngredients = true
    var db = Firestore.firestore()
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @State var loginStatusMEssage = ""
    @State var imageRef = ""
    @State var isNamingRecipe = true
    @State var isAddingIngredients = false
    @State var readyForPublishing = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                if newRecipeName == "" {
                Text("Add a new recipe").font(.system(size: 30, weight: .bold))
                } else {
                    Text(newRecipeName).font(.system(size: 30, weight: .bold))
                }
                VStack{
                    Button {
                        shouldShowImagePicker.toggle()
                    } label: {

                    //    VStack {
                            if let image = self.image {
                                Image(uiImage: image)
                                    .resizable()
                                   // .frame(width: 128, height: 128)
                                  //  .cornerRadius(64)
                                    .scaledToFit()
                            } else {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 128))
                                    .padding()
                                    .foregroundColor(Color(.label))
                            }

                    }

                    if isNamingRecipe {

                    TextField("Name your recipe", text: $newRecipeName)
                        .multilineTextAlignment(TextAlignment.center)
                        .textFieldStyle(.roundedBorder)
                        .padding(12)

                        Spacer()
                        Spacer()
                    }
                    
                    else if isAddingIngredients {
                    VStack{
                        
                       // Spacer()
                    TextField("Ingredient", text: $newIngredient)
                        .multilineTextAlignment(TextAlignment.center)
                        .textFieldStyle(.roundedBorder)
                        .padding(12)
                        Button(action: {newRecipeIngredients.append(newIngredient); newIngredient = ""; print(newRecipeIngredients); print("recipe.ingredient: \(recipe.ingredient)"); print(recipe)},
                               label: {Image(systemName: "plus.app").font(.system(size: 20)); Text("Add ingredient")})
                        Spacer()
                         
                    }
                     
                    List(newRecipeIngredients, id: \.self) { recipe in
                        Text(recipe)
                    }.onAppear() {
                        UITableView.appearance().backgroundColor = UIColor.clear
                        UITableViewCell.appearance().backgroundColor = UIColor.clear
                    }
                    } else if readyForPublishing {
                    VStack{
                        
                      //  Spacer()
                        TextField("Step", text: $newHowToCookStep)
                            .multilineTextAlignment(TextAlignment.center)
                            .textFieldStyle(.roundedBorder)
                            .padding(12)
                        
                        Button(action: {newHowToCookSteps.append(newHowToCookStep); newHowToCookStep = ""},
                               label: {Image(systemName: "plus.app").font(.system(size: 20)); Text("Add step")})
                        Spacer()
                        
                         
                    }
                     
                        List(newHowToCookSteps, id: \.self) { step in
                            Text(step)
                        }.onAppear() {
                        UITableView.appearance().backgroundColor = UIColor.clear
                        UITableViewCell.appearance().backgroundColor = UIColor.clear
                    }
                    }
                }
                
            }.overlay(Button {
                if isNamingRecipe {
                    isNamingRecipe.toggle()
                    isAddingIngredients.toggle()
                
                
                } else if isAddingIngredients {
                    isAddingIngredients.toggle()
                    readyForPublishing.toggle()
                } else if readyForPublishing {
                    persistImageToStorageAndSaveRecipe(recipeName: newRecipeName, recipeIngredient: newRecipeIngredients, newHowToCook: newHowToCookSteps); presentationMode.wrappedValue.dismiss()
                }
            } label: {
                HStack {
                    Spacer()
//                    Text(isAddingIngredients ? "Steps" : "Add to list of recipes")
                    if isNamingRecipe{
                        Text("Add ingredients").font(.system(size: 15, weight: .bold))
                        Spacer()
                    } else if isAddingIngredients {
                        Text("Add steps").font(.system(size: 15, weight: .bold))
                        Spacer()
                    } else if readyForPublishing {
                        Text("Add to Cookbook").font(.system(size: 15, weight: .bold))
                        Spacer()
                    }
                        
                }
                .foregroundColor(.white)
                .padding(.vertical)
                .background(Color.blue)
                .cornerRadius(32)
                .padding(.horizontal)
            }, alignment: .bottom)
            //.navigationBarHidden(true)
            
            
        }.navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image)
            }
    }
    
    private func persistImageToStorageAndSaveRecipe(recipeName: String, recipeIngredient: [String], newHowToCook : [String]) {
        if let image = image {
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        guard let uid = Auth.auth().currentUser?.uid
        else { return }
        let ref = Storage.storage().reference(withPath: uid + newRecipeName)
        //  let ref = Storage.storage().reference().child("\(uid) + \(newRecipeName).jpeg")
        // guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        guard let imageData = (image).jpegData(compressionQuality: 1.0) else { return }
        ref.putData(imageData, metadata: metadata) { metadata, err in
            if let err = err {
                self.loginStatusMEssage = "Failed to push image to Storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMEssage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                self.loginStatusMEssage = "Successfully stored image with imageURL \(url?.absoluteString ?? "")"
                print(self.loginStatusMEssage)
                imageRef = url?.absoluteString ?? ""
                print("imageRef i persistImage = \(imageRef)")
                print("imageRef 1 i saveToFireStore = \(imageRef)")
                //                guard let uid = Auth.auth().currentUser?.uid
                //                else { return }
                
                let recipe = Recipe(name: recipeName, ingredient: recipeIngredient, howToCook: newHowToCook, image: imageRef )
                
                do {
                    _ = try db.collection("user").document(uid).collection("recipes").addDocument(from: recipe)
                } catch {
                    print("Error saving to DB")
                }
                print("imageRef 2 i saveToFireStore = \(imageRef)")
                //    persistImageToStorage()
                print("imageRef 3 i saveToFireStore = \(imageRef)")
                
                
            }
            
        }
        }
    }
}


/*
 if isAddingIngredients {
     
     .overlay(Button {
         isAddingIngredients.toggle()
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
     
     
    // Button(action: {isAddingIngredients.toggle()}, label: {Text("Add recipe steps")})
 } else {
     Button(action:{persistImageToStorageAndSaveRecipe(recipeName: newRecipeName, recipeIngredient: newRecipeIngredients, newHowToCook: newHowToCookSteps); presentationMode.wrappedValue.dismiss()},
            label: {
         Text("Add to list of recipes")
     })
 }
 */
