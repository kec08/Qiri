import WatchConnectivity
import Foundation

class WatchSessionDelegate: NSObject, WCSessionDelegate, URLSessionDataDelegate {
    static let shared = WatchSessionDelegate()
    private var isSessionActivated = false
    private var streamingTask: URLSessionDataTask?
    private var responseText = ""
    private let maxRetries = 3
    private var retryCount = 0

    private override init() {
        super.init()
        activateSession()
    }
    
    private var baseURL: URL {
        return URL(string: "http://qiri.kro.kr:10000")!
    }

    private func activateSession() {
        guard WCSession.isSupported() else {
            print("WCSession 미지원")
            return
        }
        let session = WCSession.default
        session.delegate = self
        session.activate()
        print("Watch WCSession 활성화 시도")
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        isSessionActivated = (activationState == .activated)
        print("Watch WCSession 활성 상태: \(activationState.rawValue), 오류: \(String(describing: error))")
        if isSessionActivated {
            print("WCSession 활성화 완료")
            // iOS로부터 ID 요청
            if let appleUserId = UserDefaults.standard.string(forKey: "user_id") {
                print("[Watch] 로컬에 저장된 apple_user_id: \(appleUserId)")
            } else {
                session.sendMessage(["request_sync_apple_user_id": true], replyHandler: { reply in
                    if let appleUserId = reply["apple_user_id"] as? String, !appleUserId.isEmpty {
                        UserDefaults.standard.set(appleUserId, forKey: "user_id")
                        print("[Watch] iOS로부터 apple_user_id 수신: \(appleUserId)")
                    } else {
                        print("[Watch] apple_user_id 요청 실패 - 응답 데이터 없음")
                    }
                }, errorHandler: { error in
                    print("[Watch] ID 동기화 요청 실패: \(error.localizedDescription)")
                })
            }
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("받은 메시지: \(message)")
        handleMessage(message)
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: Notification.Name("WCSessionMessageReceived"),
                object: nil,
                userInfo: message
            )
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        print("받은 메시지 (replyHandler 포함): \(message)")
        handleMessage(message)
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: Notification.Name("WCSessionMessageReceived"),
                object: nil,
                userInfo: message
            )
        }
        replyHandler(["status": "received"])
    }

    private func handleMessage(_ message: [String: Any], replyHandler: (([String: Any]) -> Void)? = nil) {
        if let appleUserId = message["apple_user_id"] as? String {
            UserDefaults.standard.set(appleUserId, forKey: "user_id")
            print("[Watch] iOS로부터 apple_user_id 수신: \(appleUserId)")
            if let replyHandler = replyHandler {
                let response = ["log": "apple_user_id 저장 완료", "source": "watch"]
                replyHandler(response)
            }
        } else if let log = message["log"] as? String, let source = message["source"] as? String {
            print("[\(source)] \(log)")
        } else {
            print("[Watch] 예상치 못한 메시지 형식: \(message)")
            if let replyHandler = replyHandler {
                let errorResponse = ["log": "잘못된 메시지 형식", "source": "watch"]
                replyHandler(errorResponse)
            }
        }
    }

    // STT 처리 및 /ask로 스트리밍 요청
    func processSpeechInput(_ text: String) {
        guard let appleUserId = UserDefaults.standard.string(forKey: "user_id"), !appleUserId.isEmpty, appleUserId != "unknown_id" else {
            print("[Watch] 사용자 ID 없음 또는 잘못됨: \(String(describing: UserDefaults.standard.string(forKey: "user_id")))")
            NotificationCenter.default.post(name: .sttError, object: "사용자 ID를 확인할 수 없습니다.")
            return
        }

        UserDefaults.standard.set(text, forKey: "last_question")
        sendToBackend(question: text)
    }

    private func sendToBackend(question: String) {
        guard let appleUserId = UserDefaults.standard.string(forKey: "user_id") else {
            print("[Watch] 사용자 ID 없음")
            NotificationCenter.default.post(name: .sttError, object: "사용자 ID를 확인할 수 없습니다.")
            return
        }

        guard
            let encodedQuestion = question.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let encodedUserId = appleUserId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            print("[Watch] 인코딩 오류")
            NotificationCenter.default.post(name: .sttError, object: "인코딩 오류")
            return
        }

        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = "/ask"
        components.queryItems = [
            URLQueryItem(name: "q", value: encodedQuestion),
            URLQueryItem(name: "apple_user_id", value: encodedUserId),
            URLQueryItem(name: "no_think", value: "true")
        ]

        guard let url = components.url else {
            print("[Watch] URL 구성 실패")
            NotificationCenter.default.post(name: .sttError, object: "URL 오류")
            return
        }

        print("[Watch] 요청 URL: \(url.absoluteString)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120.0
        configuration.timeoutIntervalForResource = 120.0
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue())
        streamingTask = session.dataTask(with: request)
        streamingTask?.resume()
        print("[Watch] 스트리밍 요청 시작: \(question)")
        NotificationCenter.default.post(name: .sttCompleted, object: nil)
    }


    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if let httpResponse = response as? HTTPURLResponse {
            print("[Watch] 서버 응답 상태: \(httpResponse.statusCode), 헤더: \(httpResponse.allHeaderFields)")
        }
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let result = String(data: data, encoding: .utf8) {
            // <think> 태그 제거
            let cleanedResult = result.replacingOccurrences(of: "<think>.*?</think>", with: "", options: .regularExpression, range: nil)
            responseText += cleanedResult
            print("[Watch] 스트리밍 데이터 수신 (raw): \(cleanedResult)")
            NotificationCenter.default.post(name: .sttResponseUpdated, object: cleanedResult)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let statusCode = (task.response as? HTTPURLResponse)?.statusCode ?? -1
        if let error = error {
            print("[Watch] 스트리밍 완료, 오류: \(error.localizedDescription), HTTP 상태: \(statusCode)")
            NotificationCenter.default.post(name: .sttError, object: "에러 발생: \(error.localizedDescription)")
            if retryCount < maxRetries && statusCode != -1 {
                retryCount += 1
                print("[Watch] 리트라이 시도 \(retryCount)/\(maxRetries)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if let question = UserDefaults.standard.string(forKey: "last_question") {
                        self.sendToBackend(question: question)
                    }
                }
            }
        } else {
            print("[Watch] 스트리밍 완료, HTTP 상태: \(statusCode), 전체 응답: \(responseText)")
            NotificationCenter.default.post(name: .sttResponseUpdated, object: responseText.isEmpty ? "응답 없음" : responseText)
        }
        streamingTask = nil
        responseText = ""
        UserDefaults.standard.removeObject(forKey: "last_question")
        retryCount = 0
    }
}

extension Notification.Name {
    static let sttCompleted = Notification.Name("sttCompleted")
    static let sttResponseUpdated = Notification.Name("sttResponseUpdated")
    static let sttError = Notification.Name("sttError")
}
