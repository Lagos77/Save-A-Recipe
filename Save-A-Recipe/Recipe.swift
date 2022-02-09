//
//  Recipe.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import Foundation
import SwiftUI

struct Recipe : Identifiable, Equatable {
    var id = UUID()
    var name : String
    var ingredient : [String]
    var howToCook : [String]
    var image : String
    }

