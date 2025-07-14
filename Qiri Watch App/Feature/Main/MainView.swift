import SwiftUI
import WatchKit

struct MainView: View {
    @State private var currentTime = ""
    @State private var spokenText: String = ""
    @State private var timer: Timer?
    
    var onQiriMainTap: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 18) {
            Spacer()
            
            Text(currentTime)
                .font(.system(size: 48))
                .fontWeight(.bold)
            
            Image("Main_Sleep_Qiri")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 77)
                .padding(.bottom, 50)
                .onTapGesture {
                    onQiriMainTap?()
                }
            
        }
        .frame(maxWidth: .infinity)
        .background(.customBackgroundBlack)
        .foregroundColor(.customWhite)
        .onAppear {
            print("MainView onAppear 호출")
            startTimeUpdate()
        }
        .onDisappear {
            print("MainView onDisappear 호출")
            timer?.invalidate()
            timer = nil
        }
    }
    
    // MARK: - 시간 업데이트 시작
    private func startTimeUpdate() {
        updateTime()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateTime()
        }
    }
    
    // MARK: - 시간 표현 형식
    private func updateTime() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "h:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        currentTime = formatter.string(from: Date())
    }
}



