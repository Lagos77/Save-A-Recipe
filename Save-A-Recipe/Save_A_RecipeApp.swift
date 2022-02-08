//
//  Save_A_RecipeApp.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import SwiftUI
import Firebase


@main
struct Save_A_RecipeApp: App {
    @StateObject var cookBook = CookBook()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cookBook)
        }
    }
}
