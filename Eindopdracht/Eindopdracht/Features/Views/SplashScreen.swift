import SwiftUI

struct SplashScreen: View {
    // When the value changes, SwiftUI automatically re-renders the view.
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.8
    @State private var opacity: Double = 0.3
    
    var body: some View {
        if isActive {
            HomeView()
        } else {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image(systemName: "flame.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.white)
                        .scaleEffect(logoScale)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.2)) {
                                logoScale = 1.1
                                opacity = 1.0
                            }
                        }
                    
                    Text("FitTrack")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(opacity)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
