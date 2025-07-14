//
//  QiriGuideViewModel.swift
//  Qiri
//
//  Created by 김은찬 on 6/6/25.
//

import Foundation

class QiriGuideViewModel: ObservableObject {
    @Published var QiriGuidecontents: [LearnContent]
    
    init(
        contents: [LearnContent] = [
          .init(
            imageFileName: "QiriGuideView_img1",
            title:"Qiri 호출하기",
            explanationText: "⦁ 손 제스처 사용\n손 제스처 기능이 활성화되어 있다면, 설정한 제스처를 통해 Qiri를 빠르게 불러올 수 있습니다.\n⦁ Qiri 탭하기\nQiri를 탭하여 직접 실행할 수도 있습니다.",
          ),
        .init(
          imageFileName: "QiriGuideView_img2",
          title:"질문하기",
          explanationText: "Qiri가 활성화되면 다음 메시지가 나타납니다\n“무엇이든 질문해보세요.”\n질문을 음성으로 말씀하십시오.\n⦁ “지금 날씨 어때?”\n⦁ “기억력 높이는 팁 알려줘.”\n⦁ “저녁 메뉴 추천 해줘.”",
        ),
          .init(
            imageFileName: "QiriGuideView_img3",
            title:"답변 생성",
            explanationText: "Qiri는 음성을 분석한 뒤, 관련된 정보를 정리하여 답변을 생성합니다.\n 화면에 “두뇌 회전중...” 등 다양한 표시가 나타납니다.",
          ),
        .init(
          imageFileName: "QiriGuideView_img4",
          title:"답변 확인하기",
          explanationText: "Qiri가 답변을 준비하면, 화면에 ‘답변 확인하기’ 버튼이 표시됩니다.\n버튼을 탭하여 내용을 확인하십시오.\n⦁ Qiri는 간결하고 명확한 형태로 답변을 제공합니다.\n⦁ 긴 내용의 경우 스크롤하여 끝까지 읽을 수 있습니다.",
        )
      ]
    ) {
      self.QiriGuidecontents = contents
    }
}
