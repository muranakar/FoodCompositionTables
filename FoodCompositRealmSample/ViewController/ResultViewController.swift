////
////  ResultViewController.swift
////  FoodCompositionTables
////
////  Created by 山田　天星 on 2022/04/25.
////

import UIKit
import Charts

final class ResultViewController: UIViewController {
    //これモデル側に寄せられる？
    let selectFoodTableUseCase = SelectFoodsTableUseCase()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pieChartsView: PieChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "resultCell")
        tableView.delegate = self
        tableView.dataSource = self

        pieChartsView.centerText = "PFC balance"
        reloadPFCPieChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadPFCPieChart()
        tableView.reloadData()
    }

    func reloadPFCPieChart() {
        let energy = selectFoodTableUseCase.totalEnergy
        let proteinRatio = Int(selectFoodTableUseCase.totalProtein) * 4 / energy * 100
        let fatRatio = Int(selectFoodTableUseCase.totalFat)  * 4 / energy * 100
        let carbohydrateRatio = Int(selectFoodTableUseCase.totalCarbohydrate)  * 4 / energy * 100

        let pieChartsDataEnry = [
            PieChartDataEntry(value: Double(proteinRatio), label: "protein"),
            PieChartDataEntry(value: Double(fatRatio), label: "fat"),
            PieChartDataEntry(value: Double(carbohydrateRatio), label: "carbo")
        ]
        var dataSet = PieChartDataSet()
        // データを％表示にする
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        
        pieChartsView
            .data?
            .setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieChartsView
            .usePercentValuesEnabled = true
//        view.addSubview(self.pieChartsView)
        dataSet = PieChartDataSet(entries: pieChartsDataEnry, label: "PFCバランス")
        dataSet.colors = ChartColorTemplates.liberty()
        dataSet.valueTextColor = UIColor.black
        dataSet.entryLabelColor = UIColor.black
        self.pieChartsView.data = PieChartData(dataSet: dataSet)
    }
}

extension ResultViewController: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") else { fatalError() }
    
//        栄養素名称
        let compositionName = ["タンパク質","脂質","炭水化物"]
        let indexCompositionName = compositionName[indexPath.row]
        //栄養素量
        let compositionValue: Double
        if indexPath.row == 0 {
            compositionValue = selectFoodTableUseCase.totalProtein
        } else if indexPath.row == 1 {
            compositionValue = selectFoodTableUseCase.totalFat
        } else {
            compositionValue = selectFoodTableUseCase.totalCarbohydrate
        }

        var content = UIListContentConfiguration.valueCell()
        content.text = indexCompositionName
        content.secondaryText = String(compositionValue)
        cell.contentConfiguration = content
        return cell
    }
}
