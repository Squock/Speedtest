//
//  ResultView.swift
//  Speedtest
//
//  Created by Rodion on 15.04.2024.
//

import SwiftUI


struct ResultView: View {
    @ObservedObject var viewModel: ResultViewModel

    init(viewModel: ResultViewModel = .init()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text("Download speed:")
            Text(viewModel.downloadText)
            Text("Upload speed:")
            Text(viewModel.uploadText)
        }
    }
}

#Preview {
    ResultView(viewModel: .init())
}
