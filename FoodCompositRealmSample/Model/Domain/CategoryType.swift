//
//  CategoryType.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/05/01.
//

import Foundation

enum CategoryType:Int, CaseIterable {
    
    case koku = 0
    case imo
    case satou
    case mame
    case syuzitsu
    case yasai
    case kazitsu
    case kinoko
    case sou
    case gyokai
    case niku
    case tamago
    case nyuu
    case yushi
    case kashi
    case sikouinryou
    case tyoumiryou
    case tyourizumi
    
    var name: String {
        switch self {
        case .koku: return "１ 穀類"
        case .imo: return "２ いも及びでん粉類"
        case .satou: return "３ 砂糖及び甘味類"
        case .mame: return "４ 豆類"
        case .syuzitsu: return "5 種実類"
        case .yasai: return "6 野菜類"
        case .kazitsu: return "7 果実類"
        case .kinoko: return "8 きのこ類"
        case .sou: return "9 藻類"
        case .gyokai: return "10 魚介類"
        case .niku: return "11 肉類"
        case .tamago: return "12 卵類"
        case .nyuu: return "13 乳類"
        case .yushi: return "14 油脂類"
        case .kashi: return "15 菓子類"
        case .sikouinryou: return "16 し好飲料類"
        case .tyoumiryou: return "17 調味料及び香辛料類"
        case .tyourizumi: return "18　調理済み流通食品類"
        }
    }
}

enum KetogenicIndexType: Int, CaseIterable {
    
    case ketogenicRatio
    case ketogenicIndex
    case ketogenicValue
    
    var name: String {
        switch self {
        case .ketogenicRatio: return "ケトン比"
        case .ketogenicIndex: return "ケトン指数"
        case .ketogenicValue: return "ケトン値"
        }
    }
}
