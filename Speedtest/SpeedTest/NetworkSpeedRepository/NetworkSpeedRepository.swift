//
//  NetworkSpeedRepository.swift
//  Speedtest
//
//  Created by Rodion on 11.04.2024.
//

import Foundation
import Alamofire

protocol NetworkSpeedRepositoryLogic: AnyObject {
    func startDownloadSpeed(completion: @escaping (Double?, Bool) -> Void)
    func startUploadSpeed(completion: @escaping (Double?, Bool) -> Void)
}

// Репозиторий для отправки запросов и измерения скорости соединения

final class NetworkSpeedRepository: NetworkSpeedRepositoryLogic {
    private let dataSource: NetworkSpeedRepositoryDataSource
    private let settingsStore: SettingsStore
    
    init(dataSource: NetworkSpeedRepositoryDataSource = .init(),
         settingsStore: SettingsStore = SettingsStore.shared
    ) {
        self.dataSource = dataSource
        self.settingsStore = settingsStore
    }
    
    func startDownloadSpeed(completion: @escaping (Double?, Bool) -> Void) {
        let timer = Timer.scheduledTimer(withTimeInterval: dataSource.interval, repeats: true) { [weak self] timer in
            self?.measureDownloadSpeed(completion: { result, err in
                if let err = err {
                    completion(nil, true)
                    timer.invalidate()
                } else if let result = result {
                    completion(result, false)
                }
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + dataSource.delay) {
            completion(nil, true)
            timer.invalidate()
        }
    }
    
    func startUploadSpeed(completion: @escaping (Double?, Bool) -> Void) {
        let timer = Timer.scheduledTimer(withTimeInterval: dataSource.interval, repeats: true) { [weak self] timer in
            self?.measureUploadSpeed(completion: { result, err in
                if let err = err {
                    completion(nil, true)
                    timer.invalidate()
                } else if let result = result {
                    completion(result, false)
                }
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + dataSource.delay) {
            completion(nil, true)
            timer.invalidate()
        }
    }
}

extension NetworkSpeedRepository {
    func measureDownloadSpeed(completion: @escaping (Double?, Error?) -> Void) {
        let start = Date()
        
        AF.request(settingsStore.getURL())
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let end = Date()
                    let timeInterval = end.timeIntervalSince(start)
                    let dataSize = Double(data.count) // Размер загруженных данных
                    let speed = dataSize / timeInterval / 1024.0 // Переводим в килобайты в секунду
                    completion(speed, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    func measureUploadSpeed(completion: @escaping (Double?, Error?) -> Void) {
        let start = Date()
        let testData = "Test Data to upload url check"
        guard let testDataEncoded = testData.data(using: .utf8) else {
            completion(nil, NSError(domain: "EncodingError", code: -1, userInfo: nil))
            return
        }
        AF.upload(testDataEncoded, to: settingsStore.getURL())
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let end = Date()
                    let timeInterval = end.timeIntervalSince(start)
                    let dataSize = Double(data.count) // Размер загруженных данных
                    let speed = dataSize / timeInterval / 1024 // Переводим в килобайты в секунду
                    completion(speed, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
}
