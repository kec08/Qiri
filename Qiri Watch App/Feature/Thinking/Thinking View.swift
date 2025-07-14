import SwiftUI

struct ThinkingView: View {
    @State private var currentToken: String = "두뇌 회전중..."
    @State private var isThinking: Bool = true
    @State private var fullResponse: String = ""
    @State private var isInThinkBlock: Bool = false
    @State private var lastUpdate: Date = Date()

    var body: some View {
        VStack(spacing: 18) {
            Spacer()

            ZStack {
                Image("think_speech")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 163, height: 60)
                    .padding(.top, 15)

                Text(currentToken)
                    .font(.system(size: 13))
                    .fontWeight(.bold)
            }
            .padding(.bottom, -10)

            Image("think_Qiri")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 77)
                .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity)
        .background(.customBackgroundBlack)
        .foregroundColor(.customWhite)
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: .sttResponseUpdated,
                object: nil,
                queue: .main
            ) { notification in
                if let response = notification.object as? String {
                    handleStreamingResponse(response)
                }
            }
            NotificationCenter.default.addObserver(
                forName: .sttCompleted,
                object: nil,
                queue: .main
            ) { _ in
                isThinking = true
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
    }

    private func handleStreamingResponse(_ response: String) {
        lastUpdate = Date()
        let trimmed = response.trimmingCharacters(in: .whitespacesAndNewlines)
        fullResponse += " " + trimmed
        print("Accumulated fullResponse: \(fullResponse) at \(lastUpdate)")

        if trimmed.contains("<think>") {
            isInThinkBlock = true
            let cleaned = trimmed.replacingOccurrences(of: "<think>", with: "")
            if !cleaned.isEmpty {
                updateToken(cleaned)
            }
        }

        if trimmed.contains("</think>") {
            isInThinkBlock = false
            finishThinking()
        } else if isInThinkBlock {
            updateToken(trimmed)
        }

        // 백업 타임아웃 처리
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.isInThinkBlock && Date().timeIntervalSince(self.lastUpdate) > 1.9 {
                print("[Timeout] Forcing end of <think> block")
                self.isInThinkBlock = false
                self.finishThinking()
            }
        }
    }

    private func updateToken(_ text: String) {
        let tokens = text.split(separator: " ")
        if let nextToken = tokens.last {
            DispatchQueue.main.async {
                self.currentToken = String(nextToken)
            }
        }
    }


    private func finishThinking() {
        let cleaned = fullResponse
            .replacingOccurrences(of: "<think>", with: "")
            .replacingOccurrences(of: "</think>", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        isThinking = false
        fullResponse = cleaned

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NotificationCenter.default.post(name: .sttResponseCompleted, object: cleaned)
        }
    }
}

#Preview {
    ThinkingView()
}

extension Notification.Name {
    static let returnToMain = Notification.Name("returnToMain")
    static let sttResponseCompleted = Notification.Name("sttResponseCompleted")
}

