import SwiftUI
import WatchKit
import WatchConnectivity

struct QuestionView: View {
    @State private var spokenText: String = ""
    @State private var userId: String? = nil
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 18) {
            Spacer()

            ZStack {
                Image("Question_speech")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 163, height: 60)
                    .padding(.top, 15)

                Text("무엇이든 질문해보세요")
                    .font(.system(size: 13))
                    .fontWeight(.bold)
            }
            .padding(.bottom, -10)

            Image("Question_Qiri")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 77)
                .padding(.bottom, 50)
                .onTapGesture {
                    requestSpeechInput()
                }
        }
        .frame(maxWidth: .infinity)
        .background(Color.customBackgroundBlack)
        .foregroundColor(.customWhite)
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("오류"), message: Text(errorMessage), dismissButton: .default(Text("확인")))
        }
        .onAppear {
            activateWatchSessionIfNeeded()
            sendLog("Watch 시작: WCSession 활성화 확인")
            checkUserIdFromContext()
        }
    }

    private func checkUserIdFromContext() {
        if let context = WCSession.default.receivedApplicationContext["user_id"] as? String, !context.isEmpty {
            userId = context
            sendLog("user_id 수신 (applicationContext): \(context)")
        } else {
            sendLog("applicationContext에 user_id 없음")
        }
    }

    private func requestSpeechInput() {
        guard let controller = WKExtension.shared().visibleInterfaceController else {
            sendLog("인터페이스 컨트롤러 없음")
            return
        }

        sendLog("음성 입력 시작")
        controller.presentTextInputController(
            withSuggestions: nil,
            allowedInputMode: .plain
        ) { result in
            sendLog("음성 입력 결과: \(String(describing: result))")
            if let result = result?.first as? String {
                sendLog("음성 인식 텍스트: \(result)")
                spokenText = result
                processSpeechInput()
            } else {
                sendLog("음성 입력 실패 또는 취소")
            }
        }
    }

    private func processSpeechInput() {
        WatchSessionDelegate.shared.processSpeechInput(spokenText)
        NotificationCenter.default.addObserver(forName: .sttCompleted, object: nil, queue: .main) { _ in
            sendLog("STT 처리 시작 알림 수신")
        }
        NotificationCenter.default.addObserver(forName: .sttResponseUpdated, object: nil, queue: .main) { notification in
            if let response = notification.object as? String {
                sendLog("스트리밍 응답 수신: \(response.prefix(10))...")
                // RootView로 상태 전환 위임
            }
        }
        NotificationCenter.default.addObserver(forName: .sttError, object: nil, queue: .main) { notification in
            if let error = notification.object as? String {
                sendLog("STT 오류: \(error)")
                DispatchQueue.main.async {
                    showErrorAlert(message: error)
                }
            }
        }
    }

    private func showErrorAlert(message: String) {
        errorMessage = message
        showErrorAlert = true
    }

    private func sendLog(_ message: String) {
        let logMessage = ["log": message, "source": "watch"]
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(logMessage) { reply in
                print("Watch 로그 전송 응답: \(reply)")
            } errorHandler: { error in
                print("Watch 로그 전송 실패: \(error.localizedDescription)")
            }
        } else {
            print("iPhone 연결 안 됨. Watch 로그: \(message)")
        }
    }

    private func activateWatchSessionIfNeeded() {
        guard WCSession.isSupported() else {
            sendLog("WCSession 미지원")
            return
        }

        let session = WCSession.default
        sendLog("WCSession 상태: isReachable=\(session.isReachable), activationState=\(session.activationState.rawValue)")

        if session.activationState != .activated {
            session.delegate = WatchSessionDelegate.shared
            session.activate()
            sendLog("WCSession 활성화 시도")
        } else {
            sendLog("WCSession 이미 활성화")
            if session.isReachable {
                session.sendMessage(["request_sync_apple_user_id": true], replyHandler: { reply in
                    if let appleUserId = reply["apple_user_id"] as? String, !appleUserId.isEmpty {
                        sendLog("apple_user_id 동기화 성공: \(appleUserId)")
                        userId = appleUserId
                    } else {
                        sendLog("apple_user_id 요청 실패 - 응답 데이터 없음")
                    }
                }, errorHandler: { error in
                    sendLog("apple_user_id 요청 실패: \(error.localizedDescription)")
                })
            }
        }
    }
}

#Preview {
    QuestionView()
}
