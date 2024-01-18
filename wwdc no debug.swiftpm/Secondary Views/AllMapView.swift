import SwiftUI
import MapKit

struct AllMapView: View {
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 100.0, longitudeDelta: 100.0))
    
    @State private var travelSpots: [TravelSpot] = Bundle.main.loadJSONDataFromFile(fileName: "data.json", type: [TravelSpot].self) ?? []
    
    @State var showingOptions: Bool = false
    
    @Environment(\.openURL) var openURL
    
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: travelSpots, annotationContent: { item in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)) {
                MapAnnotationView(travelSpot: item)
                    .confirmationDialog("Select an app to open in (app must be installed)", isPresented: $showingOptions, titleVisibility: .visible) {
                        Button("Google Maps") {
                            openURL(URL(string: "comgooglemaps://?saddr=&daddr=\(item.latitude),\(item.longitude)&directionsmode=driving")!)
                        }
                        
                        Button("Apple Maps") {
                            openURL(URL(string: "maps://?saddr=&daddr=\(item.latitude),\(item.longitude)")!)
                        }
                    }
            }
        })
        .overlay(alignment: .topTrailing) {
            
            Button {
                travelSpots = Bundle.main.loadJSONDataFromFile(fileName: "data.json", type: [TravelSpot].self) ?? []
            } label: {
                GroupBox {
                    Image(systemName: "arrow.counterclockwise.circle")
                        .font(.title)
                }
                .cornerRadius(90)
                .padding()
            }
            
        }
        
    }
}

struct AllMapView_Previews: PreviewProvider {
    static var previews: some View {
        AllMapView()
    }
}

