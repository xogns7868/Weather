//
//  FiveDayWeatherSummary.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/13.
//

import Foundation

struct FiveDayWeatherSummary {
    let threeHourly: [ThreeHourlySummary]
    
    static func convert(fromResponse response: FiveDayWeatherResponse) -> FiveDayWeatherSummary {
        FiveDayWeatherSummary(threeHourly: response.list.map { threeHourlyResponse in ThreeHourlySummary.convert(fromResponse: threeHourlyResponse)
        }
        )
    }
}

struct ThreeHourlySummary {
    let dt: Int
    let weather: [WeatherDetails]
    let temp: Double
    let dtTxt: String
    let rain: Double?
    
    static func convert(fromResponse response: ThreeHourlyResponse) -> ThreeHourlySummary {
        ThreeHourlySummary(
            dt: response.dt,
            weather: response.weather.map { weatherResponse in
                WeatherDetails.convert(fromResponse: weatherResponse)
            },
            temp: response.main.temp,
            dtTxt: response.dtTxt,
            rain: response.rain?.the3H
        )
    }
    
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
      
        static func convert(fromResponse response: Weather) -> WeatherDetails {
        WeatherDetails(weatherID: response.id,
                       weatherCondition: response.main.rawValue,
                       weatherDescription: response.weatherDescription,
                       weatherIconID: response.icon)
      }
    }

}
