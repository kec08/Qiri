//
//  AuthAPI.swift
//  Qiri
//
//  Created by 김은찬 on 5/25/25.

import Foundation
import Moya

enum AuthAPI {
    case login(identityToken: String, userId: String, name: String)
    case registerDevice(deviceUUID: String, deviceName: String, appleUserId: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://qiri.kro.kr:10000")! // 백엔드 도메인

    }


    var path: String {
        switch self {
        case .login:
            return "/auth/apple"
        case .registerDevice:
            return "/register-device"
        }
    }

    var method: Moya.Method {
        return .post
    }

    var task: Task {
        switch self {
        case let .login(identityToken, userId, name):
            return .requestJSONEncodable([
                "identity_token": identityToken,
                "user_id": userId,
                "name": name
            ])
            
        case let .registerDevice(deviceUUID, deviceName, appleUserId):
            return .requestJSONEncodable([
                "device_uuid": deviceUUID,
                "device_name": deviceName,
                "apple_user_id": appleUserId
            ])
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
