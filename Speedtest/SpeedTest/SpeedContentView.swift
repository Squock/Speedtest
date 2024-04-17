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
            VStack {
                NavigationLink(destination: SpeedometrContentView(), isActive: $isSpeedometrVisible) {
                    EmptyView()
                }
                .frame(width: 0, height: 0)
                .opacity(0)
                StartButtonContentView(viewModel: viewModel.startViewModel)
            }
            .navigationTitle(localization.title)
            .onReceive(viewModel.objectWillChange) { _ in
                withAnimation {
                    self.isSpeedometrVisible = self.viewModel.startViewModel.isPressed
                }
            }
        }
    }
}

#Preview {
    SpeedContentView(viewModel: .init())
}
