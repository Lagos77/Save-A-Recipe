//
//  LoginView.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-12.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @State var loginStatusMEssage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                                          Text("Login")
                                              .tag(true)
                                          Text("Create Account")
                                              .tag(false)
                                      }.pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode {
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
                    }
                    
                    
                    
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(12)
                        .background(Color.white)
                    
                    SecureField("Password", text: $password)
                        .padding(12)
                        .background(Color.white)
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight:.semibold))
                            Spacer()
                        }.background(Color.blue)
                    }
                    Text(self.loginStatusMEssage)
                        .foregroundColor(.red)
                }
                .padding()
                
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea())
        }.navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image)
            }
    }
    
   // @State var image: UIImage?
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to login user", err)
                self.loginStatusMEssage = "Failed to login user \(err)"
                return
            }
            
            print("Successfully logged in as user \(result?.user.uid ?? "")")
            self.loginStatusMEssage = "Successfully logged in as user \(result?.user.uid ?? "")"
        }
    }
    
    
   // @State var loginStatusMEssage = ""
    
    private func createNewAccount() {
        Auth.auth().createUser(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to create user", err)
                self.loginStatusMEssage = "Failed to create user \(err)"
                return
            }
            
            print("Successfully created user \(result?.user.uid ?? "")")
            self.loginStatusMEssage = "Successfully created user \(result?.user.uid ?? "")"
            
            self.persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
    //    let fileName = UUID().uuidString
        guard let uid = Auth.auth().currentUser?.uid
        else { return }
//       let ref = Storage.storage().reference(withPath: uid)
        let ref = Storage.storage().reference().child(uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
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
            }
            
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
