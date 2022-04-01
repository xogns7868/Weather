//
//  WeatherSummaryViewModel.swift
//  WeatherStoryboard
//
//  Created by xogns.7868 on 2022/01/22.
//

import Foundation
import Combine

public final class WeatherSummaryViewModel: ObservableObject {
    private var repository: WeatherRepository!
    private var disposable = Set<AnyCancellable>()
    
    @Published var searchText: String = ""
    @Published var weatherSummary: WeatherSummary?
    
    var currentTempFmt: String {
        guard let temp = weatherSummary?.current.actualTemp.fahrenheight else { return "--º" }
        return String(format: "%.0fº", temp)
    }
    
    var feelsLikeTempFmt: String {
        guard let temp = weatherSummary?.current.feelsLikeTemp.fahrenheight else { return "--º" }
        return String(format: "%.0fº", temp)
    }
    
    var currentTempDescription: String {
        guard let description = weatherSummary?.current.weatherDetails.first?.weatherDescription else {
            return ""
        }
        return description.localizedCapitalized
    }
    
    //  var currentWeatherIcon: Image? {
    //    weatherSummary?.current.weatherDetails.first?.weatherIcon
    //  }
    
    @Published var hourSummaries: [HourSummaryViewModel] = []
    @Published var daySummaries: [DaySummaryViewModel] = []
    
    init(_ repository: WeatherRepository) {
        self.repository = repository
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
        print("weatherSummaryViewModel init")
        repository.getWeatherSummary(city: location)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] (value) in
                switch value {
                case .failure(let error):
                    self?.weatherSummary = nil
                    self?.hourSummaries = []
                    self?.daySummaries = []
                    print(error)
                case .finished:
                    break
                }
            }) { [weak self] weatherSummary in
                self?.weatherSummary = weatherSummary
                self?.hourSummaries = weatherSummary.hourly.map { HourSummaryViewModel(hourSummary: $0) }
                self?.daySummaries = weatherSummary.daily.map { DaySummaryViewModel(daySummary: $0) }
            }.store(in: &disposable)
    }
    
    func todayInformationViewModel() -> CurrentSummaryViewModel? {
        guard let weatherSummary = weatherSummary else { return nil }
        return .init(weatherSummary: weatherSummary.current)
    }
}
