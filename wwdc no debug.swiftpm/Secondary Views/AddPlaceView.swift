import SwiftUI
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var locationError: Error?
    private let dispatchGroup = DispatchGroup()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation(completion: @escaping () -> Void) {
        if CLLocationManager.locationServicesEnabled() {
//            dispatchGroup.enter() // Enter the dispatch group before starting location updates
            locationManager.startUpdatingLocation()
            
            // Use a DispatchQueue to wait for a short interval before completing
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion()
            }
        } else {
            completion()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Access the user's current coordinates
            self.currentLocation = location.coordinate
            
            // Stop updating location after receiving the first result
            locationManager.stopUpdatingLocation()
//            dispatchGroup.leave() // Leave the dispatch group when location updates are received
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationError = error
        dispatchGroup.leave() // Leave the dispatch group in case of error
    }
}

struct TravelImage: Identifiable, Equatable {
    var id: String
    var image: UIImage
}

struct AddPlaceView: View {
    
    
    @ObservedObject private var locationManager = LocationManager()
    
    @State private var travelSpots: [TravelSpot] = Bundle.main.loadJSONDataFromFile(fileName: "data.json", type: [TravelSpot].self) ?? []
    
    @State private var Namebinder = ""
    @State private var DescriptionBinder = ""
    @State private var CoordinateBinder = ""
    @State private var TagBinder = ""
    @State private var showingAlert = false
    //    @State private var showingConfirmation = false
    @State private var selectedImages: [TravelImage] = []
    @State private var gotLocation = false
    @State private var imageModalAppear = false
    @State private var imageFromModal: UIImage = UIImage(named: "black-forest-1")!
    @State private var isAdminGranted = false
    @State private var longitude: Double?
    @State private var latitude: Double?
    @State private var imageNameList: [String]? = []
    
    @State private var newData: TravelSpot?
    @State private var randomString: String = ""
    @State private var isAlertShown = false
    @State private var alertText = ""
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            
            Form {
                Section(header: Text("BASIC DATA")) {
                    TextField("Place Name", text: $Namebinder)
                }
                Section(header: Text("Description")) {
                    TextEditor(text: $DescriptionBinder)
                        .frame(height: 200, alignment: .top)
                }
                Section(header: Text("Tag (separate with space)")){
                    TextEditor(text: $TagBinder)
                        .frame(height: 100, alignment: .top)
                }
                
                if (gotLocation) {
                    Text("Location Loaded")
                        .foregroundColor(.accentColor)
                } else {
                    Button("Get Location") {
                        
                        locationManager.getCurrentLocation {
                            if (locationManager.currentLocation?.longitude == nil || locationManager.currentLocation?.latitude == nil) {
                                showingAlert.toggle()
                            } else {
                                gotLocation = true
                                latitude = locationManager.currentLocation?.latitude
                                longitude = locationManager.currentLocation?.longitude
                            }
                        }
                                                
                        
                        
                        
                        
                    }
                    .foregroundColor(.accentColor)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Error"), message: Text("Location couldn't be loaded. Please try again."), dismissButton: .cancel(Text("Dismiss")))
                    }
                }
                
                
                Section(header: Text("SELECT IMAGES")) {
                    if (selectedImages != []) {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(selectedImages) { image in
                                    Image(uiImage: image.image)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .scaledToFill()
                                        .onTapGesture {
                                            imageModalAppear.toggle()
                                        }
                                        .sheet(isPresented: $imageModalAppear) {
                                            ImagePicker(image: $imageFromModal)
                                        }
                                }
                            }
                        }
                        
                        
                    } else {
                        Image(systemName: "photo")
                            .onTapGesture {
                                imageModalAppear.toggle()
                            }
                            .sheet(isPresented: $imageModalAppear) {
                                ImagePicker(image: $imageFromModal)
                            }
                        
                    }
                }
                Section {
                    Button("Submit") {
                        
                        if (Namebinder == "") {
                            alertText = "Name"
                            isAlertShown.toggle()
                        } else if (DescriptionBinder == "") {
                            alertText = "Description"
                            isAlertShown.toggle()
                        } else if (latitude == nil) {
                            alertText = "Location"
                            isAlertShown.toggle()
                        } else if (imageNameList == []) {
                            alertText = "Image"
                            isAlertShown.toggle()
                        } else {
                            newData = TravelSpot(id: randomString(length: 42), tag: TagBinder, name: Namebinder, latitude: latitude ?? 0, longitude: longitude ?? 0, images: imageNameList ?? [], description: DescriptionBinder, fee: false)
                            travelSpots.append(newData!)
                            Bundle.main.saveJSONDataToFile(data: travelSpots, fileName: "data.json")
                            selectedImages.forEach {image in
                                Bundle.main.storeImageLocally(image: image.image, imageName: image.id)
                                
                            }
                            dismiss()
                            
                        }
                        
                            
                        
                    }
                    .foregroundColor(.blue)
                    .alert(Text("\(alertText) is empty."), isPresented: $isAlertShown) {
                        Button("Dismiss", role: .cancel) { }
                    }
                    
                }
                if (isAdminGranted) {
                    NavigationLink(destination: TesterView(travelImages: selectedImages), isActive: $isAdminGranted) {
                        EmptyView()
                    }
                }
                
            }
            .navigationTitle("Add Place")
            .onChange(of: imageFromModal, perform: { _ in
                randomString = randomString(length: 24)
                
                selectedImages.append(TravelImage(id: randomString, image: imageFromModal))
                imageNameList?.append(randomString)
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "multiply")
                }
            }
        }
    }
}


//struct AddPlaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPlaceView()
//    }
//}
