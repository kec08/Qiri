//
//  UserViewModel.swift
//  Qiri
//
//  Created by 김은찬 on 6/10/25.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var name: String
    @Published var email: String

    init(name: String = "Qiri 사용자", email: String = "kec4489@icloud.com") {
        self.name = name
        self.email = email
    }
}
