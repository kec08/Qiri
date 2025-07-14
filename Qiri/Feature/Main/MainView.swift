import SwiftUI

// MARK: - 자세히 보기 버튼
struct DetailButton: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 11, weight: .bold))
            .frame(width: 90, height: 30)
            .foregroundColor(.white)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white, lineWidth: 2)
            )
            .cornerRadius(30)
    }
}

// MARK: - 메인뷰
struct MainView: View {
    var body: some View {
        NavigationStack {
            MainContentView()
                .navigationBarHidden(true)
        }
    }
}

// MARK: - 메인컨텐츠 뷰
struct MainContentView: View {
    @State private var goUserView = false
    @State private var goMoreView = false
    
    var body: some View {
        VStack {
            HStack {
                Image("Main_QiriLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 29)
                    .padding(.top, 30)

                Spacer()
                    .frame(width: 246)

                Button(action: {
                    print("내 프로필 클릭됨")
                    goUserView = true
                }) {
                    Image("Main_User_Icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 19)
                        .padding(.top, 30)
                }
                .navigationDestination(isPresented: $goUserView) {
                    UserView()
                }
            }

            Spacer().frame(height: 50)

            HStack {
                Text("Qiri 가이드")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.customWhite)
                    .padding(.leading, 30)

                Spacer().frame(width: 205)

                Button(action: {
                    print("더보기 클릭됨")
                    goMoreView = true
                }) {
                    Text("더보기")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.customGray)
                        .padding(.trailing, 25)
                }
                .navigationDestination(isPresented: $goMoreView) {
                    MoreView()
                }
            }

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

                    ZStack {
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color:Color.black.opacity(0.0), location: 0.0),
                                .init(color: Color.black.opacity(1.0), location: 1.0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(width: 390,height: 231)
                        .zIndex(11)
                        .padding(.bottom, -100)

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
                        .opacity(0.7)
                    }

                    Button(action: {
                        print("모두 보기 클릭됨")
                        goMoreView = true
                    }) {
                        Text("모두 보기")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                            .frame(width: 100, height: 37)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.top, -15)
                    }
                    
                }
            }

            Spacer()
                .frame(height: 32)
        }
        .frame(maxWidth: .infinity)
        .background(Color.customBackgroundBlack)

    }
}

// MARK: - 미리보기
#Preview {
    MainView()
}


