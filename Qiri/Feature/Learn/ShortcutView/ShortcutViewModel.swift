//
//  ShortcutViewModel.swift
//  Qiri
//
//  Created by 김은찬 on 6/6/25.
//

import Foundation

class ShortcutViewModel: ObservableObject {
    @Published var Shortcutcontents: [LearnContent]
    
    init(
        contents: [LearnContent] = [
            .init(
              imageFileName: "ShortcutView_img1",
              title:"iPhone에서 단축어 앱을 여십시오",
              explanationText: "⦁ iPhone에서 단축어 앱을 실행하십시오.\n⦁ 하단의 보관함 탭이 선택되어 있는지 확인하십시오.",
            ),
          .init(
            imageFileName: "ShortcutView_img2",
            title:"상단 +버튼을 눌러 단축어를 추가하십시오",
            explanationText: "⦁ 오른쪽 상단 +버튼을 눌러 새로운 단축어를 추가\n   하십시오.",
          ),
            .init(
              imageFileName: "ShortcutView_img3",
              title:"동작에 앱 열기를 누르십시오",
              explanationText: "⦁ 동작에 메뉴에 있는 앱 열기를 클릭하여 추가 하십시오.\n⦁ 메뉴에 앱 열기가 뜨지 않는다면 검색에 앱 열기를\n   검색하여 추가 하십시오.",
            ),
          .init(
            imageFileName: "ShortcutView_img4",
            title:"앱을 클릭하여 Qiri를 추가 하십시오",
            explanationText: "⦁앱 열기 택스트 중 “앱”을 클릭하여 다운르드한 Qiri를\n   추가 하십시오.\n⦁ 검색창에 Qiri를 검색하여 추가 하십시오.",
          ),
          .init(
            imageFileName: "ShortcutView_img5",
            title:"단축어 이름을 바꾸십시오 (선택)",
            explanationText: "⦁위 단축어 아이콘을 눌러 이름및 아이콘 변경이 가능합니다.\n⦁ 단축어 이름을 자유롭게 작성하십시오.",
          )
      ]
    ) {
      self.Shortcutcontents = contents
    }
}
