//
//  FiveDayWeatherSummary.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/13.
//

import Foundation

struct FiveDayWeatherSummary {
    let threeHourly: [ThreeHourlySummary]
}

struct ThreeHourlySummary {
    let dt: Int
    let weather: [WeatherDetails]
    let temp: Temperature
    let dtTxt: String
    let rain: Double?
}
