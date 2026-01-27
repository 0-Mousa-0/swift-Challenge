import SwiftUI

/// Entry point for the RoomaAR SwiftUI app.
@main
struct RoomaARApp: App {
    /// Shared global app state used across views.
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

