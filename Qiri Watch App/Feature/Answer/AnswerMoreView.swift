import SwiftUI

struct AnswerMoreView: View {
    @Environment(\.dismiss) private var back
    @State private var displayText: String = ""
    @State private var isStreaming: Bool = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Qiri의 답변")
                    .font(.system(size: 20, weight: .medium))
                    .padding(.bottom, 5)

                bullet(displayText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .lineSpacing(10)

                HStack {
                    Spacer()
                    Button("확인") {
                        NotificationCenter.default.post(name: .returnToMain, object: nil)
                        back()
                    }
                    .frame(width: 140, height: 40)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(radius: 2)
                    .padding(.top, 24)
                    Spacer()
                }
            }
            .padding(.horizontal, 22)
        }
        .frame(maxWidth: .infinity)
        .background(.customBackgroundBlack)
        .foregroundColor(.customWhite)
        .onReceive(NotificationCenter.default.publisher(for: .sttResponseUpdated)) { notification in
            if let response = notification.object as? String {
                let cleaned = preprocess(response)
                let koreanSentence = extractKoreanSentence(cleaned)
                streamWords(koreanSentence)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .sttResponseCompleted)) { _ in
            isStreaming = false
        }
    }

    // MARK: - Helper Functions

    private func preprocess(_ response: String) -> String {
        response
            .replacingOccurrences(of: "<think>", with: "")
            .replacingOccurrences(of: "</think>", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func extractKoreanSentence(_ text: String) -> [String] {
        let separators = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        return text
            .components(separatedBy: separators)
            .map { $0.trimmingCharacters(in: .punctuationCharacters) }
            .filter { !$0.isEmpty && $0.range(of: "[가-힣]", options: .regularExpression) != nil }
    }


    private func streamWords(_ words: [String]) {
        for (index, word) in words.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.15) {
                if isStreaming {
                    displayText += word + " "
                }
            }
        }
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .bold()
            Text(text)
                .font(.system(size: 17))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.footnote)
    }
}

#Preview {
    AnswerMoreView()
}

