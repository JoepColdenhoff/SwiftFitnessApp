import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("gym")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Spacer()
                    Text("FitTrack")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    Text("Your personal fitness companion")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    NavigationLink(destination: WorkoutListView()) {
                        HStack {
                            Image(systemName: "play.fill")
                                .foregroundColor(.white.opacity(0.9))
                                .font(.title2)
                            
                            Text("Start")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .frame(width: 200, height: 70)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .shadow(radius: 10)
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    HomeView()
}
