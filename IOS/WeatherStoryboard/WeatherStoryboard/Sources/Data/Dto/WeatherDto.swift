//
//  WeatherDto.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/30.
//

import Foundation

struct WeatherDto: Codable {
  let id: Int
  let main, weatherDescription, icon: String
  
  enum CodingKeys: String, CodingKey {
    case id, main
    case weatherDescription = "description"
    case icon
  }
}
