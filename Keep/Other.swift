//
//  Other.swift
//  Keep
//
//  Created by Luna An on 3/6/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import Foundation

var beverages: Set<String> = [
    "Water",
    "Sprite",
    "Club Soda",
    "Soy Milk",
    "Rice Milk",
    "Almond Milk",
    "Oat Milk",
    "Flax Milk",
    "Hazenul Milk",
    "Hemp Milk",
    "Quinoa Milk",
    "Cashew Milk",
    "Coconut Milk",
    "Soy Milk",
    "Coke",
    "Pepsi",
    "Ginger Ale",
    "Orange Soda",
    "Lemonade",
    "Sport Drinks",
    "Energy Drinks",
    "Soda",
    "Sparkling Water",
    "Seltzer",
    "Iced Tea",
    "Water",
    "Protein Drinks",
    "Tonic Water",
    "Coconut Water",
    "Cold pressed Juice",
    "Smoothies",
    "Orange Juice",
    "Tomato Juice",
    "Aloe Vera Juice",
    "Aloe Juice",
    "Sugarcane Juice",
    "Apple Juice ",
    "Coconut water",
    "Cranberry Juice",
    "Grape Juice",
    "Grapefruit Juice",
    "Kiwifruit Juice ",
    "Lemonade",
    "Lemon Juice",
    "Limeade Limes",
    "Lychee Juice",
    "Limonana",
    "Melon Juice",
    "Cantaloupe Juice",
    "Honeydew Juice",
    "Blackberries Juice",
    "Grape Juice",
    "Orange Juice",
    "Papaya Juice",
    "Pineapple Juice",
    "Passionfruit Juice",
    "Pomegranate Juice",
    "Prune Juice",
    "Raspberry Juice",
    "Strawberry Juice",
    "Winter melon Juice",
    "Beet Juice",
    "Carrot Juice",
    "Spinach Juice",
    "Tomato Juice",
    "Guava Juice",
    "Juice",
    "Coffee",
    "Tea",
    "Ground Coffee",
    "French Roast Coffee",
    "Dark Roast Coffee",
    "Medium Roast Coffee",
    "Light Roast Coffee",
    "Organic Coffee",
    "Earl Grey Tea",
    "English Breakfast Tea",
    "Peppermint Tea",
    "Whole Bean Coffee",
    "Iced Coffee",
    "Green Tea",
    "Black Tea",
    "Hot Cocoa",
    "Lemon Tea",
    "Ginger Tea",
    "Honey Tea",
    "K-cups",
    "Espresso Capsules",
    "Detox Tea",
    "Mint Tea",
    "Herbal Tea",
    "Jasmin Tea",
    "Decaf Coffee",
    "Decaf Tea",
    "Matcha Powder",
    "Chamomile Tea"
]

var alcoholicBeverages: Set<String> = [
    
    "Beer",
    "Light Beer",
    "Root Beer",
    "Wine",
    "Red Wine",
    "White Wine",
    "Rosé Wine",
    "Cooking Wine",
    "Dessert Wine",
    "Sparkling Wine",
    "Gin",
    "Vodka",
    "Whisky",
    "Irish Whiskey",
    "Canadian Whiskey",
    "Cognac",
    "Moscato",
    "Rum",
    "Brandy",
    "Liqueurs",
    "Vermouth",
    "Bitters",
    "Mixers",
    "Tequila",
    "Mezcal",
    "Amaretto",
    "Soju",
    "Sake",
    "Irish Cream",
    "Ice Wine",
    "Margarita"
]


