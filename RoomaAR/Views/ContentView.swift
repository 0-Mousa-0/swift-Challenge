import SwiftUI

/// Root view that toggles between onboarding and experience modes.
struct ContentView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Group {
            if appState.showIntro {
                IntroView()
            } else {
                experienceView
            }
        }
    }

    private var experienceView: some View {
        ZStack(alignment: .top) {
#if targetEnvironment(simulator)
            SimulatorRoomView()
#else
            ARViewContainer()
#endif

            VStack(spacing: 14) {
                topBar
                Spacer()
                bottomPanel
            }
            .padding(.horizontal, 14)
            .padding(.top, 14)
            .padding(.bottom, 20)
        }
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            Text("RoomaAR")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.50))
                .clipShape(Capsule())

            Spacer()

            Text("Placed: \(appState.placementsCount)")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.45))
                .clipShape(Capsule())

            Button {
                appState.resetSceneToggle = true
            } label: {
                Text("Reset")
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.red.opacity(0.88))
                    .clipShape(Capsule())
            }
        }
    }

    private var bottomPanel: some View {
        VStack(spacing: 10) {
            FurniturePickerView()

            Text(appState.statusMessage)
                .font(.footnote.weight(.medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.58))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}
