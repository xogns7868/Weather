//
//  WeatherDatasource.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/30.
//

import Foundation
import Combine

protocol WeatherFetcher {
  func weatherSummary(forCity city: String) -> AnyPublisher<WeatherSummary, WeatherError>
    
    func fiveDayWeatherSummary(forCity city: String) -> AnyPublisher<FiveDayWeatherSummary, WeatherError>
}

class WeatherDatasource: WeatherFetcher {
    let session: URLSession
    
    init(session: URLSession = .init(configuration: .default)) {
      self.session = session
    }
    
    func weatherSummary(forCity city: String) -> AnyPublisher<WeatherSummary, WeatherError> {
      getCoordinates(forAddressString: city)
        .flatMap { [weak self] coordinates -> AnyPublisher<URLSession.DataTaskPublisher.Output, WeatherError> in
          guard let self = self,
            let url = makeWeatherSummaryComponents(withCoordinates: coordinates).url else {
              return Fail(error: WeatherError.network(message: "Could not create URL"))
                .eraseToAnyPublisher()
          }
          return self.session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { WeatherError.network(message: $0.localizedDescription) }
            .eraseToAnyPublisher()
        }.flatMap { pair in
          Just(pair.data)
            .decode(type: OneCallDto.self, decoder: JSONDecoder())
            .mapError { error in
              WeatherError.parsing(message: error.localizedDescription)
            }.map { response in
              response.toWeatherSummary()
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
      
      func fiveDayWeatherSummary(forCity city: String) -> AnyPublisher<FiveDayWeatherSummary, WeatherError> {
        getCoordinates(forAddressString: city)
          .flatMap { [weak self] coordinates ->
              AnyPublisher<URLSession.DataTaskPublisher.Output, WeatherError> in
            guard let self = self,
              let url = makeFiveDayWeatherSummaryComponents(withCoordinates: coordinates).url else {
                return Fail(error: WeatherError.network(message: "Could not create URL"))
                  .eraseToAnyPublisher()
            }
            return self.session.dataTaskPublisher(for: URLRequest(url: url))
              .mapError { WeatherError.network(message: $0.localizedDescription) }
              .eraseToAnyPublisher()
          }.flatMap { pair in
            Just(pair.data)
              .decode(type: FiveDayWeatherDto.self, decoder: JSONDecoder())
              .mapError { error in
                  WeatherError.parsing(message: "\(error)")
              }.map { response in
                  response.toFiveDayWeatherSummary()
              }.eraseToAnyPublisher()
          }.eraseToAnyPublisher()
      }
}
