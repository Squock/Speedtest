//
//  SpeedViewModel.swift
//  Speedtest
//
//  Created by Rodion on 11.04.2024.
//

import Foundation
import Combine

enum SpeedViewType {
    case speedometr
    case start
}

// MARK: - окно спидометра, либо кнопки Начать

final class SpeedViewModel: ObservableObject {
    @Published var startViewModel: StartButtonModel
    @Published var speedometrViewModel: SpeedometrViewModel
    @Published var viewType: SpeedViewType

    private var cancellables = Set<AnyCancellable>()
    
    init(
        startButtonViewModel: StartButtonModel = .init(),
        speedometrViewModel: SpeedometrViewModel = .init(),
        viewType: SpeedViewType = .start
    ) {
        self.startViewModel = startButtonViewModel
        self.viewType = viewType
        self.speedometrViewModel = speedometrViewModel
        startButtonViewModelObservable()
    }

    // Если пользователь нажал кнопку Начать
    private func startButtonViewModelObservable() {
        startViewModel.$isPressed
            .sink(receiveValue: { [weak self] isPressed in
                if isPressed {
                    self?.viewType = .speedometr
                } else {
                    self?.viewType = .start
                }
                self?.objectWillChange.send()
            })
            .store(in: &cancellables)
    }
}
