//
//  FirebaseManager.swift
//  Save-A-Recipe
//
//  Created by Alexander on 2022-06-08.
//

import Foundation
import FirebaseFirestore
import Firebase
import SwiftUI

class FirebaseManager: ObservableObject{
    @Published var isUserCurrentlyLoggedOut = false
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? Auth.auth().signOut()
    }
}
