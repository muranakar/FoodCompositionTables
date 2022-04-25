//
//  ResultViewController.swift
//  FoodCompositionTables
//
//  Created by 山田　天星 on 2022/04/25.
//

import UIKit
import Charts

class ResultViewController: UIViewController {
    
    var pfcRatio: (Double,Double,Double) = (0,0,0)
    @IBOutlet weak var ketoneView: UIView!
    @IBOutlet weak var totalNutritionView: UIView!
    
    var dataSet = PieChartDataSet()
    @IBOutlet weak var pieChartsView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        reloadPFCPieChart()
    }
    
    func setup() {
        pieChartsView.centerText = "PFCバランス"
        // グラフの色
        dataSet.colors = ChartColorTemplates.vordiplom()
        // グラフのデータの値の色
        dataSet.valueTextColor = UIColor.black
        // グラフのデータのタイトルの色
        dataSet.entryLabelColor = UIColor.black
        
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
        
        view.addSubview(self.pieChartsView)
    }
    
    func reloadPFCPieChart() {
        
        let pieChartsDataEnry = [
            PieChartDataEntry(value: pfcRatio.0, label: "たんぱく質"),
            PieChartDataEntry(value: pfcRatio.1, label: "脂質"),
            PieChartDataEntry(value: pfcRatio.2, label: "炭水化物")
        ]
        
        dataSet = PieChartDataSet(entries: pieChartsDataEnry, label: "PFCバランス")
        self.pieChartsView.data = PieChartData(dataSet: dataSet)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
