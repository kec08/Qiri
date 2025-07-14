//
//  AssistiveView.swift
//  Qiri
//
//  Created by 김은찬 on 6/4/25.
//


import SwiftUI

struct AssistitveView: View {
    @StateObject private var viewModel = AssistiveViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {                      
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 50)

                    Text("assistive touch 설정")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.customWhite)
                        .padding(.top, -20)
                        .padding(.bottom, 20)
                        .padding(.leading, 40)

                    Image("Main_assistive touch")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 346, height: 148)
                        .padding(.leading, 40)
                        .padding(.top, 20)

                    Text("AssistiveTouch는 Qiri 재스처 호출을 사용할 수\n있도록 도와주는 손쉬운 사용 기능입니다.\n제스처를 통하여 Qiri를 호출할 수 있는 이 기능을\n활성화하여 더욱 간편하게 활용 해 보세요.")
                        .font(.system(size: 15))
                        .foregroundColor(.customWhite)
                        .padding(.top, 36)
                        .padding(.leading, 40)
                        .lineSpacing(8)

                    VStack(alignment: .leading, spacing: 30) {
                        ForEach(viewModel.Assistivecontents, id: \.imageFileName) { content in
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
                        dismiss() // 이전 화면으로 "pop" 애니메이션과 함께 돌아감
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
    AssistitveView()
}

