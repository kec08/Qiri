import Foundation
import WatchConnectivity
import SwiftUI

final class WatchSessionDelegate: NSObject, WCSessionDelegate {
    static let shared = WatchSessionDelegate()
    private var isSessionActivated = false
    private var retryCount = 0
    private let maxRetries = 3

    private override init() {
        super.init()
        activateSession()
    }

    private func activateSession() {
        guard WCSession.isSupported() else {
            print("WCSession 미지원")
            return
        }
        let session = WCSession.default
        session.delegate = self
        session.activate()
        print("iOS WCSession 활성화 시도")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        handleMessage(message)
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        handleMessage(message, replyHandler: replyHandler)
    }

    private func handleMessage(_ message: [String: Any], replyHandler: (([String: Any]) -> Void)? = nil) {
        let session = WCSession.default
        print("iOS 메시지 수신: \(message), isReachable=\(session.isReachable), activationState=\(session.activationState.rawValue)")

        if let log = message["log"] as? String, let source = message["source"] as? String {
            print("[\(source)] \(log)")
            
            if source == "watch", let registration = message["registration"] as? String, registration == "not_registered" {
                print("[iOS] 디바이스 등록 안 됨 - 약관 동의 필요")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .deviceNotRegistered, object: nil)
                }
                if let replyHandler = replyHandler {
                    let response = ["log": "등록 필요 확인", "source": "ios"]
                    replyHandler(response)
                }
            }
        } else if let requestSyncAppleUserId = message["request_sync_apple_user_id"] as? Bool, requestSyncAppleUserId == true {
            sendAppleUserIdToWatch(replyHandler: replyHandler)
        } else if let appleUserIdFromWatch = message["apple_user_id"] as? String {
            print("[iOS] 워치로부터 apple_user_id 수신: \(appleUserIdFromWatch)")
            if let replyHandler = replyHandler {
                let response = ["log": "apple_user_id 수신 완료", "source": "ios"]
                replyHandler(response)
            }
        } else {
            print("[iOS] 예상치 못한 메시지 형식: \(message)")
            if let replyHandler = replyHandler {
                let errorResponse = ["log": "잘못된 메시지 형식", "source": "ios"]
                replyHandler(errorResponse)
            }
        }
    }

    func sendAppleUserIdToWatch(replyHandler: (([String: Any]) -> Void)? = nil) {
        let appleUserId = UserDefaults.standard.string(forKey: "user_id") ?? "unknown_id"
        let session = WCSession.default
        if session.isReachable {
            let message = ["apple_user_id": appleUserId, "source": "ios"]
            session.sendMessage(message, replyHandler: { reply in
                print("[iOS] apple_user_id 전송 성공: \(reply)")
                self.retryCount = 0
                do {
                    try session.updateApplicationContext(["user_id": appleUserId])
                    print("[iOS] user_id applicationContext에 업데이트: \(appleUserId)")
                } catch {
                    print("[iOS] applicationContext 업데이트 실패: \(error.localizedDescription)")
                }
                if let replyHandler = replyHandler {
                    let response: [String: Any] = [
                        "log": "apple_user_id 전달 완료",
                        "apple_user_id": appleUserId,
                        "source": "ios"
                    ]
                    replyHandler(response)
                }
            }, errorHandler: { error in
                print("[iOS] apple_user_id 전송 실패: \(error.localizedDescription)")
                if self.retryCount < self.maxRetries {
                    self.retryCount += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.sendAppleUserIdToWatch(replyHandler: replyHandler)
                    }
                } else {
                    if let replyHandler = replyHandler {
                        replyHandler([
                            "log": "apple_user_id 전송 재시도 실패",
                            "source": "ios"
                        ])
                    }
                }
            })
        } else {
            print("[iOS] 워치와 연결 안 됨, apple_user_id 전송 불가")
            if let replyHandler = replyHandler {
                replyHandler([
                    "log": "워치 연결 불가",
                    "source": "ios"
                ])
            }
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("iOS WCSession 비활성화")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("iOS WCSession 비활성화 완료")
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        isSessionActivated = (activationState == .activated)
        print("iOS WCSession 활성 상태: \(activationState.rawValue), 오류: \(String(describing: error))")
        if isSessionActivated && session.isReachable {
            print("WCSession 활성화 및 연결 가능")
            sendAppleUserIdToWatch()
        }
    }
}

