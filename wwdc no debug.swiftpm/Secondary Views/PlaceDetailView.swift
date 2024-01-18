import SwiftUI
import MapKit

struct PlaceDetailView: View {
    
    let travelSpot: TravelSpot
    @State private var alertShow = false
    @State private var afterDelete = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.1657, longitude: 10.4515), span: MKCoordinateSpan(latitudeDelta: 15.0, longitudeDelta: 15.0))
    
    var body: some View {
        
        
        
        
        if (!afterDelete) {
            ScrollView(.vertical, showsIndicators: false) {
                GalleryView(travelSpot: travelSpot)
                    .frame(height: 300)
                    .cornerRadius(15)
                Text(travelSpot.name)
                    .font(.title)
                    .fontWeight(.bold)
                Divider()
                Text(travelSpot.description)
                    .padding(.horizontal, 0.8)
                Divider()
                NavigationLink(destination: MapFullScreenView(travelSpot: travelSpot)) {
                    GroupBox {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.accentColor)
                            Spacer()
                            Text("Location")
                                .foregroundColor(.accentColor)
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding(.bottom)
                }
                
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    
                    alertShow.toggle()
                    
                } label: {
                    Image(systemName: "trash")
                }
                .alert(Text("Are you sure?"), isPresented: $alertShow) {
                    Button("Cancel", role: .cancel) { }
                    Button("Confirm", role: .destructive) { 
                        let travelSpots = Bundle.main.loadJSONDataFromFile(fileName: "data.json", type: [TravelSpot].self) ?? []
                        let editedSpots = travelSpots.filter { $0.id != travelSpot.id }
                        Bundle.main.saveJSONDataToFile(data: editedSpots, fileName: "data.json")
                        
                        afterDelete = true
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
            }
        } else {
            EmptyView()
        }
        
    }
}

struct PlaceDetailView_Previews: PreviewProvider {
    
    static let travelSpots: [TravelSpot] = Bundle.main.decode("data.json")
    
    static var previews: some View {
        NavigationView {
            PlaceDetailView(travelSpot: travelSpots[1])
        }
    }
}

