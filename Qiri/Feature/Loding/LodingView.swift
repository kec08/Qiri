//
//  Loding.swift
//  Qiri
//
//  Created by 김은찬 on 6/9/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = false
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()

            ZStack {
                Rectangle()
                    .foregroundColor(Color.customBackgroundBlack)
                    .frame(height: 150)
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                        .padding(.top, 40)
                        .opacity(isLoading ? 1 : 0)

                    Text("로그인 중")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color.customWhite)
                        .padding(.top, 50)
                        .opacity(isLoading ? 1 : 0)
                }
            }
            
        }
        .onAppear {
            startLoading()
        }
    }

    func startLoading() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 100) {
            isLoading = false
        }
    }
}

#Preview {
    LoadingView()
}
