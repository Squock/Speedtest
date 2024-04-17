//
//  ResultLocalization.swift
//  Speedtest
//
//  Created by Rodion on 17.04.2024.
//

import Foundation

struct ResultLocalization {
    let doneButton: String
    let downloadText: String
    let uploadText: String

    init(doneButton: String = "Завершить",
         downloadText: String = "Download speed:",
         uploadText: String = "Upload speed:"
    ) {
        self.doneButton = doneButton
        self.downloadText = downloadText
        self.uploadText = uploadText
    }
}
