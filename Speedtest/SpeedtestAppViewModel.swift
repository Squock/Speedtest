//
//  SpeedtestAppViewModel.swift
//  Speedtest
//
//  Created by Rodion on 14.04.2024.
//

import Foundation
import SwiftUI

protocol SpeedtestAppViewModelLogic {
    func setTheme(with theme: UIUserInterfaceStyle)
}

final class SpeedtestAppViewModel: ObservableObject {
    @Published var theme: UIUserInterfaceStyle
    private let settingsRepository: SettingsStoreRepositoryLogic

    init(settingsRepository: SettingsStoreRepositoryLogic = SettingsStoreRepository()) {
        theme = settingsRepository.getTheme()
        self.settingsRepository = settingsRepository
    }
}

extension SpeedtestAppViewModel: SpeedtestAppViewModelLogic {
    func setTheme(with theme: UIUserInterfaceStyle) {
        self.theme = theme
    }
}
