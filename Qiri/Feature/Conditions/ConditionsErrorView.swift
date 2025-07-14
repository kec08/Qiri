import SwiftUI

struct ConditionsErrorView: View {
    var onConfirm: () -> Void

    var body: some View {
        VStack {
            Spacer()
            
            Text("등록되지 않은 디바이스 입니다.")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.customWhite)
                .padding(.bottom, 20)
            
            Text("약관에 동의하지 않아 진행할 수 없습니다.\n확인 시 로그인 뷰로 이동합니다.")
                .font(.system(size: 16))
                .foregroundColor(.customWhite)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
                .lineSpacing(5)
            
            Button(action: {
                onConfirm()
            }) {
                Text("확인")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.customBackgroundBlack)
                    .frame(width: 288, height: 60)
                    .background(Color.white)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.customBackgroundBlack)
    }
}

