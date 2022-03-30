//
//  WeatherSummary.swift
//  WeatherStoryboard
//
//  Created by xogns.7868 on 2021/12/25.
//

import Foundation

struct WeatherSummary {
  let latitude, longitude: Double
  let timezone: String
  let current: CurrentWeatherSummary
  let daily: [DailyWeatherSummary]
  let hourly: [HourlyWeatherSummary]
}

struct CurrentWeatherSummary {
  let time, sunriseTime, sunsetTime: Date
  let actualTemp, feelsLikeTemp: Temperature
  let pressure, humidity: Int
  let uvIndex: Double
  let windSpeed: Double
  let windAngle: Int
  var windDirection: String {
    if windAngle >= 337 || windAngle < 23 {
      return "N"
    }
    if windAngle < 67 {
      return "NE"
    }
    if windAngle < 113 {
      return "E"
    }
    if windAngle < 157 {
      return "SE"
    }
    if windAngle < 203 {
      return "S"
    }
    if windAngle < 247 {
      return "SW"
    }
    if windAngle < 293 {
      return "W"
    }
    return "NW"
  }

  let weatherDetails: [WeatherDetails]
}

struct DailyWeatherSummary {
  let time, sunriseTime, sunsetTime: Date
  let dayTemp, nightTemp: Temperature
  let minTemp, maxTemp: Temperature
  let eveTemp, mornTemp: Temperature
  
  let weatherDetails: [WeatherDetails]
}

struct HourlyWeatherSummary {
  let time: Date
  let actualTemp, feelsLikeTemp: Temperature
  
  let weatherDetails: [WeatherDetails]
}

struct Temperature {
  var kelvin: Double
  
  var celsius: Double {
    kelvin - 273.15
  }
  
  var fahrenheight: Double {
    (kelvin - 273.15) * (9 / 5) + 32
  }
}

extension Temperature: ExpressibleByFloatLiteral {
  init(floatLiteral value: FloatLiteralType) {
    kelvin = value
  }
}
