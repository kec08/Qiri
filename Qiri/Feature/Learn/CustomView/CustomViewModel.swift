//
//  ShortcutViewModel.swift
//  Qiri
//
//  Created by 김은찬 on 6/6/25.
//

import Foundation

class CustomViewModel: ObservableObject {
    @Published var Customcontents: [LearnContent]
    
    init(
        contents: [LearnContent] = [
            .init(
                imageFileName: "CustomView_img1",
                title:"iPhone에서 watch 앱을 여십시오",
                explanationText: "⦁ iPhone에서 watch 앱을 실행하십시오.\n⦁ 하단의 나의 시계 탭이 선택되어 있는지 확인하십시오.",
            ),
          .init(
            imageFileName: "CustomView_img2",
            title:"손쉬운 사용을 누르십시오",
            explanationText: "⦁ 스크롤하여 손쉬운 사용을 찾아 탭하십시오.\n⦁ 손쉬운 사용에서 AssistiveTouch를 찾으십시오.",
          ),
            .init(
              imageFileName: "CustomView_img3",
              title:"AssistiveTouch를 누르십시오",
              explanationText: "⦁ 만약 AssistiveTouch가 비활성화 되어 있다면 활성화\n    하십시오.",
            ),
          .init(
            imageFileName: "CustomView_img4",
            title:"손 제스처를 누르십시오",
            explanationText: "⦁ Qiri를 사용하기 위해 제스처를 커스텀 하십시오..\n⦁ 지금 화면에 보이는 설정이 Qiri를 사용하기 위한 최적의\n    설정입니다.",
          ),
          .init(
            imageFileName: "CustomView_img5",
            title:"단축어 이름을 바꾸십시오 (선택)",
            explanationText: "⦁ 탭을 클릭하여 들어온 뒤 일반에 탭 설정을 활성화\n    하십시오.\n⦁ 직접 만든 Qiri 앱 실행 단축어는 밑에 있으니 원하는\n    제스처에 설정하여 보십시오.",
          ),
            .init(
              imageFileName: "CustomView_img6",
              title:"탭 모양을 변경 하십시오 (선택)",
              explanationText: "⦁ 뒤로가기를 하여 Assistive Touch로 이동한뒤\n    스크롤하여모양 설정에 색상을 찾으십시오.",
            ),
            .init(
              imageFileName: "CustomView_img7",
              title:"원하는 색상을 선택하십시오",
              explanationText: "⦁ 원하는 색상을 클릭하여 탭 선택 영역의 색을 커스텀\n    해 보십시오.",
            )
      ]
    ) {
      self.Customcontents = contents
    }
}
