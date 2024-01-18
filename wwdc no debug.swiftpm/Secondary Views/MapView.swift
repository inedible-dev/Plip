import SwiftUI
import MapKit

struct AppleMapView: View {
    
    let travelSpot: TravelSpot
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 100.0, longitudeDelta: 100.0))
    
    @State var showingOptions: Bool = false
    
    @Environment(\.openURL) var openURL
    
    
    
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [TravelSpot(id: travelSpot.id, tag: travelSpot.tag, name: travelSpot.name, latitude: travelSpot.latitude, longitude: travelSpot.longitude, cover: travelSpot.cover, images: travelSpot.images, description: travelSpot.description, fee: travelSpot.fee)]) {
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)) {
                MapAnnotationView(travelSpot: travelSpot)
            }
        }
        .cornerRadius(15)
        .overlay(alignment: .bottomTrailing) {
            
            GroupBox {
                Image(systemName: "location.north.circle")
                    .font(.title)
            }
            .confirmationDialog("Select an app to open in (app must be installed)", isPresented: $showingOptions, titleVisibility: .visible) {
                Button("Google Maps") {
                    openURL(URL(string: "comgooglemaps://?saddr=&daddr=\(travelSpot.latitude),\(travelSpot.longitude)&directionsmode=driving")!)
                }
                
                Button("Apple Maps") {
                    openURL(URL(string: "maps://?saddr=&daddr=\(travelSpot.latitude),\(travelSpot.longitude)")!)
                }
            }
            .cornerRadius(90)
            .padding()
            .onTapGesture {
                showingOptions = true
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    
    static let travelSpots: [TravelSpot] = Bundle.main.decode("data.json")
    
    
    static var previews: some View {
        AppleMapView(travelSpot: travelSpots[1])
            .padding()
    }
}
