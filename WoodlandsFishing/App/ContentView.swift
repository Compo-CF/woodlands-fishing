import SwiftUI

struct ContentView: View {
    @Environment(SpotStore.self) private var store
    @Environment(UserDataStore.self) private var userData
    @State private var selectedTab: Int = 0
    @State private var showingOnboarding = false
    @State private var showingKofiPrompt = false
    @State private var showingTipJar = false
    @State private var hasRecordedLaunch = false

    var body: some View {
        TabView(selection: $selectedTab) {
            MapTabView()
                .tabItem { Label("Map", systemImage: "map") }
                .tag(0)
            ListTabView()
                .tabItem { Label("Spots", systemImage: "list.bullet") }
                .tag(1)
            PermitsTabView()
                .tabItem { Label("Permits", systemImage: "doc.text") }
                .tag(2)
        }
        .sheet(isPresented: $showingOnboarding, onDismiss: {
            userData.hasSeenOnboarding = true
        }) {
            OnboardingSheet()
        }
        .sheet(isPresented: $showingTipJar) {
            TipJarView()
        }
        .alert("Enjoying the app?", isPresented: $showingKofiPrompt) {
            Button("Not now", role: .cancel) {
                userData.markKofiPromptShown()
            }
            Button("Leave a tip") {
                userData.markKofiPromptShown()
                // Route the prompt into the IAP-backed Tip Jar rather than an
                // external donation URL — keeps the app on Apple's preferred
                // payment path. Ko-fi is still available as a passive option
                // in the About sheet for users who prefer external tipping.
                showingTipJar = true
            }
        } message: {
            Text("This app is built and maintained by one local angler in his spare time. If it's been useful, a small tip helps keep the lake list growing. No pressure either way.")
        }
        .onChange(of: store.pendingDeepLinkedSpotID) { _, newValue in
            if newValue != nil {
                // Switch to the Spots tab so ListTabView can push the
                // detail view onto its own navigation stack.
                selectedTab = 1
            }
        }
        .onAppear {
            guard !hasRecordedLaunch else { return }
            hasRecordedLaunch = true
            userData.recordAppLaunch()
            if !userData.hasSeenOnboarding {
                showingOnboarding = true
            } else if userData.shouldShowKofiPrompt {
                // Brief delay so the prompt doesn't appear instantly on
                // cold launch — gives the app a beat to settle before
                // interrupting the user.
                Task {
                    try? await Task.sleep(for: .seconds(1.5))
                    showingKofiPrompt = true
                }
            }
        }
    }
}
