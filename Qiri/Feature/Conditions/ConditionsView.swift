import SwiftUI
import Moya
import WatchConnectivity

struct ConditionsView: View {
    @State private var loginLoading = false
    @State private var showErrorAlert = false
    @State private var errorMessage = "다시 로그인하여 주세요."
    @State private var isAgreed = false
    
    let provider = MoyaProvider<AuthAPI>()
    
    var body: some View {
        ZStack {
            VStack {
                Image("Login_Qiri")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.bottom, 20)
                
                Text("Qiri 약관 동의하기")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 24) {
                    Text("AI 에이전트 이용 및 개인정보 수집 동의\n본 서비스에서 제공하는 AI 에이전트 기능을 이용하시려면 아래 사항에 동의하셔야 합니다.")
                    
                    Text("1. AI 에이전트는 사용자의 편의를 위해 UUID(기기 및 사용자 식별자)를 수집·이용합니다.")
                    
                    Text("2. 수집된 UUID는 사용자 식별 및 서비스 제공 목적에 한하여 사용되며, 외부에 공유되지 않습니다.")
                    
                    Text("3. 사용자는 언제든지 동의를 철회할 수 있으며, 동의 거부 시 AI 에이전트 기능 이용이 제한될 수 있습니다.")
                }
                .font(.system(size: 16))
                .lineSpacing(10)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
                .foregroundColor(.customWhite)
                
                Spacer()
                    .frame(height: 140)
                
                Button(
                    action: registerDevice
                ) {
                    Text("동의합니다")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.customBackgroundBlack)
                        .frame(width: 288, height: 60)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.bottom, 40)
                }
                .disabled(loginLoading)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.customBackgroundBlack)
            .foregroundColor(.customWhite)
            .blur(radius: loginLoading ? 3 : 0)
            
            if loginLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("등록 실패"), message: Text(errorMessage), dismissButton: .default(Text("확인")))
        }
        .fullScreenCover(isPresented: $isAgreed) {
            MainView()
        }
    }
    
    // MARK: 약관 처리 함수
    private func registerDevice() {
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
            errorMessage = "기기 UUID를 불러올 수 없습니다."
            showErrorAlert = true
            return
        }
        
        let deviceName = UIDevice.current.name
        let appleUserId = UserDefaults.standard.string(forKey: "user_id") ?? "unknown_id"
        
        if appleUserId == "unknown_id" {
            errorMessage = "로그인 정보가 유실되었습니다. 다시 로그인해 주세요."
            showErrorAlert = true
            return
        }
        
        UserDefaults.standard.set(appleUserId, forKey: "user_id")
        UserDefaults.standard.synchronize()
        print("UserDefaults에 user_id 저장: \(appleUserId)")
        
        print("서버로 전송: deviceUUID: \(uuid), deviceName: \(deviceName), appleUserId=\(appleUserId)")
        
        loginLoading = true
        
        AuthService.shared.registerDevice(deviceUUID: uuid, deviceName: deviceName, appleUserId: appleUserId) { success in
            DispatchQueue.main.async {
                loginLoading = false
                
                if success {
                    print("디바이스 등록 성공")
                    
                    if WCSession.default.isReachable {
                        WCSession.default.sendMessage(
                            ["apple_user_id": appleUserId, "source": "ios"]
                        ) { reply in
                            print("[iOS] apple_user_id 전송 성공: \(reply)")
                        } errorHandler: { error in
                            print("[iOS] apple_user_id 전송 실패: \(error.localizedDescription)")
                        }
                    }
                    
                    isAgreed = true
                } else {
                    errorMessage = "서버 등록 실패. 다시 시도해 주세요."
                    showErrorAlert = true
                }
            }
        }
    }
}


#Preview {
    ConditionsView()
}

