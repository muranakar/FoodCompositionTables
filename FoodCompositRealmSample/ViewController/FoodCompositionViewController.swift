//
//  FoodCompositionViewController.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/04/09.
//

import UIKit

class FoodCompositionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectFood:FoodCompositionObject?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "CompositionCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Composition.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompositionCell") else { fatalError() }
//        guard let nutrient = Composition(rawValue: indexPath.row) else { return cell }
        let nutrient = Composition.allCases[indexPath.row]
        let nutrientString = nutrient.nameString
        
        guard let selectFood = selectFood else { return cell }

        var value: String
        switch nutrient {
        case .foodCode: value = String(selectFood.foodCode )
        case .foodName: value = selectFood.foodName
        case .energy: value = String(selectFood.energy) + " g"
        case .water: value = String(selectFood.water) + " g"
        case .protein: value = String(selectFood.protein) + " g"
        case .fat: value = String(selectFood.fat) + " g"
        case .dietaryfiber: value = String(selectFood.dietaryfiber) + " g"
        case .carbohydrate: value = String(selectFood.carbohydrate) + " g"
        case .category: value = selectFood.category
        case .weight: value = "100gあたり"
        }

        var content = UIListContentConfiguration.valueCell()
        content.text = nutrientString
        content.secondaryText = value
        cell.contentConfiguration = content
        return cell
    }
}
