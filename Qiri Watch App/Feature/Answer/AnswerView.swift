import SwiftUI

struct AnswerView: View {
    let response: String
    var onQiriTap: (() -> Void)?

    var body: some View {
        VStack(spacing: 18) {
            Spacer()
            
            ZStack {
                Image("Answer_speech")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 163, height: 60)
                    .padding(.top, 15)
                
                Text("답변 확인하기!")
                    .font(.system(size: 13))
                    .fontWeight(.bold)
            }
            .padding(.bottom, -10)
            
            Image("Answer_Qiri")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 77)
                .padding(.bottom, 50)
                .onTapGesture {
                    onQiriTap?()
                    NotificationCenter.default.post(name: .moveToAnswerMore, object: nil)
                }
        }
        .frame(maxWidth: .infinity)
        .background(.customBackgroundBlack)
        .foregroundColor(.customWhite)
    }	
}

#Preview {
    AnswerView(response: "")
}

extension Notification.Name {
    static let moveToAnswerMore = Notification.Name("moveToAnswerMore")
}

