//
//  SplashView.swift
//  Qiri
//
//  Created by 김은찬 on 5/7/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image("Login_Qiri")
                .resizable()
                .scaledToFit()
                .frame(width: 133, height: 133)
            
            
            Text("Qiri")
                .font(.system(size:60))
                .fontWeight(.bold)
                .padding(.bottom, 320)
        }
        .frame(maxWidth: .infinity)
        .background(.customBackgroundBlack)
        .foregroundColor(.customWhite)
        
    }
}

#Preview {
    SplashView()
}

