import SwiftUI

/// Main container view that switches between the intro screen and the AR experience.
struct ContentView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Group {
            if appState.showIntro {
                IntroView()
            } else {
                arExperienceView
            }
        }
    }

    /// The primary AR experience layout.
    private var arExperienceView: some View {
        ZStack(alignment: .top) {
            // Full-screen AR camera view.
            ARViewContainer()
                .ignoresSafeArea()

            VStack {
                // Top bar with title and reset button.
                HStack {
                    Text("RoomaAR")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Capsule())

                    Spacer()

                    Button(action: {
                        appState.resetSceneToggle = true
                    }) {
                        Text("Reset")
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.red.opacity(0.8))
                            .clipShape(Capsule())
                    }
                }
                .padding([.top, .horizontal])

                Spacer()

                VStack(spacing: 10) {
                    // Furniture picker.
                    FurniturePickerView()

                    // Status / helper text.
                    Text(appState.statusMessage)
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
    }
}

