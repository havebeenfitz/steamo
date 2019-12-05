//
//  TotalWinsTableViewCell.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Charts
import UIKit

class WinRateTableViewCell: UITableViewCell {
    private let pieChartView: PieChartView = {
        let pieChartView = PieChartView()
        pieChartView.drawHoleEnabled = true
        pieChartView.holeColor = .clear
        pieChartView.drawEntryLabelsEnabled = true
        return pieChartView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: Dota2StatsSectionViewModelRepresentable) {
        guard let viewModel = viewModel as? WinRateSectionViewModel else {
            return
        }
        
        let chartValues = viewModel.chartValues()
        
        let wonGamesCount = Double(chartValues[.won]?.count ?? 0)
        let lostGamesCount = Double(chartValues[.lost]?.count ?? 0)
    
        let pieChartWonEntries = PieChartDataEntry(value: wonGamesCount, label: "Won")
        let pieChartLostEntries = PieChartDataEntry(value: lostGamesCount, label: "Lost")
        
        let totalEntries: [PieChartDataEntry] = [pieChartLostEntries, pieChartWonEntries]
        
        let chartDataSet = PieChartDataSet(entries: totalEntries, label: "")
        chartDataSet.colors = [NSUIColor.systemRed, NSUIColor.systemGreen]
        chartDataSet.sliceSpace = 3
        
        pieChartView.data = PieChartData(dataSet: chartDataSet)
        pieChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
    }
    
    private func setup() {
        if #available(iOS 11.0, *) {
            contentView.backgroundColor = UIColor(named: "Background")
        } else {
            contentView.backgroundColor = .background
        }
        
        contentView.addSubview(pieChartView)
        pieChartView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
            make.height.equalTo(300).priority(.init(999))
        }
        
        pieChartView.legend.enabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pieChartView.data = nil
    }
}
