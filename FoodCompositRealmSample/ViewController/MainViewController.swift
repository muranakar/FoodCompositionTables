//
//  SelectedFoodViewController.swift
//  FoodCompositRealmSample
//
//  Created by 山田　天星 on 2022/02/25.
//

import Foundation
import UIKit

final class MainViewController: UIViewController,FoodListViewTransitonDelegate {
    
    @IBOutlet private weak var energyLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var registFoodButton: UIButton!
    
    var repository = FoodTabelRepositoryImpr()
    var selectFoods: [SelectFood] {
        repository.loadSelectFoods()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        
        registFoodButton.addTarget(self,
                                   action: #selector(addFoodTouchUpInside),
                                   for: .touchUpInside)
    }
    
    private func setup() {
        registFoodButton.layer.cornerRadius = registFoodButton.frame.height / 2
        displayEnergy()
    }
    
    private func displayEnergy() {
        let totalEnergy:Int
        = selectFoods
            .map({ $0.foodObject?.energy ?? 0 })
            .reduce(0,+)
        
        energyLabel.text = String(totalEnergy) + "kcal"
    }
    
    @objc private func addFoodTouchUpInside() {
        guard let navigationController = storyboard?.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController else { return }
        guard let foodListViewController = navigationController.viewControllers[0] as? FoodListViewController else { return }
        foodListViewController.delegate = self
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func transitPresentingVC(_: () -> Void) {
        self.displayEnergy()
        self.tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        repository.delete(selectFood: selectFoods[indexPath.row])
        displayEnergy()
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectFoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        let foodName:[String]? = selectFoods.map { $0.foodObject?.food_name ?? "" }
        cell.textLabel?.text = foodName?[indexPath.row]
        return cell
    }
}
