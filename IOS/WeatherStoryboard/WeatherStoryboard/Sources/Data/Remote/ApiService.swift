//
//  ApiService.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/30.
//

import Foundation
import CoreLocation
import Combine

struct OpenWeatherAPI {
  static let scheme: String = "https"
  static let host: String = "api.openweathermap.org"
  static let path: String = "/data/2.5"
  static var key: String = "d22fbc2fb53f26b8af8a176e4f9d986d"
}

func makeWeatherSummaryComponents(withCoordinates coordinates: CLLocationCoordinate2D) -> URLComponents {
  var components = URLComponents()
  components.scheme = OpenWeatherAPI.scheme
  components.host = OpenWeatherAPI.host
  components.path = OpenWeatherAPI.path + "/onecall"
  
  components.queryItems = [
    .init(name: "lat", value: "\(coordinates.latitude)"),
    .init(name: "lon", value: "\(coordinates.longitude)"),
    .init(name: "appid", value: OpenWeatherAPI.key)]
  
  return components
}

func makeFiveDayWeatherSummaryComponents(withCoordinates coordinates: CLLocationCoordinate2D) -> URLComponents {
    var components = URLComponents()
    components.scheme = OpenWeatherAPI.scheme
    components.host = OpenWeatherAPI.host
    components.path = OpenWeatherAPI.path + "/forecast"
    
    components.queryItems = [
      .init(name: "lat", value: "\(coordinates.latitude)"),
      .init(name: "lon", value: "\(coordinates.longitude)"),
      .init(name: "appid", value: OpenWeatherAPI.key)]
    
    return components
}
