//
//  SelectedFoodViewController.swift
//  FoodCompositRealmSample
//
//  Created by 山田　天星 on 2022/02/25.
//

import Foundation
import UIKit

final class MainViewController: UIViewController,FoodListViewTransitonDelegate {
    // TODO: repositoryからのデータをUseCaseに取り込めるようにする必要がある
    let selectFoodTableUseCase = SelectFoodsTableUseCase()
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var registFoodButton: UIButton!
    @IBOutlet weak var displayResultButton: UIButton!
    
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
        displayResultButton.layer.cornerRadius = displayResultButton.frame.height / 2
    }
    
    private func configure() {
        refleshCompositionValue()
    }
    
    private func refleshCompositionValue() {
        selectFoodTableUseCase.loadSelectFoods()
    }
    
    @objc private func addFoodTouchUpInside() {
        guard let navigationController = storyboard?.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController else { return }
        guard let foodListViewController = navigationController.viewControllers[0] as? FoodListViewController else { return }
        
        foodListViewController.delegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultViewController else {
            return
        }
        resultVC.selectFoodTableUseCase
        = self.selectFoodTableUseCase
    }
    
    func transitPresentingVC(_: () -> Void) {
        refleshCompositionValue()
        self.tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //FoodCompositionViewContollerへ遷移
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let selectFood = selectFoodTableUseCase.selectedFoods[indexPath.row]
        selectFoodTableUseCase.delete(selectFood: selectFood)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        refleshCompositionValue()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectFoodTableUseCase.selectedFoodsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell
        = tableView
            .dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self),
                                 for: indexPath)
       
        let foodNameList
        = selectFoodTableUseCase
            .selectedFoods
            .map { $0.food.foodName }
        
        var content = UIListContentConfiguration.cell()
        content.text = foodNameList[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
}
