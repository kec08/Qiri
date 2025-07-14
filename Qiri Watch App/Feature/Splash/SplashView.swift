//
//  SplashView.swift
//  Qiri
//
//  Created by 김은찬 on 5/7/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(spacing: 18) {
            Spacer()
            
            Image("onboarding_Qiri")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .padding(.top, 33)
            
            Text("Qiri")
                .font(.system(size:32))
                .fontWeight(.semibold)
                .padding(.bottom, 53)
        }
        .frame(maxWidth: .infinity)
        .background(.customBackgroundBlack)
        .foregroundColor(.customWhite)
    }
        
    
}

#Preview {
    SplashView()
}
