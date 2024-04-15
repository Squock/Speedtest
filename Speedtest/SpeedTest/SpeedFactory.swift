//
//  SpeedFactory.swift
//  Speedtest
//
//  Created by Rodion on 11.04.2024.
//

import Foundation

struct SpeedFactory {
    func build() -> SpeedContentView {
        let viewModel = SpeedViewModel(startButtonViewModel: makeStartButtonModel())
        return SpeedContentView(viewModel: viewModel)
    }

    func makeStartButtonModel() -> StartButtonModel {
        StartButtonModel(isPressed: false)
    }
}
