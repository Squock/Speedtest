//
//  SpeedometrContentView.swift
//  Speedtest
//
//  Created by Rodion on 11.04.2024.
//

import SwiftUI

struct SpeedometrContentView: View {
    @ObservedObject private var viewModel: SpeedometrViewModel

    init(viewModel: SpeedometrViewModel = .init()) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            switch viewModel.router {
            case .result:
                ResultView(viewModel: .init(downloadText: viewModel.downloadSpeed, uploadText: viewModel.uploadSpeed))
            case .main:
                ZStack {
                    Text(viewModel.domainURL)
                        .font(.title)
                        .offset(y: -250)
                    Text(viewModel.speedometrValue)
                        .font(.title)
                        .offset(y: -210)
                        .padding(.top, 15)
                }
                ZStack {
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(Color.black.opacity(0.1), lineWidth: 22)
                        .frame(width: 320, height: 320)
                        .rotationEffect(Angle(degrees: -35))
                    Circle()
                        .trim(from: 0, to: viewModel.circleValue)
                        .stroke(AngularGradient(gradient: .init(colors: [.green]), center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/), lineWidth: 22)
                        .frame(width: 320, height: 320)
                        .rotationEffect(Angle(degrees: -35))
                }
                .rotationEffect(.init(degrees: 180))
                .animation(.easeOut, value: viewModel.circleValue)
                ZStack(alignment: .bottom) {
                    Color.blue.frame(width: 2, height: 120)
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 15, height: 15)
                }
                .offset(y: -55)
                .rotationEffect(.init(degrees: viewModel.arrowValue + 235))
                .animation(.easeOut, value: viewModel.arrowValue)
            }
        }
        .onAppear {
            viewModel.start()
        }
    }
}

#Preview {
    SpeedometrContentView()
}
