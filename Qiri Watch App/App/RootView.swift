import SwiftUI
import WatchConnectivity

struct RootView: View {
    // MARK: - Properties
    @State private var currentState: ScreenState = .splash
    @State private var isOnboardingComplete: Bool = UserDefaults.standard.bool(forKey: "isOnboardingComplete")
    @State private var isMainComplete: Bool = false
    @State private var sttResponse: String = ""

    enum ScreenState {
        case splash
        case onboarding
        case main
        case question
        case thinking
        case answer
        case answermore
        case error
    }

    // MARK: - View Body
    var body: some View {
        ZStack {
            switch currentState {
            case .splash:
                SplashView()
                    .transition(.opacity)
                    .onAppear {
                        print("SplashView 표시됨, currentState: \(currentState)")
                        activateWatchSessionIfNeeded()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                print("SplashView -> OnboardingView 전환")
                                currentState = .onboarding
                            }
                        }
                    }
                    .background(.customBackgroundBlack)
                    .foregroundColor(.customWhite)

            case .onboarding:
                OnboardingView(isOnboardingComplete: $isOnboardingComplete, onComplete: {
                    print("OnboardingView -> MainView 전환, isOnboardingComplete: \(isOnboardingComplete)")
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentState = .main
                    }
                })
                .transition(.opacity)
                .background(.customBackgroundBlack)
                .foregroundColor(.customWhite)

            case .main:
                MainView(onQiriMainTap: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        print("MainView -> QuestionView 전환 (Qiri 탭)")
                        currentState = .question
                    }
                })
                .transition(.opacity)
                .background(.customBackgroundBlack)
                .foregroundColor(.customWhite)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isMainComplete = true
                    }
                }

            case .question:
                QuestionView()
                    .transition(.opacity)
                    .onReceive(NotificationCenter.default.publisher(for: .sttCompleted)) { _ in
                        print("STT 완료 수신 → thinking 상태로 이동")
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentState = .thinking
                        }
                    }
                    .background(.customBackgroundBlack)
                    .foregroundColor(.customWhite)

            case .thinking:
                ThinkingView()
                    .transition(.opacity)
                    .onReceive(NotificationCenter.default.publisher(for: .sttResponseCompleted)) { notification in
                        if let response = notification.object as? String {
                            print("스트리밍 완료 응답 수신 → answer 상태로 전환: \(response.prefix(10))...")
                            sttResponse = response
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentState = .answer
                            }
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: .sttError)) { notification in
                        if let error = notification.object as? String {
                            print("STT 오류 수신: \(error)")
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentState = .error
                            }
                        }
                    }
                    .background(.customBackgroundBlack)
                    .foregroundColor(.customWhite)

            case .answer:
                AnswerView(response: sttResponse, onQiriTap: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentState = .answermore
                    }
                })
                .transition(.opacity)
                .background(.customBackgroundBlack)
                .foregroundColor(.customWhite)

            case .answermore:
                AnswerMoreView()
                    .transition(.opacity)
                    .background(.customBackgroundBlack)
                    .foregroundColor(.customWhite)
                    .onReceive(NotificationCenter.default.publisher(for: .returnToMain)) { _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentState = .main
                        }
                    }

            case .error:
                QuestionErrorView {
                    print("QuestionErrorView 확인 버튼 클릭")
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentState = .main
                    }
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .onAppear {
            print("RootView 표시됨, WCSession 설정 시작")
            WCSession.default.delegate = WatchSessionDelegate.shared
            if WCSession.default.activationState == .activated {
                print("WCSession 이미 활성화됨")
            } else {
                activateWatchSessionIfNeeded()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .moveToAnswerMore)) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                currentState = .answermore
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("WCSessionMessageReceived"))) { notification in
            print("NotificationCenter 알림 수신: \(notification.userInfo ?? [:])")
            if let message = notification.userInfo as? [String: Any], message["registration"] as? String == "not_registered" {
                print("WCSession 메시지 수신: 등록되지 않은 디바이스")
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentState = .error
                }
            }
        }
    }

    // MARK: - WCSession Management
    private func activateWatchSessionIfNeeded() {
        guard WCSession.isSupported() else {
            print("WCSession 미지원 기기")
            return
        }

        let session = WCSession.default
        print("WCSession 상태: isReachable=\(session.isReachable), activationState=\(session.activationState.rawValue)")
        if session.activationState != .activated {
            session.delegate = WatchSessionDelegate.shared
            session.activate()
            print("WCSession 활성화됨 (RootView에서)")
        } else {
            print("WCSession 이미 활성화됨")
        }
    }
}

#Preview {
    RootView()
}
