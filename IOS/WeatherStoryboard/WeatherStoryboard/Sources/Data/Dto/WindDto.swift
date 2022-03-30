//
//  WindDto.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/30.
//

import Foundation

// MARK: - Wind
struct WindDto: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
