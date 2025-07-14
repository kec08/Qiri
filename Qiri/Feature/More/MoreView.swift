//
//  MoreView.swift
//  Qiri
//
//  Created by 김은찬 on 6/17/25.
//

import SwiftUI

// MARK: - 메인뷰
struct MoreView: View {
    var body: some View {
        NavigationStack {
            MoreContentView()
                .navigationBarHidden(false)
        }
    }
}

// MARK: - 메인컨텐츠 뷰
struct MoreContentView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {

            VStack {
                ScrollView(showsIndicators: false) {
                    Image("Main_assistive touch")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 346, height: 148)
                        .padding(.trailing, 48)
                        .padding(.top, 20)

                    Text("assistive touch 설정")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.customWhite)
                        .multilineTextAlignment(.leading)
                        .padding(.top, -15)
                        .padding(.trailing, 160)

                    NavigationLink(destination: AssistitveView()) {
                        DetailButton(title: "자세히 보기")
                    }
                    .padding(.trailing, 270)
                    
                    Image("Main_CustomView")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 390, height: 250)
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)

                    Text("assistive touch 커스텀")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.customWhite)
                        .multilineTextAlignment(.leading)
                        .padding(.top, -15)
                        .padding(.trailing, 145)

                    NavigationLink(destination: CustomView()) {
                        DetailButton(title: "자세히 보기")
                    }
                    .padding(.trailing, 270)

                    Image("Main_QiriUse")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 154, height: 252)
                        .padding(.leading, 180)
                        .padding(.top, 20)
                    
                    

                    Text("Qiri 사용법")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.customWhite)
                        .multilineTextAlignment(.leading)
                        .padding(.top, -100)
                        .padding(.trailing, 250)

                    NavigationLink(destination: QiriGuideView()) {
                        DetailButton(title: "자세히 보기")
                    }
                    .padding(.trailing, 270)
                    .padding(.top, -70)

                    //단축어 설정
                    ZStack {
                        Image("Main_shortcut")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 171, height: 178)
                            .padding(.leading, 180)
                            .padding(.top, 20)

                        Image("Main_shortcut_Icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .padding(.trailing, 140)
                            .padding(.top, -100)
                            .zIndex(1)

                        Text("단축어 설정")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.customWhite)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 50)
                            .padding(.trailing, 250)

                        NavigationLink(destination: ShortcutView()) {
                            DetailButton(title: "자세히 보기")
                        }
                        .padding(.trailing, 270)
                        .padding(.top, 130)
                        .zIndex(11)
//                        .opacity(0.7)
                    }
                }
            }
            
            Button(action: {
                dismiss()
            }) {
                Text("확인")
                    .font(.system(size: 15))
                    .foregroundColor(.customOrange)
                    .padding(.top, 15)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.customBackgroundBlack)

    }
}

// MARK: - 미리보기
#Preview {
    MoreView()
}


