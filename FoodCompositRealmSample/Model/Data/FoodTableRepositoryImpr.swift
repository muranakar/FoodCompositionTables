//
//  RealmRepository.swift
//  FoodCompositRealmSample
//
//  Created by 山田　天星 on 2022/03/09.
//

import Foundation
import RealmSwift

protocol FoodTableRepository {
    func initializeRealm()
    func save(selectFood: SelectFoodObject)
    func loadSelectFoods() -> [SelectFoodObject]
    func loadFoodTable() -> [FoodObject]
}

final class FoodTabelRepositoryImpr: FoodTableRepository {    
        
    private var realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    func initializeRealm() {
        print("initialize .realm")
        deleteRealm()
        
        guard let defaultFileURL =  Realm.Configuration.defaultConfiguration.fileURL,
              let initialFileURL =  Bundle.main.url(forResource: "initial",
                                                    withExtension: "realm") else {
                  return print("FileURLが見つかりません")
              }
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: defaultFileURL.path) {
            try! fileManager.copyItem(at: initialFileURL,
                                      to: defaultFileURL)
            print("realmを生成しました")
        }
    }
    
    func deleteRealm() {
        do {
            guard let defaultURL = Realm.Configuration.defaultConfiguration.fileURL else {
                print("Realm.Configuration.defaultConfiguration.fileURL is missing")
                return
            }
            try FileManager.default.removeItem(at: defaultURL)
            print("completed to delete default.realm")
        } catch {
            print("failed to delete default.realm")
        }
    }
    
    //Adapter?
    func convert(selectFoodObject: SelectFoodObject) -> SelectFood {
        let selectFoodId = selectFoodObject.food.id
        let foodObject
        = realm
            .objects(FoodComposition.self)
            .first { $0.id == selectFoodId }
        let weight = selectFoodObject.weight
        
        let selectFood = SelectFood.init()
        selectFood.foodObject = foodObject
        selectFood.foodWeight = weight
        return selectFood
    }
    
    func find(selectFoodObject: SelectFoodObject) -> SelectFood? {
        let selectFoodId = selectFoodObject.food.id
        let selectfood
        = realm
            .objects(SelectFood.self)
            .first { $0.foodObject?.id == selectFoodId }
        
        return selectfood
    }
    
    
    
    //TODO: FoodCompositionはできるけどWeightが入らない
    func save(selectFood: SelectFoodObject) {
        let selectFood = convert(selectFoodObject: selectFood)
        
        do {
            try realm.write() {
                realm.add(selectFood)
            }
        } catch {
            print("error")
        }
    }
    
    func loadSelectFoods() -> [SelectFoodObject] {
        let selectFoodsResults
        = realm
            .objects(SelectFood.self)
            .sorted(byKeyPath: "objectId",
                    ascending: true)
        
        let selectFoods:[SelectFoodObject] = Array(selectFoodsResults).compactMap {
            guard let food = $0.foodObject else { return nil }
            let selectfood = FoodObject(food: food)
            return SelectFoodObject(food: selectfood, weight: $0.foodWeight)
        }
        return selectFoods
    }
    
    func loadFoodTable() -> [FoodObject] {
        let allFoodsResults
        = realm
            .objects(FoodComposition.self)
            .sorted(byKeyPath: "id",
                    ascending: true)
        let allFoods = Array(allFoodsResults).map {
            FoodObject(food: $0)
        }
        return allFoods
    }
    
    func delete(selectFoodObject: SelectFoodObject) {
        do {
            guard let selectFood = find(selectFoodObject: selectFoodObject) else { return }
            try realm.write() {
                realm.delete(selectFood)
            }
        } catch {
            print("error")
        }
    }

}
