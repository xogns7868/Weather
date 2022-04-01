//
//  WeatherRepository.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/04/01.
//

import Foundation
import Combine

class WeatherRepository {
    private let locationDataSource: LocationDataSource
    private let weatherDataSource: WeatherDatasource
    
    init(_ locationDataSource: LocationDataSource, _ weatherDataSource: WeatherDatasource) {
        self.locationDataSource = locationDataSource
        self.weatherDataSource = weatherDataSource
    }
    
    func getWeatherSummary(city: String) ->
        AnyPublisher<WeatherSummary, WeatherError> {
        return locationDataSource.getCoordinates(forAddressString: city)
            .flatMap { coordinates in
                self.weatherDataSource.weatherSummary(coordinates: coordinates)
            }.eraseToAnyPublisher()
    }
    
    func getFiveDayWeatherSummary(city: String) ->
        AnyPublisher<FiveDayWeatherSummary, WeatherError> {
        return locationDataSource.getCoordinates(forAddressString: city)
            .flatMap { coordinates in
                self.weatherDataSource.fiveDayWeatherSummary(coordinates: coordinates)
            }.eraseToAnyPublisher()
    }
}
