//
//  SettingsStore.swift
//  Speedtest
//
//  Created by Rodion on 14.04.2024.
//

import Foundation
import SwiftUI
import CoreData

// Получение и сохранение настроек темы, адреса URL, типы скорости
final class SettingsStore {
    static let shared = SettingsStore()
    private var theme: AppTheme
    private var address: String
    private var downloadSpeedIsEnabled: Bool
    private var uploadSpeedIsEnabled: Bool
    private let dataManager: DataManagerRepositoryLogic

    private init(theme: AppTheme = .system,
                 dataManager: DataManagerRepositoryLogic = DataManagerRepository()
    ) {
        self.theme = theme
        self.address = "https://www.google.com"
        self.downloadSpeedIsEnabled = false
        self.uploadSpeedIsEnabled = false
        self.dataManager = dataManager
    }

    func setTheme(with theme: AppTheme) {
        switch theme {
        case .dark:
            self.theme = .dark
            dataManager.saveObject(Theme.self, properties: ["theme": "dark"])
        case .light:
            self.theme = .light
            dataManager.saveObject(Theme.self, properties: ["theme": "light"])
        case .system:
            self.theme = .system
            dataManager.saveObject(Theme.self, properties: ["theme": "system"])
        }
    }

    func getTheme() -> UIUserInterfaceStyle {
        if let dataManagerTheme = dataManager.fetchObjects(Theme.self).last?.theme {
            switch dataManagerTheme {
            case "dark":
                return .dark
            case "light":
                return .light
            case "system":
                return .unspecified
            default:
                return defaultTheme()
            }
        } else {
            return defaultTheme()
        }
    }

    private func defaultTheme() -> UIUserInterfaceStyle {
        switch theme {
        case .dark:
            return .dark
        case .light:
            return .light
        case .system:
            return .unspecified
        }
    }

    func setURL(with address: String) {
        self.address = address
        dataManager.saveObject(URLTask.self, properties: ["url": address])
    }

    func getURL() -> String {
        if let url = dataManager.fetchObjects(URLTask.self).last?.url {
            return url
        } else {
            return address
        }
    }

    func setDownloadSpeed(with isEnabled: Bool) {
        downloadSpeedIsEnabled = isEnabled
        dataManager.saveObject(Speed.self, properties: ["download": isEnabled, "upload": getUploadSpeed()])
    }

    func getDownloadSpeed() -> Bool {
        if let isEnabled = dataManager.fetchObjects(Speed.self).last?.download {
            return isEnabled
        } else {
            return downloadSpeedIsEnabled
        }
    }

    func setUploadSpeed(with isEnabled: Bool) {
        uploadSpeedIsEnabled = isEnabled
        dataManager.saveObject(Speed.self, properties: ["download": getDownloadSpeed(), "upload": isEnabled])
    }

    func getUploadSpeed() -> Bool {
        if let isEnabled = dataManager.fetchObjects(Speed.self).last?.upload {
            return isEnabled
        } else {
            return uploadSpeedIsEnabled
        }
    }
}
