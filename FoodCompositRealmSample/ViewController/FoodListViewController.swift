//
//  ViewController.swift
//  FoodCompositRealmSample
//
//  Created by toaster on 2022/01/25.
//

import UIKit

protocol FoodListViewTransitonDelegate: AnyObject {
    func transitPresentingVC(_: () -> Void)
}

struct Section {
    
    let number:Int
    
    init(at index: Int) {
        self.number = index
    }
}

class FoodListViewController: UIViewController,FoodRegistrationDelegate {
    
    weak var delegate: FoodListViewTransitonDelegate?
    
    private var selectingFood: FoodObject?
    private var foodList: [FoodObject] = []
    private var searchedFoodList: [FoodObject] = []
    private var searchController = UISearchController()
    
    @IBOutlet private weak var tableView: UITableView!
    
    //検索時のTableViewを覆い隠す用
    @IBOutlet private weak var coverView: UIView!
    @IBOutlet private weak var contentsCoverView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        setupSearchBar()
        configure()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let foodCompositonVC = segue.destination as? FoodCompositionViewController else { return }
        guard let selectingFood = selectingFood else { return }
        foodCompositonVC.selectFood = selectingFood
        foodCompositonVC.delegate = self
    }
    
    private func configure() {
        foodList = FoodCompositionTableUseCase().foodTable
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func transitPresentingVC() {
        searchController.isActive = false
        delegate?.transitPresentingVC {
            print(String(describing: delegate?.transitPresentingVC))
        }
        self.dismiss(animated: true)
    }
    
    func arrange(_ foods: [FoodObject], in categorySection: Section) -> [FoodObject] {
        
        for case CategoryType.allCases[categorySection.number] in CategoryType.allCases {
            let filterdFoods = foods.filter {
                $0.category == CategoryType.allCases[categorySection.number].name
            }
            return filterdFoods
        }
        //かからなければ空の配列を返す
        return []
    }
    
    //indexPath.rowとsectionの使い分けが同じ中に入っているのが問題
    func searchedResultFoods(between section: Section) -> [FoodObject] {
        let resultedFoods: [FoodObject]
        
        if searchController.isActive {
            resultedFoods = arrange(searchedFoodList, in: section)
        } else {
            resultedFoods = arrange(foodList, in: section)
        }
        return resultedFoods
    }
}

extension FoodListViewController: UITableViewDelegate {
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchedFoods = searchedResultFoods(between: Section(at: indexPath.row))
        self.selectingFood = searchedFoods[indexPath.row]
        performSegue(withIdentifier: "toFoodCompositionVC", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CategoryType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CategoryType.allCases[section].name
    }
}

extension FoodListViewController: UITableViewDataSource {
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let searchedResultFoods = searchedResultFoods(between: Section(at: section))
        return searchedResultFoods.count
    }
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { fatalError() }
        
//        let resultedFoods: [FoodObject]
        
//        if searchController.isActive {
//            //ここはindex.sectionにしなければいけないのが分かりづらい
//            resultedFoods = arrange(searchedFoodList, in: Section(at: indexPath.section))
//        } else {
//            resultedFoods = arrange(foodList, in: Section(at: indexPath.section))
//        }

        let searchedResultFoods = searchedResultFoods(between: Section(at: indexPath.section))
        let foodName = searchedResultFoods[indexPath.row].foodName
        
        var content = UIListContentConfiguration.cell()
        content.text = foodName
        content.textProperties.numberOfLines = 2
        cell.contentConfiguration = content
        return cell
    }
}

extension FoodListViewController: UISearchBarDelegate {
    
    
}

extension FoodListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        searchedFoodList = search(for: searchBarText, in: foodList)
        tableView.reloadData()
    }
    
    func search(for text: String, in foods: [FoodObject]) -> [FoodObject] {
        let searchedFoods = foods.filter {
            let searchedFood = $0.foodName.contains(text.lowercased())
            return searchedFood
        }
        return searchedFoods
    }
}
