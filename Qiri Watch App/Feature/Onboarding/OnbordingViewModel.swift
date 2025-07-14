//
//  OnbordingViewModel.swift
//  Qiri
//
//  Created by 김은찬 on 5/7/25.
//

import Foundation

class OnboardingViewModel: ObservableObject {
  @Published var onboardingContents: [OnboardingContent]
  
  init(
    onboardingContents: [OnboardingContent] = [
        .init(
          imageFileName: "onboarding_Apple",
          title: "Apple 계정으로 로그인",
          subTitle: "iPhone에서 Qiri앱을 다운 받아\nApple 계정으로 로그인하여\nQiri를 시작해주세요."
        ),
      .init(
        imageFileName: "onboarding_Qiri",
        title: "Qiri를 클릭하여 호출",
        subTitle: "Qiri 클릭하면 사용자의 탭을 \n 감지하여 Qiri를 \n 호출 할 수 있습니다."
      ),
      .init(
        imageFileName: "onboarding_Gesture",
        title: "손 재스처를 이용한 Qiri 호출",
        subTitle: "AssistiveTouch를 활성화 하고\n  손 재스처 동작만으로도\n Qiri를 호출할 수 있습니다."
      )
    ]
  ) {
    self.onboardingContents = onboardingContents
  }
}

