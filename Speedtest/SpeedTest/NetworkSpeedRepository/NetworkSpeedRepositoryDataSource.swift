//
//  NetworkSpeedRepositoryDataSource.swift
//  Speedtest
//
//  Created by Rodion on 11.04.2024.
//

import Foundation

// Настройка репозитория, измерения скорости соединения
struct NetworkSpeedRepositoryDataSource {
    let url: String
    let delay: Double
    let interval: Double

    init(
        url: String = "",
        delay: Double = 10,
        interval: Double = 0.1
    ) {
        self.url = url
        self.delay = delay
        self.interval = interval
    }
}
