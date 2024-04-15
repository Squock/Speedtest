//
//  ContentView.swift
//  Speedtest
//
//  Created by Rodion on 10.04.2024.
//

import SwiftUI

struct MainContentView: View {
    private let localization: MainLocalization
    private let appDelegate: SpeedtestAppViewModelLogic

    init(localization: MainLocalization = .init(), 
         appDelegate: SpeedtestAppViewModelLogic = SpeedtestAppViewModel()
    ) {
        self.localization = localization
        self.appDelegate = appDelegate
    }

    var body: some View {
        TabView {
            SpeedFactory().build()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text(localization.tab1)
                }
            SettingsContentView(viewModel: .init(appDelegate: appDelegate))
                .tabItem {
                    Image(systemName: "2.circle")
                    Text(localization.tab2)
                }
         }
    }
}

#Preview {
    MainContentView()
}
