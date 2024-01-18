import SwiftUI
import MapKit

struct PlaceListView: View {
    
    let travelSpot: TravelSpot
    
    var body: some View {
        HStack {
            Image(uiImage: Bundle.main.retrieveImageLocally(imageName: travelSpot.images[0])!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 300, maxHeight: 100)
                .scaledToFill()
                .frame(width: 90, height: 90, alignment: .center)
                .clipShape(Rectangle().size(width: 90, height: 90))
                .cornerRadius(12)
            VStack(alignment: .leading, spacing: 12) {
                Text(travelSpot.name)
                    .fontWeight(.bold)
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                Text(travelSpot.description)
                    .lineLimit(2)
                    .font(.footnote)
            }
            .padding(8)
            
        }
    }
}

struct PlaceListView_Previews: PreviewProvider {
    
    static let travelSpots: [TravelSpot] = Bundle.main.decode("data.json")
    
    static var previews: some View {
        PlaceListView(travelSpot: travelSpots[0])
            .padding()
    }
}
