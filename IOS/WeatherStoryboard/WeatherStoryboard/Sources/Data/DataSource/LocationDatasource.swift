//
//  LocationDatasource.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/30.
//

import Foundation
import CoreLocation
import Combine

func getCoordinates(forAddressString addressString: String) -> AnyPublisher<CLLocationCoordinate2D, WeatherError> {
  let geocoder = CLGeocoder()
  return Future<CLLocationCoordinate2D, WeatherError> { promise in
    geocoder.geocodeAddressString(addressString) { placemarks, error in
      if let error = error {
        print(error)
        promise(.failure(WeatherError.location(message: error.localizedDescription)))
        return
      }
      guard let location = placemarks?.first?.location else {
        promise(.failure(WeatherError.location(message: "Could not find location for \(addressString)")))
        return
      }
      promise(.success(location.coordinate))
    }
  }.eraseToAnyPublisher()
}
