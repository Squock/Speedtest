//
//  SettingsViewModel.swift
//  Speedtest
//
//  Created by Rodion on 13.04.2024.
//

import Foundation

enum AppTheme: String {
    case dark = "Темная"
    case light = "Светлая"
    case system = "Системная"
}

enum SpeedCheckBox {
    case speedDownload
    case speedRecoil
}

struct SettingsDataSource {
    var selectedTheme: AppTheme
    var url: String
    var selectedCheckBox: [SpeedCheckBox]
}

enum SettingsError {
    case none
    case invalidURL
}

// MARK: - Окно настроек

class SettingsViewModel: ObservableObject {
    @Published var theme: [AppTheme] // Массив тем кнопок
    @Published var url: String
    @Published var checkBox: [SpeedCheckBox] // Массив типов измерения скорости
    @Published var isDownloadSpeedToggled: Bool
    @Published var isUploadSpeedToggled: Bool
    @Published var error: SettingsError
    private let appDelegate: SpeedtestAppViewModelLogic
    private let settingsStore: SettingsStoreRepositoryLogic

    init(theme: [AppTheme] = [.dark, .light, .system],
         url: String = "",
         checkBox: [SpeedCheckBox] = [.speedDownload, .speedRecoil],
         appDelegate: SpeedtestAppViewModelLogic = SpeedtestAppViewModel(),
         settingsStore: SettingsStoreRepositoryLogic = SettingsStoreRepository()
    ) {
        self.theme = theme
        self.url = settingsStore.getURL()
        self.checkBox = checkBox
        self.appDelegate = appDelegate
        self.settingsStore = settingsStore
        self.error = .none
        isDownloadSpeedToggled = settingsStore.getDownloadSpeed()
        isUploadSpeedToggled = settingsStore.getUploadSpeed()
    }

    func themeButtonDidTap(with theme: AppTheme) {
        switch theme {
        case .dark:
            appDelegate.setTheme(with: .dark)
        case .light:
            appDelegate.setTheme(with: .light)
        case .system:
            appDelegate.setTheme(with: .unspecified)
        }
        settingsStore.setTheme(with: theme)
    }

    func setAddressURL(with value: String) {
        if isValidHTTPURL(value) {
            settingsStore.setURL(with: value)
            url = value
            error = .none
        } else {
            error = .invalidURL
        }
    }

    func downloadSpeedEnabled(isEnabled: Bool) {
        settingsStore.setDownloadSpeed(with: isEnabled)
    }

    func uploadSpeedEnabled(isEnabled: Bool) {
        settingsStore.setUploadSpeed(with: isEnabled)
    }

    func alertHide() {
        error = .none
    }

    // Валидация на корректность ввода адреса URL
    private func isValidHTTPURL(_ urlString: String) -> Bool {
        let urlRegex = #"(?i)^(https?://)?(?:www\.)?[a-z0-9-]+\.[a-z]{2,}(?:/[\w-./?%&=]*)?$"#
        let urlPredicate = NSPredicate(format: "SELF MATCHES %@", urlRegex)
        return urlPredicate.evaluate(with: urlString)
    }
}
