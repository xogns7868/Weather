//
//  RainDto.swift
//  WeatherStoryboard
//
//  Created by tom.7868 on 2022/03/30.
//

import Foundation

// MARK: - Rain
struct RainDto: Codable {
    let the1H: Double
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
        case the3H = "3h"
    }
}
