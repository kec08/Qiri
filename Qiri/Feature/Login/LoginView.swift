import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var showLoginError = false
    @State private var loginErrorMessage = "다시 로그인하여 주세요."
    @State private var isLoggedIn = false  // 로그인 성공 여부
    @State private var loginLoding = false

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Image("Login_Qiri")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .padding(.bottom, 30)
                
                Text("Apple 계정 로그인")
                    .font(.system(size: 32))
                    .fontWeight(.bold)
                    .padding(.bottom, 300)
                
                Button(action: {
                    print("Apple 로그인 버튼 클릭됨")
                    
                    loginLoding = true
                    
                    AppleLoginDelegate.shared.onLoginResult = { success in
                        loginLoding = false

                        if success {
                            isLoggedIn = true
                        } else {
                            showLoginError = true
                        }
                    }
                    
                    performAppleLogin()
                }) {
                    HStack {
                        Image("Login_Apple")
                            .resizable()
                            .frame(width: 20, height: 24)
                        
                        Text("Apple 계정으로 계속하기")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.customBackgroundBlack)
                            .padding(.trailing, 30)
                            .padding(.leading, 20)
                    }
                    .frame(width: 288, height: 60)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .padding(.bottom, 110)
            }
            .frame(maxWidth: .infinity)
            .background(Color.customBackgroundBlack)
            .foregroundColor(.customWhite)
            .disabled(loginLoding)
            .blur(radius: loginLoding ? 3 : 0)

            if loginLoding {
                LoadingView()
            }
        }
        .alert(isPresented: $showLoginError) {
            Alert(title: Text("로그인 실패"), message: Text(loginErrorMessage), dismissButton: .default(Text("확인")))
        }
        .fullScreenCover(isPresented: $isLoggedIn) {
            ConditionsView()
        }
    }

    func performAppleLogin() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = AppleLoginDelegate.shared
        controller.presentationContextProvider = AppleLoginDelegate.shared
        controller.performRequests()
    }
}

