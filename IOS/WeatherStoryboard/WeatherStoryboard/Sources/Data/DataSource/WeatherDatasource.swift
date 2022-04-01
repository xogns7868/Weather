//
//  WeatherDatasource.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/30.
//

import Foundation
import CoreLocation
import Combine

protocol WeatherFetcher {
    func weatherSummary(coordinates: CLLocationCoordinate2D) -> AnyPublisher<WeatherSummary, WeatherError>
    
    func fiveDayWeatherSummary(coordinates: CLLocationCoordinate2D) -> AnyPublisher<FiveDayWeatherSummary, WeatherError>
}

class WeatherDatasource: WeatherFetcher {
    let session: URLSession
    
    init(session: URLSession = .init(configuration: .default)) {
        self.session = session
    }
    
    func weatherSummary(coordinates: CLLocationCoordinate2D) -> AnyPublisher<WeatherSummary, WeatherError> {
        guard let url = makeWeatherSummaryComponents(withCoordinates: coordinates).url else {
            return Fail(error: WeatherError.network(message: "Could not create URL"))
                .eraseToAnyPublisher()
        }
        return self.session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { WeatherError.network(message: $0.localizedDescription)
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
    
    func fiveDayWeatherSummary(coordinates: CLLocationCoordinate2D) -> AnyPublisher<FiveDayWeatherSummary, WeatherError> {
        guard let url = makeWeatherSummaryComponents(withCoordinates: coordinates).url else {
            return Fail(error: WeatherError.network(message: "Could not create URL"))
                .eraseToAnyPublisher()
        }
        return self.session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { WeatherError.network(message: $0.localizedDescription)
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
