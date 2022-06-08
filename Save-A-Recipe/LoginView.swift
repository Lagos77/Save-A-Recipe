//
//  LoginView.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-12.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    /*
     First view when user is starting the app.
     Displays two text fields and two tabs for login process and create account
     */
    
    //Takes to another view
    let didCompleteLoginProcess: () -> ()
    
    @State var isLoggedIn = true
    @State var shouldShowImagePicker = false
    
    @State var image: UIImage?
    
    @State var email = ""
    @State var password = ""
    @State var loginStatusMEssage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Picker(selection: $isLoggedIn, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Cookbook")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
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
                            Text(isLoggedIn ? "Log In" : "Create Account")
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
            .navigationTitle(isLoggedIn ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
        }.navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image)
            }
        
        
    }
    
    private func handleAction() {
        if isLoggedIn {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) {
            result, err in
            if let err = err {
                self.loginStatusMEssage = "Failed to login user"
                return
            }
            self.didCompleteLoginProcess()
        }
    }
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) {
            result, err in
            if let err = err {
                self.loginStatusMEssage = "Failed to create user"
                return
            }
            self.didCompleteLoginProcess()
        }
    }
}
