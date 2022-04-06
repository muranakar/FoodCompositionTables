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
    func save(selectFood: SelectFood)
    func loadSelectFoods() -> [SelectFood]
    func loadFoodTable() -> [FoodComposition]
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
    
    func save(selectFood: SelectFood) {
        do {
            try realm.write() {
                realm.add(selectFood)
            }
        } catch {
            print("error")
        }
    }
    
    func loadSelectFoods() -> [SelectFood] {
        let selectFoodsResults
        = realm
            .objects(SelectFood.self)
            .sorted(byKeyPath: "objectId",
                    ascending: true)
        
        let selectFoods = Array(selectFoodsResults)
        return selectFoods
    }
    
    func loadFoodTable() -> [FoodComposition] {
        let allFoodsResults
        = realm
            .objects(FoodComposition.self)
            .sorted(byKeyPath: "id",
                    ascending: true)
        let allFoods = Array(allFoodsResults)
        return allFoods
    }
    
    func delete(selectFood: SelectFood) {
        do {
            try realm.write() {
                realm.delete(selectFood)
            }
        } catch {
            print("error")
        }
    }
}
