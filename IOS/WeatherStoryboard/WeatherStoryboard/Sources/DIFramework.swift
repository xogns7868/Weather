//
//  DIFramework.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/04/01.
//

import Foundation

public class DIFramework {
    private let weatherDataSource = WeatherDatasource()
    private let locationDataSource = LocationDataSource()
    
    static let shared = DIFramework()
    
    public func getWeatherSummaryViewModel() -> WeatherSummaryViewModel {
        let weatherRepository = WeatherRepository(
            self.locationDataSource,
            self.weatherDataSource
        )
        return WeatherSummaryViewModel(weatherRepository)
    }
    
    public func getFiveDayWeatherSummaryViewModel() -> FiveDayWeatherViewModel {
        let weatherRepository = WeatherRepository(
            self.locationDataSource,
            self.weatherDataSource
        )
        return FiveDayWeatherViewModel(weatherRepository)
    }
}
