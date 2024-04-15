//
//  StartButtonViewModel.swift
//  Speedtest
//
//  Created by Rodion on 11.04.2024.
//

import Combine

enum StartButtonErrorType {
    case none
    case error
}

//MARK: - Начальный экран с кнопкой Начать

class StartButtonModel: ObservableObject {
    @Published var isPressed: Bool
    @Published var error: StartButtonErrorType
    private let settingsStore: SettingsStoreRepositoryLogic

    init(isPressed: Bool = false,
         settingsStore: SettingsStoreRepositoryLogic = SettingsStoreRepository(),
         error: StartButtonErrorType = .none
    ) {
        self.isPressed = isPressed
        self.settingsStore = settingsStore
        self.error = error
    }

    func buttonPressed() {
        // Проверка включены ли тоглы скорость загрузки, скорость отдачи
        switch (settingsStore.getUploadSpeed(), settingsStore.getDownloadSpeed()) {
        case (true, _):
            error = .none
            isPressed.toggle()
        case (false, true):
            error = .none
            isPressed.toggle()
        case (false, false):
            error = .error
        }
    }

    func alertHide() {
        error = .none
    }
}
