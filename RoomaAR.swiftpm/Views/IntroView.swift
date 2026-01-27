import SwiftUI

/// Simple onboarding screen that explains the app and starts the AR experience.
struct IntroView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Text("RoomaAR")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Visualize furniture in your real room using Augmented Reality.\n\nMove your iPad around slowly to scan your space, then pick items and place them on detected surfaces.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 32)

                Spacer()

                Button(action: {
                    withAnimation(.easeInOut) {
                        appState.showIntro = false
                    }
                }) {
                    Text("Start AR Experience")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                        .background(Color.green.opacity(0.9))
                        .clipShape(Capsule())
                        .shadow(radius: 8)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
            .environmentObject(AppState())
    }
}

