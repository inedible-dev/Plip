import SwiftUI

struct MapFullScreenView: View {
    
    let travelSpot: TravelSpot
    
    
    var body: some View {
        AppleMapView(travelSpot: travelSpot)
            .padding(8)
    }
}

struct TestView_Previews: PreviewProvider {
    
    static let travelSpots: [TravelSpot] =  Bundle.main.decode("data.json")
    
    static var previews: some View {
        MapFullScreenView(travelSpot: travelSpots[0])
    }
}
