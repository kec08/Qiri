import SwiftUI

struct QuestionErrorView: View {
    var onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Spacer()

            Text("오류가 발생 했습니다.")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.customWhite)
                .multilineTextAlignment(.center)

            Text("WiFi 연결을 확인하고\n재시도 해주세요.")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.customWhite)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .padding(.vertical, 4)

            Button(action: {
                onConfirm()
            }) {
                Text("확인")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.customWhite)
                    .frame(width: 120, height: 32)
                    .background(Color.customOrange)
                    .cornerRadius(6)
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
        .background(Color.customBackgroundBlack)
        .foregroundColor(.customWhite)
    }
}

#Preview {
    QuestionErrorView(onConfirm: {})
}
