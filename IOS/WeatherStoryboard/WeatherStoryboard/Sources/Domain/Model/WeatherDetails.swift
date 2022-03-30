//
//  WeatherDetails.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/30.
//

import Foundation

struct WeatherDetails {
    let weatherID: Int
    let weatherCondition: String
    let weatherDescription: String
    let weatherIconID: String
    var weatherIcon: String? {
        switch weatherIconID {
            case "01d": return "sun.max.fill"
            case "01n": return "sun.max.fill"
            case "02d": return "sun.max.fill"
            case "02n": return "sun.max.fill"
            case "03d", "03n", "04d", "04n": return "sun.max.fill"
            case "09d", "09n": return "sun.max.fill"
            case "10d": return "sun.max.fill"
            case "10n": return "sun.max.fill"
            case "11d", "11n": return "sun.max.fill"
            case "13d", "13n": return "sun.max.fill"
            case "50d", "50n": return "sun.max.fill"
            default: return "sun.max.fill"
        }
    }
}
