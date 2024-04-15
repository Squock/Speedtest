//
//  SpeedContentView.swift
//  Speedtest
//
//  Created by Rodion on 10.04.2024.
//

import SwiftUI

struct SpeedContentView: View {
    @ObservedObject var viewModel: SpeedViewModel
    @State private var isSpeedometrVisible = false
    private let localization: SpeedLocalization

    init(
        viewModel: SpeedViewModel = .init(),
        localization: SpeedLocalization = .init()
    ) {
        self.viewModel = viewModel
        self.localization = localization
    }

    var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.viewType {
                case .speedometr:
                    if isSpeedometrVisible {
                        SpeedometrContentView()
                    }
                case .start:
                    StartButtonContentView(viewModel: viewModel.startViewModel)
                }
            }
            .navigationTitle(localization.title)
            .onReceive(viewModel.objectWillChange, perform: { _ in
                withAnimation {
                    self.isSpeedometrVisible = self.viewModel.startViewModel.isPressed
                }
            })
        }
    }
}

#Preview {
    SpeedContentView(viewModel: .init())
}
