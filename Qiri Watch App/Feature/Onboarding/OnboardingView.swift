import SwiftUI

struct OnboardingView: View {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @State private var selectedIndex: Int = 0
    @Binding var isOnboardingComplete: Bool 
    
    var onComplete: () -> Void
    private let totalPages = 3

    var body: some View {
        VStack(spacing: 12) {
            Spacer()

            let content = onboardingViewModel.onboardingContents[min(selectedIndex, totalPages - 1)]
            
            Image(content.imageFileName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)

            Text(content.title)
                .font(.system(size: selectedIndex == totalPages - 1 ? 14 : 16))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)

            Text(content.subTitle)
                .multilineTextAlignment(.center)
                .font(.system(size: 10, weight: .medium))
                .lineLimit(nil)
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, -5)
                .lineSpacing(3)

            ZStack {
                Rectangle()
                    .fill(selectedIndex == totalPages - 1 ? Color.customOrange : Color.customGray)
                    .frame(width: 92, height: 32)
                    .cornerRadius(6)

                Button(
                    action: {
                        withAnimation(.easeInOut) {
                            if selectedIndex < totalPages - 1 {
                                selectedIndex += 1
                            } else {
                                isOnboardingComplete = true
                                UserDefaults.standard.set(true, forKey: "isOnboardingComplete") //재시작 시 온보딩을 건너뛰기 위해 상태 저장
                                onComplete()
                            }
                        }
                    }
                ) {
                    Text(selectedIndex == totalPages - 1 ? "시작하기" : "다음")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.customWhite)
                        .frame(width: 92, height: 32)
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal, selectedIndex == 0 ? 10 : (selectedIndex == 1 ? 15 : 10))
        .background(.customBackgroundBlack)
        .foregroundColor(.customWhite)
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false), onComplete: {})
}

