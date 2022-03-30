//
//  ModelConverter.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/30.
//

import Foundation

extension OneCallDto {
    func toWeatherSummary() -> WeatherSummary {
        WeatherSummary(latitude: self.lat,
                       longitude: self.lon,
                       timezone: self.timezone,
                       current: self.current.toCurrentWeatherSummary(),
                       daily: self.daily.map { $0.toDailyWeatherSummary() },
                       hourly: self.hourly.map { $0.toHoulryWeatherSummary() })
    }
}

extension CurrentDto {
    func toCurrentWeatherSummary() -> CurrentWeatherSummary {
        CurrentWeatherSummary(time: Date(timeIntervalSince1970: TimeInterval(dt)),
                              sunriseTime: Date(timeIntervalSince1970: TimeInterval(sunrise)),
                              sunsetTime: Date(timeIntervalSince1970: TimeInterval(sunset)),
                              actualTemp: .init(kelvin: temp),
                              feelsLikeTemp: .init(kelvin: feelsLike),
                              pressure: pressure,
                              humidity: humidity,
                              uvIndex: uvi,
                              windSpeed: windSpeed,
                              windAngle: windDeg,
                              weatherDetails: weather.map { $0.toWeatherDetails() })
    }
}

extension DailyDto {
    func toDailyWeatherSummary() -> DailyWeatherSummary {
        DailyWeatherSummary(
            time: Date(timeIntervalSince1970: TimeInterval(self.dt)),
            sunriseTime: Date(timeIntervalSince1970: TimeInterval(self.sunrise)),
            sunsetTime: Date(timeIntervalSince1970: TimeInterval(self.sunset)),
            dayTemp: .init(kelvin: self.temp.day),
            nightTemp: .init(kelvin: self.temp.night),
            minTemp: .init(kelvin: self.temp.min),
            maxTemp: .init(kelvin: self.temp.max),
            eveTemp: .init(kelvin: self.temp.eve),
            mornTemp: .init(kelvin: self.temp.morn),
            weatherDetails: self.weather.map { $0.toWeatherDetails() })
    }
}

extension HourlyDto {
    func toHoulryWeatherSummary() -> HourlyWeatherSummary {
        HourlyWeatherSummary(time: Date(timeIntervalSince1970: TimeInterval(self.dt)),
                             actualTemp: .init(kelvin: self.temp),
                             feelsLikeTemp: .init(kelvin: self.feelsLike),
                             weatherDetails: self.weather.map { $0.toWeatherDetails() })
    }
}

extension WeatherDto {
    func toWeatherDetails() -> WeatherDetails {
          WeatherDetails(weatherID: self.id,
                         weatherCondition: self.main,
                         weatherDescription: self.weatherDescription,
                         weatherIconID: self.icon)
    }
}

extension FiveDayWeatherDto {
    func toFiveDayWeatherSummary() -> FiveDayWeatherSummary {
        FiveDayWeatherSummary(threeHourly: self.list.map { $0.toThreeHourlySummary() })
    }
}

extension ThreeHourlyDto {
    func toThreeHourlySummary() -> ThreeHourlySummary {
        ThreeHourlySummary(
            dt: self.dt,
            weather: self.weather.map { $0.toWeatherDetails() },
            temp: .init(kelvin: self.main.temp),
            dtTxt: self.dtTxt,
            rain: self.rain?.the3H
        )
    }
}


