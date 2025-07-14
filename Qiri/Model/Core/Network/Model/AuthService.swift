//
//  AuthService.swift
//  Qiri
//
//  Created by 김은찬 on 5/25/25.
//

import Foundation
import Moya

final class AuthService {
    static let shared = AuthService()
    private let provider = MoyaProvider<AuthAPI>()

    /// Apple 로그인 API 요청
    /// - Parameters:
    ///   - identityToken: 애플에서 받은 JWT 토큰
    ///   - userId: 애플 유저 식별자
    ///   - name: 사용자 이름
    ///   - completion: 로그인 성공 여부를 Bool로 반환
    func login(identityToken: String, userId: String, name: String, completion: @escaping (Bool) -> Void) {
        provider.request(.login(identityToken: identityToken, userId: userId, name: name)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode

                if let message = String(data: response.data, encoding: .utf8) {
                    print("로그인 응답: \(statusCode), \(message)")
                } else {
                    print("응답을 문자열 변환 안됨.")
                }

                if statusCode == 200 {
                    UserDefaults.standard.set(userId, forKey: "user_id")
                    UserDefaults.standard.set(name, forKey: "user_name")
                }

                completion(statusCode == 200)

            case .failure(let error):
                print("네트워크 오류: \(error.localizedDescription)")
                completion(false)
            }
        }
    }


    /// 디바이스 등록 API 요청
    func registerDevice(deviceUUID: String, deviceName: String, appleUserId: String, completion: @escaping (Bool) -> Void) {
        provider.request(.registerDevice(deviceUUID: deviceUUID, deviceName: deviceName, appleUserId: appleUserId)) { result in
            switch result {
            case .success(let response):
                print("디바이스 등록 응답: \(response.statusCode)")
                completion(response.statusCode == 201)

            case .failure(let error):
                print("디바이스 등록 실패: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

    func logout(completion: @escaping (Bool) -> Void) {
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "user_email")
        UserDefaults.standard.removeObject(forKey: "user_name")
        UserDefaults.standard.removeObject(forKey: "user_uuid")

        print("Apple 로그인 관련 정보 초기화 완료")
        completion(true)
    }
}
