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
    
//    func cancelResistration() {
//        if let childrenCount = navigationController?.children.count,
//           childrenCount > 0 {
//            print("chileあり")
//            for case let child as FoodRegistrationViewController in navigationController!.children {
//                print("FoodRegistrationViewControllerがありました")
//                child.view.removeFromSuperview()
//                child.removeFromParent()
//            }
//        }
//    }
    
    struct Section {
        let indexPath: IndexPath
        
        var number: Int {
            self.indexPath.section
        }
        
        init(at indexPath: IndexPath) {
            self.indexPath = indexPath
        }
    }
    
    func arrange(_ foods: [FoodObject], in section: Section) -> [FoodObject] {
        
        for case CategoryType.allCases[section.number] in CategoryType.allCases {
            let filterdFoods = foods.filter {
                $0.category == CategoryType.allCases[section.number].name
            }
            return filterdFoods
        }
        //かからなければ空の配列を返す
        return []
    }
}

extension FoodListViewController: UITableViewDelegate {
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let searchedFoodList: [FoodObject]
        
        if searchController.isActive {
            searchedFoodList = arrange(self.searchedFoodList, in: Section(at: indexPath))
        } else {
            searchedFoodList = arrange(self.foodList, in: Section(at: indexPath))
        }
        
        self.selectingFood = searchedFoodList[indexPath.row]
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
        
        let sectionCategory = CategoryType.allCases[section]
      
        for case sectionCategory in CategoryType.allCases {
            let searchedFoodList: [FoodObject]
            
            if searchController.isActive {
                searchedFoodList = self.searchedFoodList
            } else {
                searchedFoodList = self.foodList
            }
            
            let filterdFoods = searchedFoodList.filter {
                $0.category == sectionCategory.name
            }
            
            let filterdFoodsCount = filterdFoods.count
            return filterdFoodsCount
        }
        return 0
    }
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { fatalError() }
        
        let resultedFoodList: [FoodObject]
        
        if searchController.isActive {
            resultedFoodList = arrange(searchedFoodList, in: Section(at: indexPath))
        } else {
            resultedFoodList = arrange(foodList, in: Section(at: indexPath))
        }
        
        let foodName = resultedFoodList[indexPath.row].foodName
        
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
