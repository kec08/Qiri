//
//  ShortcutView.swift
//  Qiri
//
//  Created by 김은찬 on 6/2/25.
//

import SwiftUI

struct CustomView: View {
    @StateObject private var viewModel = CustomViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 50)

                    Text("assistive touch 커스텀")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.customWhite)
                        .padding(.top, -20)
                        .padding(.bottom, 20)
                        .padding(.leading, 40)
                    
                    Image("Main_CustomView")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 390, height: 292)
                        .padding(.trailing, 20)
                        .padding(.top, 20)

                    Text("AssistiveTouch 제스처를 커스텀하여 Qiri 앱을\n더욱 효과적으로 사용해보십시오. 단축어와 함께\n설정하여 Qiri를 더 간편하게 실행하고 호출 할 수\n있습니다.")
                        .font(.system(size: 15))
                        .foregroundColor(.customWhite)
                        .padding(.leading, 40)
                        .lineSpacing(8)

                    VStack(alignment: .leading, spacing: 30) {
                        ForEach(viewModel.Customcontents, id: \.imageFileName) { content in
                            VStack(alignment: .leading, spacing: 10) {
                                Image(content.imageFileName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 218, height: 448)
                                    .padding(.bottom, 30)

                                Text(content.title)
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(.customWhite)

                                Text(content.explanationText)
                                    .font(.system(size: 14))
                                    .foregroundColor(.customWhite)
                                    .lineSpacing(8)
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                    .padding(.top, 40)

                    Button(action: {
                        dismiss()
                    }) {
                        Text("확인")
                            .font(.system(size: 16))
                            .foregroundColor(.customOrange)
                            .padding(.top, 45)
                            .padding(.leading, 190)
                    }
                }
            }
            .background(Color.customBackgroundBlack)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    CustomView()
}
