//
//  FoodCategories.swift
//  Keep
//
//  Created by Luna An on 1/19/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import Foundation

enum FoodCategories : String {
    
    // MARK: vegetables
    case vegetables = "Vegetables"
    
    // MARK: Fruits
    case fruits = "Fruits"
    
    // MARK: Grain
    case pastasAndNoodles = "Pastas and Noodles"
    case otherGrains = "Other Grains"
    
    // MARK: Dairy
    case dairy = "Dairy"
    
    // MARK: Protein
    case meatsSeafoodsAndEggs = "Meats, Seafoods, and Eggs"
    case beansPeasAndTofu = "Beans, Peas and Tofu"
    case nutsAndSeeds = "Nuts and Seeds"

    // MARK: Other
    case beverages = "Beverages"
    case alcoholicBeverages = "Alcoholic Beverages"
    case condimentsAndSauce = "Condiments and Sauce"
    case healthAndPersonalCare = "Health and Personal Care"
    case householdAndCleaning = "Household and Cleaning"
    case other = "Other"
}

var grains: [String:[String]] = [
    "Pastas And Noodles" : pastaAndNoodles,
    "Other Grains" : otherGrains,
]

var vegetable: [String:[String]] = [
    "Vegetables": vegetables
]

var fruit: [String:[String]] = [
    "Fruits": fruits
]

var proteins: [String:[String]] = [
    "Meats, Seafoods And Eggs": meatsSeafoodsAndEggs,
    "Beans, Pease And Tofu": beansPeaseAndTofu,
    "Nuts And Seeds" : nutsAndSeeds
]

var dairies: [String:[String]] = [
    "Dairy": dairy
]

var other: [String:[String]] = [
    "Beverages" : beverages,
    "Alcoholic Beverages" : alcoholicBeverages,
    "Condiments and Sauce" : condimentsAndSauce,
    "Health and Personal Care" : healthAndPersonalCare,
    "Household and Cleaning" : householdAndCleaning
]

var foodGroups = [grains, vegetable, fruit, proteins, dairies, other]
