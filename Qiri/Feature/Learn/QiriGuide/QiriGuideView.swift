//
//  QiriGuideView.swift
//  Qiri
//
//  Created by 김은찬 on 6/2/25.
//

import SwiftUI

struct QiriGuideView: View {
    @StateObject private var viewModel = QiriGuideViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                            
                        Spacer().frame(height: 50)
                        
                        Text("Qiri 사용법")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.customWhite)
                            .padding(.top, -20)
                            .padding(.bottom, 20)
                            .padding(.leading, 40)
                        
                        Image("Main_QiriGuideView")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 390, height: 230)
                            .padding(.leading, 20)
                            .padding(.top, 20)
                        
                        Text("Qiri는 사용자의 Apple Watch에서 질문에 답을\n전하는 지능형 음성 응답 도구입니다. 제스처 또는\n터치 한 번으로 질문을 시작하고, 손쉽게 답변을\n확인할 수 있습니다.")
                            .font(.system(size: 15))
                            .foregroundColor(.customWhite)
                            .padding(.top, 36)
                            .padding(.leading, 40)
                            .lineSpacing(8)
                        
                        VStack(alignment: .leading, spacing: 30) {
                            ForEach(viewModel.QiriGuidecontents, id: \.imageFileName) { content in
                                VStack(alignment: .leading, spacing: 10) {
                                    Image(content.imageFileName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 215, height: 240)
                                        .padding(.bottom, 30)
                                    
                                    Text(content.title)
                                        .font(.system(size: 16))
                                        .fontWeight(.bold)
                                        .foregroundColor(.customWhite)
                                    
                                    
                                    Text(content.explanationText)
                                        .font(.system(size: 13))
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
    QiriGuideView()
}

