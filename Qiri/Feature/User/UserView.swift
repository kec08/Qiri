//
//  UserView.swift
//  Qiri
//
//  Created by 김은찬 on 6/10/25.
//

import SwiftUI

// MARK: - 메인 뷰
struct UserView: View {
    var body: some View {
        NavigationStack {
            UserContentView(userManager: UserViewModel())
                .navigationBarHidden(false)
        }
    }
}

// MARK: - 사용자 정보 및 로그아웃 처리 뷰
struct UserContentView: View {
    @State private var showLogoutAlert = false
    @State private var navigateToLogin = false
    @ObservedObject var userManager: UserViewModel

    var body: some View {
        VStack {
            Image("User_Qiri")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 35)
                .padding(.top, -45)

            Spacer().frame(width: 160, height: 1)

            VStack {
                Image("User_Profile")
                    .resizable()
                    .frame(width: 110, height: 110)
                    .padding(.top, 30)

                Text(userManager.name)
                    .padding(.top, 15)
                    .font(.system(size: 26, weight: .semibold))

                Text(userManager.email)
                    .padding(.top, 5)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.customGray)
            }

            Spacer()

            Button(action: {
                showLogoutAlert = true
            }) {
                Text("로그아웃")
                    .font(.system(size: 15))
                    .foregroundColor(.customOrange)
            }
            .alert(
                "정말 로그아웃 하실건가요?",
                isPresented: $showLogoutAlert,
                actions: {
                    Button("예", role: .destructive) {
                        AuthService.shared.logout { success in
                            if success {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    navigateToLogin = true
                                }
                            }
                        }
                    }
                    Button("아니오", role: .cancel) { }
                },
                message: {
                    Text("로그아웃 시 홈 화면으로 이동합니다")
                }
            )
            .fullScreenCover(isPresented: $navigateToLogin) {
                LoginView()
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.customBackgroundBlack)
        .foregroundColor(.customWhite)
    }
}

#Preview {
    UserView()
}

