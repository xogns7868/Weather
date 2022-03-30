//
//  HourSummaryViewModel.swift
//  WeatherStoryboard
//
//  Created by xogns.7868 on 2022/01/22.
//

import Foundation

class HourSummaryViewModel: Identifiable {
  private let hourSummary: HourlyWeatherSummary
  
  var id = UUID()
  
  var tempFmt: String {
    String(format: "%.0fº", hourSummary.actualTemp.celsius)
  }
  
//  var icon: Image? {
//    hourSummary.weatherDetails.first?.weatherIcon
//  }
  
  var timeFmt: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:00 a"
    return dateFormatter.string(from: hourSummary.time)
  }
  
  init(hourSummary: HourlyWeatherSummary) {
    self.hourSummary = hourSummary
  }
}
