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
  
  static func convert(fromResponse response: OneCallResponse) -> WeatherSummary {
    WeatherSummary(latitude: response.lat,
                   longitude: response.lon,
                   timezone: response.timezone,
                   current: .convert(fromResponse: response.current),
                   daily: response.daily.map { .convert(fromResponse: $0) },
                   hourly: response.hourly.map { .convert(fromResponse: $0) })
  }
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
  
  static func convert(fromResponse response: CurrentResponse) -> CurrentWeatherSummary {
    CurrentWeatherSummary(time: Date(timeIntervalSince1970: TimeInterval(response.dt)),
                          sunriseTime: Date(timeIntervalSince1970: TimeInterval(response.sunrise)),
                          sunsetTime: Date(timeIntervalSince1970: TimeInterval(response.sunset)),
                          actualTemp: .init(kelvin: response.temp),
                          feelsLikeTemp: .init(kelvin: response.feelsLike),
                          pressure: response.pressure,
                          humidity: response.humidity,
                          uvIndex: response.uvi,
                          windSpeed: response.windSpeed,
                          windAngle: response.windDeg,
                          weatherDetails: response.weather.map { .convert(fromResponse: $0) })
  }
}

struct DailyWeatherSummary {
  let time, sunriseTime, sunsetTime: Date
  let dayTemp, nightTemp: Temperature
  let minTemp, maxTemp: Temperature
  let eveTemp, mornTemp: Temperature
  
  let weatherDetails: [WeatherDetails]
  
  static func convert(fromResponse response: DailyResponse) -> DailyWeatherSummary {
    DailyWeatherSummary(time: Date(timeIntervalSince1970: TimeInterval(response.dt)),
                        sunriseTime: Date(timeIntervalSince1970: TimeInterval(response.sunrise)),
                        sunsetTime: Date(timeIntervalSince1970: TimeInterval(response.sunset)),
                        dayTemp: .init(kelvin: response.temp.day),
                        nightTemp: .init(kelvin: response.temp.night),
                        minTemp: .init(kelvin: response.temp.min),
                        maxTemp: .init(kelvin: response.temp.max),
                        eveTemp: .init(kelvin: response.temp.eve),
                        mornTemp: .init(kelvin: response.temp.morn),
                        weatherDetails: response.weather.map { .convert(fromResponse: $0) })
  }
}

struct HourlyWeatherSummary {
  let time: Date
  let actualTemp, feelsLikeTemp: Temperature
  
  let weatherDetails: [WeatherDetails]
  
  static func convert(fromResponse response: HourlyResponse) -> HourlyWeatherSummary {
    HourlyWeatherSummary(time: Date(timeIntervalSince1970: TimeInterval(response.dt)),
                         actualTemp: .init(kelvin: response.temp),
                         feelsLikeTemp: .init(kelvin: response.feelsLike),
                         weatherDetails: response.weather.map { .convert(fromResponse: $0) })
  }
}

struct WeatherDetails {
  let weatherID: Int
  let weatherCondition: String
  let weatherDescription: String
  let weatherIconID: String
  
  static func convert(fromResponse response: WeatherResponse) -> WeatherDetails {
    WeatherDetails(weatherID: response.id,
                   weatherCondition: response.main,
                   weatherDescription: response.weatherDescription,
                   weatherIconID: response.icon)
  }
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
