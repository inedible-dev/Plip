import Foundation
import MapKit

struct TravelSpot: Codable, Identifiable, Equatable {
    var id: String
    var tag: String
    var name: String
    var latitude: Double
    var longitude: Double
    var cover: String?
    var images: [String]
    var description: String    
    var fee: Bool
}

// MARK: - Methods


