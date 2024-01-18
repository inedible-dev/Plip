import Foundation
import CoreData
import ImageIO
import SwiftUI
import CoreImage

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        } 
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded
        
    } 
    
    func saveJSONDataToFile<T: Codable>(data: T, fileName: String) {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(data)
            try jsonData.write(to: fileURL)
            print("JSON data saved successfully.")
        } catch {
            print("Failed to save JSON data to file: \(error.localizedDescription)")
        }
    }
    
    // Function to load JSON data from a file
    func loadJSONDataFromFile<T: Codable>(fileName: String, type: T.Type) -> T? {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(type, from: jsonData)
            return decodedData
        } catch {
            print("Failed to load JSON data from file: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    func storeImageLocally(image: UIImage, imageName: String) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        
        let fileExtension: String
        if let imageFileType = getImageFileType(imageData: image) {
            fileExtension = imageFileType.fileExtension
        } else {
            fileExtension = ".png" // Default to PNG if file type is not recognized
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("\(imageName)\(fileExtension)")
        if let data = image.pngData() ?? image.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
                print("Image \(imageName) saved successfully at \(fileURL.absoluteString)")
            } catch {
                print("Failed to store image \(imageName): \(error.localizedDescription)")
            }
        }
    }
    
    func getImageFileType(imageData: UIImage) -> ImageFileType? {
        if let data = imageData.pngData() {
            if data.starts(with: [0x89, 0x50, 0x4E, 0x47]) {
                return .png
            }
        } else if let data = imageData.jpegData(compressionQuality: 1.0) {
            if data.starts(with: [0xFF, 0xD8, 0xFF]) {
                return .jpeg
            }
        }
        return nil
    }
    
    enum ImageFileType {
        case png
        case jpeg
        
        var fileExtension: String {
            switch self {
            case .png:
                return ".png"
            case .jpeg:
                return ".jpeg"
            }
        }
    }

    
    func retrieveImageLocally(imageName: String) -> UIImage? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let pngFileURL = documentsDirectory.appendingPathComponent("\(imageName).png")
        let jpegFileURL = documentsDirectory.appendingPathComponent("\(imageName).jpeg")
        
        if fileManager.fileExists(atPath: pngFileURL.path) {
            if let imageData = try? Data(contentsOf: pngFileURL) {
                return UIImage(data: imageData)
            }
        } else if fileManager.fileExists(atPath: jpegFileURL.path) {
            if let imageData = try? Data(contentsOf: jpegFileURL) {
                return UIImage(data: imageData)
            }
        } else {
            fatalError("Cannot load image from file")
        }
        
        return nil
    }

    
    
    
    
}
