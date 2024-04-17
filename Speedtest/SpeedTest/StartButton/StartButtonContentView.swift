//
//  StartButtonContentView.swift
//  Speedtest
//
//  Created by Rodion on 11.04.2024.
//

import SwiftUI

struct StartButtonContentView: View {
    @ObservedObject private var viewModel: StartButtonModel
    @State private var localization: StartButtonLocalization

    init(viewModel: StartButtonModel,
         localization: StartButtonLocalization = .init()
    ) {
        self.viewModel = viewModel
        self.localization = localization
    }
        
    var body: some View {
        Button(action: {
            self.viewModel.buttonPressed()
        }) {
            VStack {
                Text(localization.startButtonText)
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(50)
                    .background(viewModel.isPressed ? Color.red : Color.blue)
                    .clipShape(Circle())
                    .scaleEffect(viewModel.isPressed ? 0.8 : 1.0)
                    .animation(.spring())
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { self.viewModel.error == .error },
            set: { _ in }
        )) {
            Alert(title: Text("Ошибка"),
                  message: Text("Необходимо в настройках переключить Скорость загрузки/Скорость отдачи"),
                  dismissButton: .cancel(Text("OK"), action: {
                viewModel.alertHide()
            }))
        }
        .onAppear() {
            viewModel.clean()
        }
    }
}

#Preview {
    StartButtonContentView(viewModel: .init())
}

