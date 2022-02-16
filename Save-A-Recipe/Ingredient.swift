//
//  Ingredient.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-15.
//

import Foundation
import FirebaseFirestoreSwift


struct Ingredient : Codable , Identifiable{
    @DocumentID var id : String?
    var name : String
    var done : Bool = false
}
