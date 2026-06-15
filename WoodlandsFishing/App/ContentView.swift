import SwiftUI

struct ContentView: View {
    @Environment(UserDataStore.self) private var userData
    @State private var showingOnboarding = false

    var body: some View {
        TabView {
            MapTabView()
                .tabItem { Label("Map", systemImage: "map") }
            ListTabView()
                .tabItem { Label("Spots", systemImage: "list.bullet") }
            PermitsTabView()
                .tabItem { Label("Permits", systemImage: "doc.text") }
        }
        .sheet(isPresented: $showingOnboarding, onDismiss: {
            userData.hasSeenOnboarding = true
        }) {
            OnboardingSheet()
        }
        .onAppear {
            if !userData.hasSeenOnboarding {
                showingOnboarding = true
            }
        }
    }
}
