//
//  SpeedometrViewModel.swift
//  Speedtest
//
//  Created by Rodion on 11.04.2024.
//

import Foundation
import Combine

// Константы для спидометра
enum SpeedometrViewConstants {
    static let circleMinimum: Double = 0.0
    static let circleMaximum: Double = 0.7
    static let arrowDegressMinimum: Double = 0
    static let arrowDegressMaximum: Double = -105
    static let maximum: Double = 100.0
}

enum SpeedometrViewRouter {
    case result
    case main
}

// MARK: - Экран со спидометром

struct SpeedometrViewDataSource {
    var currentPercent: Int
    var domainURL: String
    private let settingsStore: SettingsStoreRepositoryLogic

    init(currentPercent: Int = .zero,
         domainURL: String = "",
         settingsStore: SettingsStoreRepositoryLogic = SettingsStoreRepository()
    ) {
        self.currentPercent = currentPercent
        self.domainURL = settingsStore.getURL()
        self.settingsStore = settingsStore
    }
}

final class SpeedometrViewModel: ObservableObject  {
    private let networkSpeedRepository: NetworkSpeedRepositoryLogic
    private let settingsStore: SettingsStoreRepositoryLogic
    private var dataSource: SpeedometrViewDataSource {
        didSet {
            render()
        }
    }
    @Published var arrowValue: Double
    @Published var circleValue: Double
    @Published var speedometrValue: String
    @Published var domainURL: String
    @Published var downloadSpeed: String = ""
    @Published var uploadSpeed: String = ""
    @Published var router: SpeedometrViewRouter
    @Published var resultViewModel: ResultViewModel

    init(
        networkSpeedRepository: NetworkSpeedRepositoryLogic = NetworkSpeedRepository(dataSource: .init(url: SettingsStore.shared.getURL())),
        arrowValue: Double = SpeedometrViewConstants.arrowDegressMinimum,
        circleValue: Double = SpeedometrViewConstants.circleMinimum,
        speedometrValue: String = "",
        dataSource: SpeedometrViewDataSource = .init(),
        settingsStore: SettingsStoreRepositoryLogic = SettingsStoreRepository(),
        resultViewModel: ResultViewModel = .init()
    ) {
        self.router = .main
        self.networkSpeedRepository = networkSpeedRepository
        self.arrowValue = arrowValue
        self.circleValue = circleValue
        self.speedometrValue = speedometrValue
        self.dataSource = dataSource
        self.domainURL = dataSource.domainURL
        self.settingsStore = settingsStore
        self.resultViewModel = resultViewModel
    }

    func start() {
        // Старт спидометра, проверка тоглов скорость загрузки, скорость отдачи
        switch (settingsStore.getDownloadSpeed(), settingsStore.getUploadSpeed()) {
        case (true, _):
            startDownloadSpeed()
        case (false, true):
            startUploadSpeed()
        case (false, false):
            debugPrint("Error: Download speed and upload speed == false")
        }
    }
}

private extension SpeedometrViewModel {
    func startDownloadSpeed() {
        networkSpeedRepository.startDownloadSpeed(completion: { [weak self] result, isEnd in
            guard let self = self, let result = result else {
                self?.clean()
                // При завершении измерения скорости проверка вкл скорость отдачи
                if let isEnabled = self?.settingsStore.getUploadSpeed(), isEnabled {
                    self?.startUploadSpeed()
                } else {
                    // отображение результата
                    self?.router = .result
                    self?.objectWillChange.send()
                }
                return
            }
            
            // Проверка на максимум значения спидометра, если значение больше или равно масимального значения, то по дефолту считаем, что 100%
            let value: Int
            if result < SpeedometrViewConstants.maximum {
                value = doubleToInt(value: SpeedometrViewConstants.maximum * result / 100)
            } else {
                value = 100
            }
            dataSource.currentPercent = value
            speedometrValue = "Download speed: \(doubleToInt(value: result)) KB/s"
            downloadSpeed = speedometrValue
        })
    }

    func startUploadSpeed() {
        networkSpeedRepository.startUploadSpeed(completion: { [weak self] result, isEnd in
            guard let self = self, let result = result else {
                self?.clean()
                self?.router = .result
                self?.objectWillChange.send()
                return
            }
            
            // Проверка на максимум значения спидометра, если значение больше или равно масимального значения, то по дефолту считаем, что 100%, так же отображаем значение спидометра
            let value: Int
            if result < SpeedometrViewConstants.maximum {
                value = doubleToInt(value: SpeedometrViewConstants.maximum * result / 100)
            } else {
                value = 100
            }
            dataSource.currentPercent = value
            speedometrValue = "Upload speed: \(doubleToInt(value: result)) KB/s"
            uploadSpeed = speedometrValue
        })
    }
}

private extension SpeedometrViewModel {
    func clean() {
        resultViewModel.downloadText = downloadSpeed
        resultViewModel.uploadText = uploadSpeed
        arrowValue = SpeedometrViewConstants.arrowDegressMinimum
        circleValue = SpeedometrViewConstants.circleMinimum
    }

    func doubleToInt(value: Double) -> Int {
        Int(value)
    }

    func calculateArrowState() {
        // Эта функция вычисляет угол, на который должна быть повернута стрелка на спидометре в зависимости от текущего процента
        let angleRange = SpeedometrViewConstants.arrowDegressMaximum - SpeedometrViewConstants.arrowDegressMinimum
        let maxValue = 360 - SpeedometrViewConstants.arrowDegressMinimum + angleRange

        let percent = Double(dataSource.currentPercent)
        let value = (maxValue * percent) / 100

        arrowValue = value
    }

    func calculateCircleState() {
        // Эта функция вычисляет состояние круга на скоростномомере в зависимости от текущего процента
        let temp = SpeedometrViewConstants.circleMaximum - SpeedometrViewConstants.circleMinimum
        let value = temp * Double(dataSource.currentPercent) / 100
        circleValue = value
    }

    func render() {
        calculateArrowState()
        calculateCircleState()
    }
}
