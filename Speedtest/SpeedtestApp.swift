//
//  SpeedtestApp.swift
//  Speedtest
//
//  Created by Rodion on 10.04.2024.
//

import SwiftUI

@main
struct SpeedtestApp: App {
    private var viewModel: SpeedtestAppViewModel = SpeedtestAppViewModel()

    init() { }

    var body: some Scene {
        WindowGroup {
            MainContentView(appDelegate: viewModel)
                .onAppear {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        windowScene.windows.first?.overrideUserInterfaceStyle = viewModel.theme
                    }
                }
                .onReceive(viewModel.$theme) { newTheme in
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        windowScene.windows.first?.overrideUserInterfaceStyle = newTheme
                    }
                }
        }
    }
}
