//
//  ViewController.swift
//  FoodCompositRealmSample
//
//  Created by toaster on 2022/01/25.
//

import UIKit
import RealmSwift


protocol FoodListViewTransitonDelegate: AnyObject {
    func transitPresentingVC(_: ()->Void)
}

class FoodListViewController: UIViewController,FoodRegistrationDelegate {
    
    weak var delegate: FoodListViewTransitonDelegate?
    private let defaultCategory: [String] = FoodComposition.defaultCategory

    private var realmRepository = RealmRepository()
    private var foodList: Results<FoodComposition>?
    private var searchedFoodList: Results<FoodComposition>?
    private var searchController = UISearchController()
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var coverView: UIView!
    @IBOutlet private weak var contentsCoverView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        setupSearchBar()
        configureRealm()
    }
    
    private func configureRealm() {
        foodList = realmRepository.loadFoodTable()
    }
    
    private func setupSearchBar() {
        //        searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchResultsUpdater = self
        //        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
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
    
    func cancelResistration() {
        
        if let childrenCount = navigationController?.children.count,
           childrenCount > 0 {
            print("chileあり")
            for case let child as FoodRegistrationViewController in navigationController!.children {
                print("FoodRegistrationViewControllerがありました")
                child.view.removeFromSuperview()
                child.removeFromParent()
            }
        }
        
        //        if self.children.count > 0 {
        //            for child in children {
        //                child.view.removeFromSuperview()
        //                child.removeFromParent()
        //            }
        //        }
        
        //        coverView.isHidden = true
        //        contentsCoverView.isHidden = true
    }
}

extension FoodListViewController: UITableViewDelegate {
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let foodRegistrationViewController
                = storyboard?.instantiateViewController(identifier: "popover")
                as? FoodRegistrationViewController else {
                    print("failed to instantiate")
                    return
                }
        
        foodRegistrationViewController.delegate = self
        
        for case defaultCategory[indexPath.section] in defaultCategory {
            
            let searchedFoodList: Results<FoodComposition>?
            if searchController.isActive {
                searchedFoodList = self.searchedFoodList
            } else {
                searchedFoodList = self.foodList
            }
            
            let selectingFoods = searchedFoodList?.where { $0.category == self.defaultCategory[indexPath.section] }
            foodRegistrationViewController.selectingFood = selectingFoods?[indexPath.row]
            break
        }
        
        //        guard let navigationBarViewFrame = self.navigationController?.navigationBar.frame else {
        //            return print("navigationBarViewFrame is nil")
        //        }
        //        coverView.frame = navigationBarViewFrame
        //        navigationController?.view.addSubview(coverView)
        //        coverView.isHidden = false
        //
        //        contentsCoverView.map {
        //            $0.frame.size.height = self.view.frame.size.height - navigationBarViewFrame.size.height
        //            $0.frame.size.width = self.view.frame.size.width
        //            $0.frame.origin.x = self.coverView.frame.minX
        //            $0.frame.origin.y = self.coverView.frame.maxY
        //        }
        //        self.view.addSubview(contentsCoverView)
        //        contentsCoverView.isHidden = false
        
        navigationController?.addChild(foodRegistrationViewController)
        foodRegistrationViewController.view.frame = self.view.frame
        self.navigationController?.view.addSubview(foodRegistrationViewController.view)
        //        self.navigationController?.navigationBar.layer.zPosition = -1
        foodRegistrationViewController.didMove(toParent: self)
        //        self.view.bringSubviewToFront(foodRegistrationViewController.view)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return defaultCategory.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return defaultCategory[section]
    }
}

extension FoodListViewController: UITableViewDataSource {
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        for case defaultCategory[section] in defaultCategory {
            let searchedFoodList: Results<FoodComposition>?
            if searchController.isActive {
                searchedFoodList = self.searchedFoodList
            } else {
                searchedFoodList = self.foodList
            }
            
            let searchedFoodsCount = searchedFoodList?.where { $0.category == defaultCategory[section] }.count
            return searchedFoodsCount ?? 0
        }
        
        return 0
    }
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { fatalError() }
        
        for case defaultCategory[indexPath.section] in defaultCategory {
            
            let searchedFoodList: Results<FoodComposition>?
            if searchController.isActive {
                searchedFoodList = self.searchedFoodList
            } else {
                searchedFoodList = self.foodList
            }
            
            let filterdFoods = searchedFoodList?.where { $0.category == self.defaultCategory[indexPath.section] }
            let foodName = filterdFoods?[indexPath.row].food_name
            cell.textLabel?.text = foodName
            cell.textLabel?.numberOfLines = 2
            break
        }
        return cell
    }
}

extension FoodListViewController: UISearchBarDelegate {
    
}

extension FoodListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("searching")
        searchedFoodList = foodList?.where {
            $0.food_name.contains(searchController.searchBar.text?.lowercased())
        }
        tableView.reloadData()
    }
}
