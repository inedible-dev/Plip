import SwiftUI

struct MapAnnotationView: View {
    
    let travelSpot: TravelSpot
    
    @State var animation: Double = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 2)
                .foregroundColor(.accentColor)
                .frame(width: 52, height: 50, alignment: .center)
                .scaleEffect(1 + animation)
                .opacity(1 - animation)
            Circle()
                .foregroundColor(Color.accentColor)
                .frame(width: 54, height: 54, alignment: .center)
            
            Image(uiImage: Bundle.main.retrieveImageLocally(imageName: travelSpot.images[0])!)
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 50, alignment: .center)
                .clipShape(Circle())
        }
        .onAppear {
            withAnimation(Animation.easeOut(duration: 2).repeatForever(autoreverses: false)) {
                animation = 1
            }
        }
    }
}

struct MapAnnotationView_Previews: PreviewProvider {
    
    static let travelSpots: [TravelSpot] = Bundle.main.decode("data.json")
    
    static var previews: some View {
        MapAnnotationView(travelSpot: travelSpots[0])
            .padding()
    }
}
