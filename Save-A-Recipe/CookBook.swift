//
//  CookBook.swift
//  Save-A-Recipe
//
//  Created by Henrik Sjögren on 2022-02-08.
//

import Foundation
import SwiftUI

class CookBook : ObservableObject {
    @Published var recipes = [Recipe]()

}
