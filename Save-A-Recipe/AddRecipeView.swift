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
    
    /*
    This view is showed when current user is about to create a new recipe.
     The view goes under a certain order:
     1. User selectes an image from the device & adds a title for the recipe
     2. Then the user adds all the necessary ingredients by texting them
     3. Finally the user add text in which order the recipe should be followed
     */
    
    @State var newIngredient: String = ""
    @State var listIngredients : [String] = []
    @State var newRecipeName: String = ""
    @State var newHowToCookStep: String = ""
    @State var newHowToCookSteps: [String]
    @State var recipe = Recipe(name: "", ingredient: [], howToCook: [], image: "")
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
                        if let image = self.image {
                            Image(uiImage: image)
                                .resizable()
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
                    } else if isAddingIngredients {
                        
                        addingIngredient
                        
                        List(listIngredients, id: \.self) { recipe in
                            Text(recipe)
                        }.onAppear() {
                            UITableView.appearance().backgroundColor = UIColor.clear
                            UITableViewCell.appearance().backgroundColor = UIColor.clear
                        }
                    } else if readyForPublishing {
                        
                        addingPreparations
                        
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
                    ImageStorage(recipeName: newRecipeName, recipeIngredient: listIngredients, newHowToCook: newHowToCookSteps); presentationMode.wrappedValue.dismiss()
                }
            } label: {
                HStack {
                    Spacer()
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
        }.navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image)
            }
    }
    
    var addingIngredient: some View {
        VStack{
            TextField("Ingredient", text: $newIngredient)
                .multilineTextAlignment(TextAlignment.center)
                .textFieldStyle(.roundedBorder)
                .padding(12)
            Button(action: {listIngredients.append(newIngredient); newIngredient = ""},
                   label: {Image(systemName: "plus.app").font(.system(size: 20)); Text("Add ingredient")})
        }
    }
    
    var addingPreparations: some View{
        VStack{
            TextField("Step", text: $newHowToCookStep)
                .multilineTextAlignment(TextAlignment.center)
                .textFieldStyle(.roundedBorder)
                .padding(12)
            
            Button(action: {newHowToCookSteps.append(newHowToCookStep); newHowToCookStep = ""},
                   label: {Image(systemName: "plus.app").font(.system(size: 20)); Text("Add step")}
            )}
    }
    
    private func ImageStorage(recipeName: String, recipeIngredient: [String], newHowToCook : [String]) {
        if let image = image {
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid
            else { return }
            let ref = FirebaseManager.shared.storage.reference(withPath: uid + newRecipeName)
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
                    
                    let recipe = Recipe(name: recipeName, ingredient: recipeIngredient, howToCook: newHowToCook, image: imageRef )
                    do {
                        _ = try FirebaseManager.shared.firestore.collection("user").document(uid).collection("recipes").addDocument(from: recipe)
                    } catch {
                        print("Error saving to DB")
                    }
                    print("imageRef 2 i saveToFireStore = \(imageRef)")
                    print("imageRef 3 i saveToFireStore = \(imageRef)")
                }
            }
        }
    }
}


