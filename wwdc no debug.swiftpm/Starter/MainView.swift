import SwiftUI

struct MainView: View {
    
    var body: some View {
            TabView {
                ExploreView()
                    .tabItem {
                        Image(systemName: "square.grid.2x2")
                        Text("Explore")
                    }
                AllMapView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("Location")
                    }
                
            }
    }
}

