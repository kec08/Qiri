//
//  assistiveViewModel.swift
//  Qiri
//
//  Created by 김은찬 on 6/4/25.
//

import Foundation

class AssistiveViewModel: ObservableObject {
    @Published var Assistivecontents: [LearnContent]
    
    init(
        contents: [LearnContent] = [
          .init(
            imageFileName: "assistiveView_img1",
            title:"iPhone에서 Watch 앱을 여십시오",
            explanationText: "⦁ iPhone에서 Watch 앱을 실행하십시오.\n⦁ 하단의 나의 시계 탭이 선택되어 있는지 확인하십시오.",
          ),
        .init(
          imageFileName: "assistiveView_img2",
          title:"손쉬운 사용 메뉴로 이동하십시오",
          explanationText: "⦁ 아래로 스크롤하여 손쉬운 사용 항목을 찾으십시오.\n⦁ 손쉬운 사용을 탭한 후 스크롤 하여AssistiveTouch를 선택하십시오.",
        ),
          .init(
            imageFileName: "assistiveView_img3",
            title:"AssistiveTouch를 켜십시오",
            explanationText: "⦁ AssistiveTouch 화면으로 이동한 후, 상단의 스위치를 켬으로 설정하십시오.\n⦁ 설정이 완료되면, Apple Watch에서 제스처를 통해 Qiri를 호출 할 수 있습니다.",
          ),
        .init(
          imageFileName: "assistiveView_img4",
          title:"제스처 및 동작을 사용자화하십시오 (선택)",
          explanationText: "⦁ 제스처 사용 설정: 손을 쥐기, 두 번 쥐기, 핀치 등의 동작을 활성화하거나 비활성화할 수 있습니다.\n⦁ 동작 사용자화: 각 제스처에 원하는 기능을 지정할 수 있습니다.\n⦁ 모션 포인터: 화면 위 포인터를 손의 움직임으로 조작할 수 있도록 설정하십시오.",
        )
      ]
    ) {
      self.Assistivecontents = contents
    }
}
