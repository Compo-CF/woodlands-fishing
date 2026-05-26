import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MapTabView()
                .tabItem { Label("Map", systemImage: "map") }
            ListTabView()
                .tabItem { Label("Spots", systemImage: "list.bullet") }
            PermitsTabView()
                .tabItem { Label("Permits", systemImage: "doc.text") }
        }
    }
}
