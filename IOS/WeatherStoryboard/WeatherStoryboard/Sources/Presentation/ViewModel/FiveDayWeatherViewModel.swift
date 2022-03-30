//
//  FiveDayWeatherViewModel.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/15.
//

import Foundation
import Combine

class FiveDayWeatherViewModel: ObservableObject {
  private var weatherFetcher: WeatherFetcher
  private var disposable = Set<AnyCancellable>()
  
  @Published var searchText: String = ""
  @Published var fiveDayWeatherSummary: FiveDayWeatherSummary?
  
//  var currentWeatherIcon: Image? {
//    weatherSummary?.current.weatherDetails.first?.weatherIcon
//  }
  
  init(weatherFetcher: WeatherFetcher) {
    self.weatherFetcher = weatherFetcher
    
    let searchTextScheduler: DispatchQueue = .init(label: "weatherSearch", qos: .userInteractive)
    $searchText
      .dropFirst()
      .debounce(for: .seconds(0.5),
                scheduler: searchTextScheduler)
      .sink(receiveValue: fetchWeatherSummary(forLocation:))
      .store(in: &disposable)
    
    fetchWeatherSummary(forLocation: searchText)
  }
  
  func fetchWeatherSummary(forLocation location: String) {
    weatherFetcher.fiveDayWeatherSummary(forCity: location)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] (value) in
        switch value {
        case .failure(let error):
            self?.fiveDayWeatherSummary = nil
          print(error)
        case .finished:
          break
        }
      }) { [weak self] fiveDayWeatherSummary in
        self?.fiveDayWeatherSummary = fiveDayWeatherSummary
    }.store(in: &disposable)
  }
}
