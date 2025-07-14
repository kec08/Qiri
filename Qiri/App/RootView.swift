import SwiftUI

extension Notification.Name {
    static let deviceNotRegistered = Notification.Name("deviceNotRegistered")
    static let unauthorizedFromServer = Notification.Name("unauthorizedFromServer")
    static let showTermsView = Notification.Name("showTermsView")
}

struct RootView: View {
    @State private var currentState: ScreenState = .splash
    @State private var isShowingTermsView = false

    enum ScreenState {
        case splash
        case login
        case main
        case conditionsError
    }

    var body: some View {
        ZStack {
            switch currentState {
            case .splash:
                SplashView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentState = .login
                            }
                        }
                    }

            case .login:
                LoginView()
                    .transition(.opacity)
                    .zIndex(0)

            case .main:
                MainView()
                    .transition(.opacity)

            case .conditionsError:
                ConditionsErrorView {
                    print("ConditionsErrorView 확인 버튼 클릭")
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentState = .login
                    }
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .background(Color.customBackgroundBlack)
        .foregroundColor(.customWhite)

        // 약관 미동의로 인증 거부
        .onReceive(NotificationCenter.default.publisher(for: .unauthorizedFromServer)) { _ in
            print("iOS에서 unauthorizedFromServer 알림 수신")
            withAnimation(.easeInOut(duration: 0.5)) {
                currentState = .conditionsError
            }
        }

        // 디바이스 미등록 수신
        .onReceive(NotificationCenter.default.publisher(for: .deviceNotRegistered)) { _ in
            print("iOS에서 deviceNotRegistered 알림 수신")
            withAnimation(.easeInOut(duration: 0.5)) {
                currentState = .conditionsError
            }
        }

        .onReceive(NotificationCenter.default.publisher(for: .showTermsView)) { _ in
            print("iOS에서 showTermsView 알림 수신")
            isShowingTermsView = true
        }

        // 약관 동의
        .fullScreenCover(isPresented: $isShowingTermsView) {
            ConditionsView()
        }
    }
}


#Preview {
    RootView()
}