var condimentsAndSauce: Set<String> = [
    
    "A-1 Steak Sauce",
    "Agar",
    "Agave Nectar",
    "Apple Sauce",
    "Aspartame",
    "Baker’s Yeast",
    "Baking Soda",
    "Barbecue Sauce",
    "Barley Malt",
    "Pepper",
    "Pepper - Black",
    "Pepper - White",
    "BBQ Sauce",
    "Blackstrap Molasses",
    "Bragg’s Amino Acids",
    "Capers",
    "Chili Sauce",
    "Chipotle",
    "Chutney",
    "Cocktail Sauce",
    "Corn Syrup",
    "Cranberry Sauce",
    "Curry Sauce",
    "Dextrose",
    "Enchilada Sauce",
    "Epazote",
    "Fish Sauce",
    "Fry Sauce",
    "Garlic Powder",
    "Paprika Powder",
    "Gelatin",
    "Ginger Relish",
    "Gluten Free Condiments",
    "Glycerin, Vegetable",
    "Green Sauce",
    "Guacamole",
    "High Fructose Corn Syrup",
    "Honey",
    "Honey Mustard",
    "Hosin Sauce",
    "Hot Sauces",
    "Ketchup",
    "Lecithin",
    "Steak Sauce",
    "Lemon Juice",
    "Lime Juice",
    "Mango Sauce",
    "Maple Syrup",
    "Marmite",
    "Mayonnaise",
    "Mayonnaise, Light",
    "Mayonnaise, Vegan",
    "Mint Jelly",
    "Miso, Soy",
    "Molasses",
    "MSG",
    "Mustard",
    "Mustard, Yellow",
    "Olives",
    "Onions",
    "Orange Sauce",
    "Oyster Sauce",
    "Pectin",
    "Pesto",
    "Picante Sauce",
    "Pickles",
    "Plum Sauce",
    "Relish, Pickle",
    "Rice Syrup",
    "Salsas",
    "Salt",
    "Salt, Sea",
    "Salt, Garlic",
    "Sauerkraut",
    "Sesame Oil",
    "Soy Sauce",
    "Stevia",
    "Stir Fry Sauce",
    "Sugar, Brown,",
    "Sugar, White",
    "Sriracha Sauce",
    "Sweet and Sour Sauce",
    "Tabasco sauce",
    "Tamari",
    "Tartar Sauce",
    "Teriyaki Sauce",
    "Teriyaki Sauce",
    "Thai Peanut Sauce",
    "Vegan Condiments",
    "Vinegar",
    "Worcestershire Sauce",
    "Yeast Extract Spread",
    "Yeast, Nutritional",
    "Pasta Sauce",
    "Tomato Sauce",
    "Hummus",
    "Yogurt Dip",
    "Strawberry Jam",
    "Blueberry Jam",
    "Mixed-berry Jam"
    
]

var healthAndPersonalCare: Set<String> = [
    "Body Wash",
    "Shampoo",
    "Conditioner",
    "Facial Lotion",
    "Body Lotion",
    "Bar Soap",
    "Hand Wash",
    "Toothpaste",
    "Tooth Brush",
    "Floss",
    "Hair Spray",
    "Contact Lens Solution",
    "Eye Drops/Lubricants",
    "Mouth Wash",
    "Razors and blades",
    "Lip Balm",
    "Sunscreen",
    "Shaving Cream",
    "Deodorant",
    "Toner",
    "Cleansing Oil",
    "Cotton Pads",
    "Q Tips",
    "Feminine Wash",
    "Vitamins",
    "Multi-vitamins",
    "Vitamin A",
    "Vitamin B",
    "Vitamin C",
    "Vitamin D",
    "Vitamin E",
    "Vitamin K",
    "Pads",
    "Tampons",
    "Pain Reliever",
    "Condoms"
    
]

var householdAndCleaning: Set<String> = [
    "Coffee Filters",
    "Disinfecting Wipes",
    "Bleach",
    "Glass Cleaner",
    "Sponge",
    "Mopping Clothes",
    "Cleaning Pad",
    "Tableware",
    "Batteries",
    "Trash Bags",
    "Hand Soap",
    "Hand Sanitizer",
    "Drain",
    "Pest Control",
    "Repellent",
    "Bug Control",
    "Boric Acid",
    "Roach Bait",
    "Mouse Traps",
    "Bath Tissue",
    "Paper Towels",
    "Facial Tissue",
    "Detergent",
    "Fabric Softener",
    "Stain Remover",
    "Air Fresher",
    "Dishwashing Detergent",
    "Bathroom Cleaner",
    "Carpet/Floor Cleaner",
    "All Purpose Cleaner",
    "Vacuum Filters",
    "Toilet Paper"
]

