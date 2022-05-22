//
//  RealmModel.swift
//  FoodCompositRealmSample
//
//  Created by 山田　天星 on 2022/02/23.
//

import Foundation
import RealmSwift
//TODO: データの元となっているRealmファイルが新しく作り直せないでいるため、Realmから取ってくるオブジェクトの名称を変えたくても今は変えられていません

//Entity
class FoodComposition: Object {
    
    @Persisted var id: Int?
    @Persisted var food_code: Int?
    @Persisted var food_name: String?
    @Persisted var energy: Int?
    @Persisted var water: Double?
    @Persisted var protein: Double?
    @Persisted var fat: Double?
    @Persisted var dietaryfiber: Double?
    @Persisted var carbohydrate: Double?
    @Persisted var category: String?
    
}

//Entity
class SelectFood: Object {
    // 管理用 ID。プライマリーキー
    @Persisted var objectId = ObjectId.generate()
    // 内容
    @Persisted var foodObject: FoodComposition?
    // 日時
    @Persisted var foodWeight: Double = 100
    
    override class func primaryKey() -> String? {
        "objectId"
    }
}
