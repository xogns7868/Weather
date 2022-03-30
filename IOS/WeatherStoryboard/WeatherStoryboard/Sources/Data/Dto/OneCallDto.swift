//
//  OneCallDto.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/30.
//

import Foundation

struct OneCallDto: Codable {
    let lat, lon: Double
    let timezone: String
    let current: CurrentDto
    let hourly: [HourlyDto]
    let daily: [DailyDto]
}

struct CurrentDto: Codable {
  let dt, sunrise, sunset: Int
  let temp, feelsLike: Double
  let pressure, humidity: Int
  let uvi: Double
  let clouds, visibility: Int?
  let windSpeed: Double
  let windDeg: Int
  let weather: [WeatherDto]
  let rain: RainDto?
  
  enum CodingKeys: String, CodingKey {
    case dt, sunrise, sunset, temp
    case feelsLike = "feels_like"
    case pressure, humidity, uvi, clouds, visibility
    case windSpeed = "wind_speed"
    case windDeg = "wind_deg"
    case weather, rain
  }
}

// MARK: - DailyResponse
struct DailyDto: Codable {
  let dt, sunrise, sunset: Int
  let temp: TempDto
  let feelsLike: FeelsLikeDto
  let pressure, humidity: Int
  let windSpeed: Double
  let windDeg: Int
  let weather: [WeatherDto]
  let clouds: Int
  let rain: Double?
  let uvi: Double
  
  enum CodingKeys: String, CodingKey {
    case dt, sunrise, sunset, temp
    case feelsLike = "feels_like"
    case pressure, humidity
    case windSpeed = "wind_speed"
    case windDeg = "wind_deg"
    case weather, clouds, rain, uvi
  }
}

// MARK: - FeelsLikeResponse
struct FeelsLikeDto: Codable {
  let day, night, eve, morn: Double
}

// MARK: - TempResponse
struct TempDto: Codable {
  let day, min, max, night: Double
  let eve, morn: Double
}

// MARK: - HourlyResponse
struct HourlyDto: Codable {
  let dt: Int
  let temp, feelsLike: Double
  let pressure, humidity, clouds: Int
  let windSpeed: Double
  let windDeg: Int
  let weather: [WeatherDto]
  let rain: RainDto?
  
  enum CodingKeys: String, CodingKey {
    case dt, temp
    case feelsLike = "feels_like"
    case pressure, humidity, clouds
    case windSpeed = "wind_speed"
    case windDeg = "wind_deg"
    case weather, rain
  }
}
