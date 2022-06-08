//
//  Recipe.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct Recipe : Identifiable, Equatable, Codable {
    @DocumentID var id : String?
    var name : String
    var ingredient : [String]
    var howToCook : [String]
    var image : String 
}

