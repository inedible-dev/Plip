import SwiftUI

// For Debugging

struct TesterView: View {
    
    let travelImages: [TravelImage]
    
    @State private var dataJSON: [TravelSpot] = Bundle.main.loadJSONDataFromFile(fileName: "data.json", type: [TravelSpot].self) ?? []
    @State private var shoudImageAppear = false
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("SAVE DATA")) {
                    Button("Save Sample JSON") {
                        print("Save JSON")
                        Bundle.main.saveJSONDataToFile(data: [TravelSpot(id: "a", tag: "Germany Cologne Cathedral", name: "Cologne Cathedral", latitude: 50.9413, longitude: 6.9583, images: ["i1", "i2", "i3"], description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vel condimentum nibh. Curabitur mattis nisi ut leo malesuada lobortis. Duis sapien libero, ultricies eget augue vitae, ullamcorper egestas ligula. Sed eu posuere felis. Suspendisse ullamcorper nisl augue, et maximus quam vehicula in. Nam nec velit id ipsum finibus laoreet. Curabitur lobortis finibus libero nec dictum. Donec aliquam aliquet congue. Fusce cursus mauris a diam sagittis, congue fringilla enim efficitur. Vivamus commodo pulvinar nisi, at faucibus neque porttitor sit amet. Curabitur id ex et enim finibus molestie. Nunc tortor magna, congue et mollis vel, euismod ut augue. Fusce et commodo lectus.", fee: true), TravelSpot(id: "b", tag: "asdf asdf asdf asdf", name: "test", latitude: 50, longitude: 50, images: ["i1", "i2", "i3"], description: "wefjhqwoefhqweuifhuehruifqhfiuehwfiuhqewfiuhqwefiuhqewiufqweiufqweiufhiqwufhiuefhwiuefhoqwiefhiqwufhiuqewhfiuwehfjkasdfhqiuwhefiuqfheiquwfhjkwefhiqwufhiuwfhaksjdfjkadshf", fee: false)], fileName: "data.json")
                    }
                    Button("Save Sample Image") {
                        Bundle.main.storeImageLocally(image: travelImages[0].image, imageName: "i1")
                        Bundle.main.storeImageLocally(image: travelImages[1].image, imageName: "i2")
                        Bundle.main.storeImageLocally(image: travelImages[2].image, imageName: "i3")
                    }
                    Button("Read JSON from file") {
                        print(Bundle.main.loadJSONDataFromFile(fileName: "data.json", type: [TravelSpot].self) ?? [])
                        shoudImageAppear.toggle()
                    }
                    if (shoudImageAppear) {
                        Image(uiImage: Bundle.main.retrieveImageLocally(imageName: "i1")!)
                        Image(uiImage: Bundle.main.retrieveImageLocally(imageName: "i2")!)
                        Image(uiImage: Bundle.main.retrieveImageLocally(imageName: "i3")!)
                    }
                }
                Section(header: Text("RESET DATA")) {
                    Button("Reset All Contents") {
                        print("Reset All Contents")
                        dataJSON = []
                        Bundle.main.saveJSONDataToFile(data: dataJSON, fileName: "data.json")
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Admin Page")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//struct TesterView_Previews: PreviewProvider {
//    static var previews: some View {
//        TesterView()
//    }
//}
