//
//  AddRecipeView.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import SwiftUI
//import Foundation
import Firebase

struct AddRecipeView: View {
    
    @State var newIngredient: String = ""
    @State var newRecipeIngredients : [String] = []
    @State var newRecipeName: String = ""
    @State var newHowToCookStep: String = ""
    @State var newHowToCookSteps: [String]
    @State var recipe : Recipe?
    //    @State var recipeIngredients = [String]()
    //    @State var product : Product?
    //    @State var products = [Product]()
    var db = Firestore.firestore()
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @State var loginStatusMEssage = ""
    @State var imageRef = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                
                
                VStack(alignment: .center){
                    Button {
                        shouldShowImagePicker.toggle()
                    } label: {
                        
                        VStack {
                            if let image = self.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 128, height: 128)
                                    .cornerRadius(64)
                                    .scaledToFill()
                            } else {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 64))
                                    .padding()
                                    .foregroundColor(Color(.label))
                            }
                        }
                        .overlay(RoundedRectangle(cornerRadius: 64)
                                    .stroke(Color.black, lineWidth: 3))
                    }
                    
                    
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
                    
                    Button(action:{persistImageToStorageAndSaveRecipe(recipeName: newRecipeName, recipeIngredient: newRecipeIngredients, newHowToCook: newHowToCookSteps); presentationMode.wrappedValue.dismiss()
                            
                        }
                    
                           , label: {
                        Text("Add to list of recipes")
                    })
                    //}
                }
                
            }
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
                    //  _ = try db.collection("recipes").addDocument(from: recipe)
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
    
    func addRecipeToFB(){
        
    }
    
    
    
    //    func saveToFirestore(recipeName: String, recipeIngredient: [String], newHowToCook : [String]) {
    //        print("imageRef 1 i saveToFireStore = \(imageRef)")
    //        guard let uid = Auth.auth().currentUser?.uid
    //        else { return }
    //        let recipe = Recipe(name: recipeName, ingredient: recipeIngredient, howToCook: newHowToCook, image: imageRef )
    //
    //        do {
    //            _ = try db.collection("recipes").addDocument(from: recipe)
    //        } catch {
    //            print("Error saving to DB")
    //        }
    //        print("imageRef 2 i saveToFireStore = \(imageRef)")
    //    //    persistImageToStorage()
    //        print("imageRef 3 i saveToFireStore = \(imageRef)")
    //    }
    
}

//struct AddRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddRecipeView()
//    }
//}



/*
 rules_version = '2';
 service firebase.storage {
 match /b/{bucket}/o {
 match /{allPaths=**} {
 allow read, write: if true;
 }
 }
 }*/
