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
    
    init() {
        addMockData()
    }
    
    func addMockData() {
        

//        recipes.append(Recipe(name: "Lasagne", ingredient: ["300g blansfärsfärs", "1 gul lök", "2 vitlöksklyftor", "1 morot", "selleri", "1/2 röd chilli", "2 msk tomatpuré", "400-500 g hela tomater på burk", "1 dl vitt vin", "1 köttbuljongtärning", "torkad timjan och oregano,", "lagerblad", "soja", "8 dl mjölk", "50g smör", "4 msk vetemjöl,", "2 dl mozzarella", "2 dl parmesan", "10-12 lasagneplattor"], howToCook: ["Sätt ugnen på 175°C.", "Skala och hacka lök och vitlök. Fräs färs, lök och vitlök i oljan i en stekpanna. Tillsätt tomatpuré som får fräsa med i färsen. Krydda med timjan och rosmarin. Tillsätt krossade tomater och buljongtärning låt det koka ca 10 minuter. Smaka av med salt och peppar.", "Sås: Smält matfettet och rör ner mjölet. Späd med mjölken under vispning. Låt såsen koka ca 5 minuter. Smaka av med salt och peppar.", "Varva sås, lasagneplattor och köttfärssåsen i en ugnssäker form. Avsluta med sås och parmesanost.", "Sätt in lasagnen mitt i ugnen ca 40 minuter.", "Till servering: Servera lasagnen med sallad."], image: Image("lasagne")))
//        recipes.append(Recipe(name: "Fish Tacos", ingredient: ["Fish", "Taco", "Coriander"], howToCook: ["sdfgxb", "sgsrgsrg", "dfgoö", "sdgsd"], image: Image("fishtacos")))
//        recipes.append(Recipe(name: "Meatballs", ingredient: ["Ground Beef","Eggs", "Mashed Potatoes"], howToCook: ["sdfgxb", "sgsrgsrg", "dfgoö", "sdgsd"], image: Image("kottbullar")))
//        recipes.append(Recipe(name: "Grilled Cheese Sandwich", ingredient: ["Cheese", "Sourdough Bread", "Butter"], howToCook: ["sdfgxb", "sgsrgsrg", "dfgoö", "sdgsd"], image: Image("grilledcheese")))
//        recipes.append(Recipe(name: "Sausage", ingredient: ["Sausages", "Bread Roll", "Mustard & Ketchup"], howToCook: ["sdfgxb", "sgsrgsrg", "dfgoö", "sdgsd"], image: Image("korv")))
//        recipes.append(Recipe(name: "Sausage", ingredient: ["Sausages", "Bread Roll", "Mustard & Ketchup"], howToCook: ["sdfgxb", "sgsrgsrg", "dfgoö", "sdgsd"], image: Image("korv")))
//        recipes.append(Recipe(name: "Nytt Recept", ingredient: ["", "", ""], howToCook: ["", ""], image: Image("new")))
        
    }
}
