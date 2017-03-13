//
//  FoodCategories.swift
//  Keep
//
//  Created by Luna An on 1/19/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import Foundation

var grains: [String:Set<String>] = [
    "Pastas And Noodles" : pastaAndNoodles,
    "Other Grains" : otherGrains,
]

var vegetable: [String : Set<String>] = [
    "Vegetables": vegetables
]

var fruit: [String:Set<String>] = [
    "Fruits": fruits
]

var proteins: [String:Set<String>] = [
    "Meats, Seafoods And Eggs": meatsSeafoodsAndEggs,
    "Beans, Peas And Tofu": beansPeasAndTofu,
    "Nuts And Seeds" : nutsAndSeeds
]

var dairies: [String:Set<String>] = [
    "Dairy": dairy
]

var other: [String:Set<String>] = [
    "Beverages" : beverages,
    "Alcoholic Beverages" : alcoholicBeverages,
    "Condiments and Sauce" : condimentsAndSauce,
    "Health and Personal Care" : healthAndPersonalCare,
    "Household and Cleaning" : householdAndCleaning
]

var foodGroups = [grains, vegetable, fruit, proteins, dairies, other]
