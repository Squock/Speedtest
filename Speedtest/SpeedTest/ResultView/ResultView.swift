//
//  ResultView.swift
//  Speedtest
//
//  Created by Rodion on 15.04.2024.
//

import SwiftUI


struct ResultView: View {
    @ObservedObject var viewModel: ResultViewModel
    private let localization: ResultLocalization
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    init(viewModel: ResultViewModel = .init(),
         localization: ResultLocalization = .init()
    ) {
        self.viewModel = viewModel
        self.localization = localization
    }

    var body: some View {
        VStack {
            Text(localization.downloadText)
            Text(viewModel.downloadText)
            Text(localization.uploadText)
            Text(viewModel.uploadText)
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Spacer()
                    Text(localization.doneButton)
                    Spacer()
                }
                .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
            }
            .font(.system(.title2, design: .rounded, weight: .bold))
            .foregroundColor(.blue)
            .background(Capsule().stroke(.blue, lineWidth: 2))
        }.padding(.horizontal, 16)
    }
}

#Preview {
    ResultView(viewModel: .init())
}
