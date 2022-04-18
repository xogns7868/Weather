//
//  FiveDayWeatherResponse.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/13.

import Foundation

// MARK: - FiveDayWeather
struct FiveDayWeatherDto: Codable {
    let cod: String
    let message, cnt: Int
    let list: [ThreeHourlyDto]
    let city: CityDto
}

// MARK: - City
struct CityDto: Codable {
    let id: Int
    let name: String
    let coord: CoordDto
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord

// MARK: - List
struct ThreeHourlyDto: Codable {
    let dt: Int
    let main: MainClassDto
    let weather: [WeatherDto]
    let clouds: Clouds
    let wind: WindDto
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dtTxt: String
    let rain, snow: Rain3HDto?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain, snow
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - MainClass
struct MainClassDto: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}
