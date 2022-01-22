//
//  DaySummaryViewModel.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/01/22.
//

import Foundation

class DaySummaryViewModel: Identifiable {
  private let daySummary: DailyWeatherSummary
  
  var id = UUID()
  
  var day: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: daySummary.time)
  }
  
  var highTempFmt: String {
    String(format: "%.0fº", daySummary.maxTemp.fahrenheight)
  }
  
  var lowTempFmt: String {
    String(format: "%.0fº", daySummary.minTemp.fahrenheight)
  }
  
//  var icon: Image? {
//    daySummary.weatherDetails.first?.weatherIcon
//  }
  
  init(daySummary: DailyWeatherSummary) {
    self.daySummary = daySummary
  }
}
