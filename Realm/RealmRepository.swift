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
    func loadSelectFoods() -> Results<SelectFood>
    func loadFoodTable() -> Results<FoodComposition>
}

class RealmRepository: FoodTableRepository {
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
    
    func loadSelectFoods() -> Results<SelectFood> {
        let selectFoods
        = realm
            .objects(SelectFood.self)
            .sorted(byKeyPath: "objectId",
                    ascending: true)
        
        return selectFoods
    }
    
    func loadFoodTable() -> Results<FoodComposition> {
        let allFoods
        = realm
            .objects(FoodComposition.self)
            .sorted(byKeyPath: "id",
                    ascending: true)
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
    
    //    // PK検索
    //    func find(primaryKey: String) -> DomainType? {
    //      return realm.objects(DomainType.self).filter("id == %@", primaryKey).first
    //    }
    //    // 全部取ってくる
    //    func findAll() -> {
    //      return realm.objects(DomainType.self).map({$0})
    //    }
    //    // 条件指定
    //    func find(predicate: NSPredicate) -> Results<DomainType> {
    //      return realm.objects(DomainType.self).filter(predicate)
    //    }
    //    // データ追加と更新
    //    func add(domains: [DomainType]) {
    //      try! realm.write {
    //        realm.add(domains, update: true)
    //      }
    //    }
    //    // データ削除
    //    func delete(domains: [DomainType]) {
    //      try! realm.write {
    //        realm.delete(domains)
    //      }
    //    }
}
