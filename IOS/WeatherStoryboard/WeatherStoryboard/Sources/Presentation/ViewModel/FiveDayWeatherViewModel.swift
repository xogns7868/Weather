//
//  FiveDayWeatherViewModel.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/15.
//

import Foundation
import Combine

public final class FiveDayWeatherViewModel: ObservableObject {
    private var repository: WeatherRepository!
    private var disposable = Set<AnyCancellable>()
    
    @Published var searchText: String = ""
    @Published var fiveDayWeatherSummary: FiveDayWeatherSummary?
    @Published var selectedWeatherInfo: SelectedWeatherInfo?
    
    //  var currentWeatherIcon: Image? {
    //    weatherSummary?.current.weatherDetails.first?.weatherIcon
    //  }
    
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
        repository.getFiveDayWeatherSummary(city: location)
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
    
    func updateSelectedDate(date: String, temperature: Double) {
        selectedWeatherInfo = SelectedWeatherInfo(dtTxt: date, temperature: temperature)
    }
    
    
    struct SelectedWeatherInfo {
        let dtTxt: String
        let temperature: Double
    }
    
}
