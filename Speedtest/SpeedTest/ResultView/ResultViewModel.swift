//
//  ResultViewModel.swift
//  Speedtest
//
//  Created by Rodion on 15.04.2024.
//

import Foundation
import Combine

// MARK: - Логика отображения результата

final class ResultViewModel: ObservableObject {
    @Published var downloadText: String
    @Published var uploadText: String

    init(downloadText: String = "-", uploadText: String = "-") {
        self.downloadText = downloadText
        self.uploadText = uploadText
    }
}
