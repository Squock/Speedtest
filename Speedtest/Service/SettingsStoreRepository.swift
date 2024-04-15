//
//  SettingsStoreRepository.swift
//  Speedtest
//
//  Created by Rodion on 15.04.2024.
//

import Foundation
import SwiftUI

protocol SettingsStoreRepositoryLogic {
    func setTheme(with theme: AppTheme)
    func getTheme() -> UIUserInterfaceStyle
    func setURL(with address: String)
    func getURL() -> String
    func setDownloadSpeed(with isEnabled: Bool)
    func getDownloadSpeed() -> Bool
    func setUploadSpeed(with isEnabled: Bool)
    func getUploadSpeed() -> Bool
}

// Оберетка для использования SettingsStore в других классах
final class SettingsStoreRepository: SettingsStoreRepositoryLogic {
    private let settingStore: SettingsStore

    init(settingStore: SettingsStore = SettingsStore.shared) {
        self.settingStore = settingStore
    }

    func setTheme(with theme: AppTheme) {
        settingStore.setTheme(with: theme)
    }

    func getTheme() -> UIUserInterfaceStyle {
        settingStore.getTheme()
    }
    
    func setURL(with address: String) {
        settingStore.setURL(with: address)
    }
    
    func getURL() -> String {
        settingStore.getURL()
    }
    
    func setDownloadSpeed(with isEnabled: Bool) {
        settingStore.setDownloadSpeed(with: isEnabled)
    }
    
    func getDownloadSpeed() -> Bool {
        settingStore.getDownloadSpeed()
    }
    
    func setUploadSpeed(with isEnabled: Bool) {
        settingStore.setUploadSpeed(with: isEnabled)
    }
    
    func getUploadSpeed() -> Bool {
        settingStore.getUploadSpeed()
    }
}
