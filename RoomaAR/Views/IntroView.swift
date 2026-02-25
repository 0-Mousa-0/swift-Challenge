import SwiftUI

/// Onboarding screen introducing RoomaAR.
struct IntroView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.16, green: 0.19, blue: 0.44), Color(red: 0.26, green: 0.09, blue: 0.39)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 22) {
                Spacer()

                Text("RoomaAR")
                    .font(.system(size: 46, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Visualize furniture with a fast AR workflow on device and a simulator-friendly fallback.")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.94))
                    .padding(.horizontal, 28)

                VStack(alignment: .leading, spacing: 10) {
                    introBullet("Scan with camera on real device for AR mode.")
                    introBullet("Use simulator mode to test UI and placement flow.")
                    introBullet("Pick furniture, tap to place, and reset anytime.")
                }
                .padding(18)
                .frame(maxWidth: 540)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .padding(.horizontal, 24)

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.30)) {
                        appState.showIntro = false
                    }
                } label: {
                    Text("Start Experience")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                        .background(Color.green.opacity(0.92))
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
                }
                .padding(.bottom, 36)
            }
        }
    }

    private func introBullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(Color.white.opacity(0.92))
                .frame(width: 8, height: 8)
                .padding(.top, 6)

            Text(text)
                .foregroundColor(.white.opacity(0.95))
                .font(.subheadline)
                .multilineTextAlignment(.leading)
        }
    }
}
