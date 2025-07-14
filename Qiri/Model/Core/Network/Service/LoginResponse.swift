//
//  LoginResponse.swift
//  Qiri
//
//  Created by 김은찬 on 5/25/25.
//
import Foundation

struct LoginResponse: Codable {
    let userId: String
    let name: String
    let email: String
    let token: String
}


