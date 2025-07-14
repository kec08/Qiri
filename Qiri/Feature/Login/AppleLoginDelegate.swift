import AuthenticationServices
import SwiftUI

class AppleLoginDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    static let shared = AppleLoginDelegate()
    
    var onLoginResult: ((Bool) -> Void)?

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIdCredential.user
            let fullName = appleIdCredential.fullName
            let email = appleIdCredential.email
            let identityToken = appleIdCredential.identityToken
            let tokenString = identityToken.flatMap { String(data: $0, encoding: .utf8) } ?? ""
            let deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown-uuid"

            print("Apple 로그인 성공")
            print("사용자 ID: \(userIdentifier)")
            print("이름: \(fullName?.givenName ?? "")")
            print("이메일: \(email ?? "")")
            print("토큰: \(tokenString)")
            print("UUID: \(deviceUUID)")
            print("디바이스 이름: \(UIDevice.current.name)")

            // 로그인 요청
            if !tokenString.isEmpty {
                AuthService.shared.login(identityToken: tokenString, userId: userIdentifier, name: deviceUUID) { success in
                    DispatchQueue.main.async {
                        self.onLoginResult?(success)  // 성공 여부
                    }
                }
            } else {
                print("identityToken이 비어 있음. 로그인 요청 생략")
                onLoginResult?(false)
            }

        default:
            print("알 수 없는 인증 방식")
            onLoginResult?(false)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("로그인 실패:", error.localizedDescription)
        onLoginResult?(false)
    }
}

