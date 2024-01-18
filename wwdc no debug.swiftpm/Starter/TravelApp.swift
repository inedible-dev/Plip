import SwiftUI
import LocalAuthentication


@main
struct TravelApp: App {
    var dataJson: [TravelSpot]
    @State private var isUnlocked = false
    @State private var cannotUnlock = false
    
    init() {
        print("init")
        dataJson = Bundle.main.loadJSONDataFromFile(fileName: "data", type: [TravelSpot].self) ?? []
    }
    
    
    var body: some Scene {
        WindowGroup {
                
                MainView()
        }
    }
}
