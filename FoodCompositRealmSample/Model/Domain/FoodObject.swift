//
//  Nutrients.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/04/09.
//

import Foundation

//Compositionは今後も増える

struct FoodObject: Equatable {
    
    var id: Int?
    var foodCode: Int
    var foodName: String
    var energy: Int
    var water: Double
    var protein: Double
    var fat: Double
    var dietaryfiber: Double
    var carbohydrate: Double
    var category: String
    var sugar: Double
    
    var defaultWeight: Double = 100
    
    init(food: FoodComposition) {
        id = food.id
        foodCode = food.food_code ?? 0
        foodName = food.food_name ?? ""
        energy = food.energy ?? 0
        water = food.water ?? 0
        protein = food.protein ?? 0
        fat = food.fat ?? 0
        dietaryfiber = food.dietaryfiber ?? 0
        carbohydrate = food.carbohydrate ?? 0
        category = food.category ?? ""
//        sugar = food.sugar ?? 0
        //TODO: sugarの扱いの検討
        sugar = carbohydrate - dietaryfiber
    }
}

struct PFS { // Protein Fat Sugar
    var protein: Double
    var fat: Double
    var sugar: Double
    
    //Enerygy関係はほとんど同様のプロパティがPFSとPFCと二箇所にあって良くない
    var energy: Double { // Atwater
        (protein * 4)
        + (fat * 9)
        + (sugar * 4)
    }
    
    var proteinPercentEnergy: Double {
        (( protein * 4) / energy ) * 100
    }
    
    var fatPercentEnergy: Double {
        (( fat * 9) / energy ) * 100
    }
    
    var sugarPercentEnergy: Double {
        (( sugar * 4) / energy ) * 100
    }

    var ketogenicValue: Double? {
        if (sugar + 0.1 * fat + 0.58 * protein) == 0 { return nil }
        let index =  (0.9 * fat + 0.46 * protein) / (sugar + 0.1 * fat + 0.58 * protein)
        let roundedIndex = round(index * 10) / 10
        return roundedIndex
    }
    
    //Tableからのイニシャライズ
    init(food: FoodObject){
        protein = food.protein
        fat = food.fat
        sugar = food.sugar
    }
    
    //UIからのイニシャライズ
    init(protein: Double, fat: Double, sugar: Double) {
        self.protein = protein
        self.fat = fat
        self.sugar = sugar
    }
    
    // 目標ケトン値に対する必要脂質量の過不足
    func lipidRequirementInKetogenicValue(for targetValue: Double) -> Double? {
        if ((0.1 * targetValue - 0.9) - fat) == 0 { return nil }
        let lipidRequirement = (0.46 * protein - targetValue * ( sugar + 0.58 * protein )) / (0.1 * targetValue - 0.9) - fat
        let roundedLipidRequirement = round(lipidRequirement * 10) / 10
        return roundedLipidRequirement
    }
}

struct PFC { // Protein Fat Carbohydrate
    
    var protein: Double
    var fat: Double
    var carbohydrate: Double
    var energy: Double { // Atwaterの係数
        (protein * 4)
        + (fat * 9)
        + (carbohydrate * 4)
    }
    
    var proteinPercentEnergy: Double {
        (( protein * 4) / energy ) * 100
    }
    
    var fatPercentEnergy: Double {
        (( fat * 9) / energy ) * 100
    }
    
    var carbohydratePercentEnergy: Double {
        (( carbohydrate * 4) / energy ) * 100
    }
    
    var ketogenicRatio: Double? {  // ケトン比の算出
        if (protein + carbohydrate) == 0 { return nil }
        let index = fat / (protein + carbohydrate)
        let roundedIndex = round(index * 10) / 10
        return roundedIndex
    }
    
    var ketogenicIndex: Double? { // ケトン指数の算出
        if (carbohydrate + 0.1 * fat + 0.58 * protein) == 0 { return nil }
        let index =  (0.9 * fat + 0.46 * protein) / (carbohydrate + 0.1 * fat + 0.58 * protein)
        let roundedIndex = round(index * 10) / 10
        return roundedIndex
    }
    
    //Tableからのイニシャライズ
    init(food: FoodObject){
        protein = food.protein
        fat = food.fat
        carbohydrate = food.carbohydrate
    }
    
    //UIからのイニシャライズ
    init(protein: Double, fat: Double, carbohydrate: Double) {
        self.protein = protein
        self.fat = fat
        self.carbohydrate = carbohydrate
    }
    
    // 目標ケトン比に対する必要脂質量の過不足
    func lipidRequirementInKetogenicRatio(for targetValue: Double) -> Double? {
        guard let ketogenicRatio = ketogenicRatio else { return nil}
        let lipidRequirement = (targetValue - ketogenicRatio) * (protein + carbohydrate)
        let roundedLipidRequirement = round(lipidRequirement * 10) / 10
        return roundedLipidRequirement
    }
    
    // 目標ケトン指数に対する必要脂質量の過不足
    func lipidRequirementInKetogenicIndex(for targetValue: Double) -> Double? {
        if ((0.1 * targetValue - 0.9) - fat) == 0 { return nil }
        let lipidRequirement = (0.46 * protein - targetValue * ( carbohydrate + 0.58 * protein)) / ( 0.1 * targetValue - 0.9) - fat
        let roundedLipidRequirement = round(lipidRequirement * 10) / 10
        return roundedLipidRequirement
        
    }
}


