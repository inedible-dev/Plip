import SwiftUI

struct ExploreView: View {
    
    @State private var searchBar = ""
    @State private var travelSpots: [TravelSpot] = Bundle.main.loadJSONDataFromFile(fileName: "data.json", type: [TravelSpot].self) ?? []
    @State private var navigateToAddScreen = false
    @State private var tutorialShouldAppear = true
    @AppStorage("tutorialShown") private var tutorialShown: Bool = false
//    @State private var tutorialShown: Bool = false
    
    var searchResults: [TravelSpot] {
        if searchBar.isEmpty {
            return travelSpots
        } else {
            return travelSpots.filter {$0.tag.localizedCaseInsensitiveContains(searchBar)}
        }
    }
    var body: some View {
        if (tutorialShown) {
            NavigationView {
                if (travelSpots.isEmpty && tutorialShouldAppear) {
                    Text("Tap the add button on top to add your new memory.")
                        .navigationTitle("Travel Spots")
                        .searchable(text: $searchBar, prompt: "Search Places, City, Country/Region")
                        .toolbar {
                            
                            Button {
                                print("toggle")
                                navigateToAddScreen.toggle()
                                tutorialShouldAppear = false
                                
                            } label: {
                                Image(systemName: "plus")
                            }
                            .sheet(isPresented: $navigateToAddScreen) {
                                AddPlaceView()
                            }
                        }
                        
                        
                        
                } else {
                    List {
                        ForEach(searchResults) { place in
                            NavigationLink(destination: PlaceDetailView(travelSpot: place)) {
                                PlaceListView(travelSpot: place)
                            }
                            
                        }
                        
                    }
                    .listStyle(.sidebar)
                    .navigationTitle("Travel Spots")
                    .searchable(text: $searchBar, prompt: "Search Places, City, Country/Region")
                    .toolbar {
                        
                        Button {
                            print("toggle")
                            navigateToAddScreen.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $navigateToAddScreen) {
                            AddPlaceView()
                        }
                    }
                    .refreshable {
                        travelSpots = Bundle.main.loadJSONDataFromFile(fileName: "data.json", type: [TravelSpot].self) ?? []
                        print(travelSpots)
                    }
                    
                }
                
            }
            .onChange(of: navigateToAddScreen) { changeData in
                if changeData == false {
                    travelSpots = Bundle.main.loadJSONDataFromFile(fileName: "data.json", type: [TravelSpot].self) ?? []
                    print("onChange")
                }
            }
        } else {
            TabView {
                VStack {
                    Image("screenshot-1")
                        .resizable()
                        .scaledToFit()
                    Text("Swipe to continue ->")
                }
                Image("screenshot-2")
                    .resizable()
                    .scaledToFit()
                VStack {
                    Image("screenshot-3")
                        .resizable()
                        .scaledToFit()
                        .onTapGesture {
                            tutorialShown = true
                        }
                    Text("Tap the image to continue..")
                }
            }
            .tabViewStyle(PageTabViewStyle())
            
        }
            
                
                
                
        
    }
}
