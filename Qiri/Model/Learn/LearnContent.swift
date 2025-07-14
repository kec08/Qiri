//
//  OnboardingContent.swift
//  voiceMemo
//

import Foundation

struct LearnContent: Identifiable {
    let id = UUID()
    var imageFileName: String
    var title: String
    var explanationText: String

    init(
        imageFileName: String,
        title: String,
        explanationText: String
    ) {
        self.imageFileName = imageFileName
        self.title = title
        self.explanationText = explanationText
    }
}

