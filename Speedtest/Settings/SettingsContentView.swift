//
//  SettingsContentView.swift
//  Speedtest
//
//  Created by Rodion on 10.04.2024.
//

import SwiftUI

struct SettingsContentView: View {
    @ObservedObject private var viewModel: SettingsViewModel
    @State private var text: String = ""

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            VStack(spacing: 12) {
                ForEach(viewModel.theme, id: \.self) { theme in
                    HStack {
                        Button {
                            viewModel.themeButtonDidTap(with: theme)
                        } label: {
                            HStack {
                                Spacer()
                                Text(theme.rawValue)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                        }
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundColor(.blue)
                        .background(Capsule().stroke(.blue, lineWidth: 2))
                    }
                    .padding(.horizontal, 16)
                }
                TextField("Введите адрес URL", text: $text)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle()) // Применение стиля
                Text("Ваш адрес URL: \(viewModel.url)")
                HStack {
                    Button {
                        viewModel.setAddressURL(with: text)
                    } label: {
                        HStack {
                            Spacer()
                            Text("Сохранить URL")
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                    }
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundColor(.blue)
                    .background(Capsule().stroke(.blue, lineWidth: 2))
                }.padding(.horizontal, 16)
            }.padding(.top, 16)
            Toggle("Скорость загрузки", isOn: $viewModel.isDownloadSpeedToggled)
                        .padding()
                        .onChange(of: viewModel.isDownloadSpeedToggled, initial: true, { oldValue, newValue  in
                            viewModel.downloadSpeedEnabled(isEnabled: newValue)
                        })
            Toggle("Скорость отдачи", isOn:  $viewModel.isUploadSpeedToggled)
                        .padding()
                        .onChange(of: viewModel.isUploadSpeedToggled, initial: true, { oldValue, newValue  in
                            viewModel.uploadSpeedEnabled(isEnabled: newValue)
                        })
            Spacer()
        }
    }
}

#Preview {
    SettingsContentView(viewModel: .init())
}
