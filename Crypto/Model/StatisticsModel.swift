//
//  StatisticsModel.swift
//  Crypto
//
//  Created by forys on 2023-10-04.
//

import Foundation


struct StatisticsModel: Identifiable {
    let id = UUID().uuidString //Identifiable
    let title: String
    let value: String
    
    let percentageChange: Double?
    init(title: String, value: String, percentageChange: Double? = nil){ // 参数默认值
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}

//let model = StatisticsModel(title: "", value: "", percentageChange: nil)
//let model = StatisticsModel(title: "", value: "")
