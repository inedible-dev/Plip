import SwiftUI

struct GalleryView: View {
    
    let travelSpot: TravelSpot
    
    var body: some View {
        TabView {
            ForEach(travelSpot.images, id: \.self) { item in
                Image(uiImage: Bundle.main.retrieveImageLocally(imageName: item)!)
                    .resizable()
                    .scaledToFill()
            } // ForEach
        }// TabView
        .tabViewStyle(PageTabViewStyle())
    }
}

struct GalleryView_Previews: PreviewProvider {
    
    static let travelSpots: [TravelSpot] = Bundle.main.decode("data.json")
    
    static var previews: some View {
        GalleryView(travelSpot: travelSpots[0])
            .padding()
    }
}
