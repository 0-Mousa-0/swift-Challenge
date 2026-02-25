import SwiftUI
import PlaygroundSupport

let appState = AppState()
let rootView = ContentView()
    .environmentObject(appState)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.setLiveView(rootView)
