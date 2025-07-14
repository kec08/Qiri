//
//  ShortcutView.swift
//  Qiri
//
//  Created by 김은찬 on 6/2/25.
//

import SwiftUI

struct ShortcutView: View {
    @StateObject private var viewModel = ShortcutViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 50)

                    Text("단축어 설정")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.customWhite)
                        .padding(.top, -20)
                        .padding(.bottom, 20)
                        .padding(.leading, 40)
                    
                    Image("Main_ShortcutView")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 390, height: 191)
                        .padding(.trailing, 20)
                        .padding(.top, 20)

                    Text("간단한 단축어 하나로 Qiri 실행을 손쉽게 실행 할\n수 있습니다. AssistiveTouch와 함께 설정하여\n제스처 한 번으로 Qiri가 바로 실행됩니다. 지금 \nWatch에서 사용할 Qiri 실행 단축어를 만들어 보세요.")
                        .font(.system(size: 15))
                        .foregroundColor(.customWhite)
                        .padding(.top, 36)
                        .padding(.leading, 40)
                        .lineSpacing(8)

                    VStack(alignment: .leading, spacing: 30) {
                        ForEach(viewModel.Shortcutcontents, id: \.imageFileName) { content in
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
    ShortcutView()
}
