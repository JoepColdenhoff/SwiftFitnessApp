import Foundation

class StorageService {
    static let shared = StorageService()
    private init() {}
    
    // In-memory storage to reduce disk access for frequently used data.
    private var cache: [String: Any] = [:]
    
    private func getFileURL(for fileName: String) -> URL {
        // Gets the app's document directory URL for file storage.
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }
    
    // <T: Codable>: Generic constraint ensuring only Codable types can be saved/loaded.
    func save<T: Codable>(_ data: T, to fileName: String) {
        let url = getFileURL(for: fileName)
        do {
            let encodedData = try JSONEncoder().encode(data)
            try encodedData.write(to: url)
            cache[fileName] = data
        } catch {
            print("Failed to save data to \(fileName):", error)
        }
    }
    
    func load<T: Codable>(from fileName: String, as type: T.Type) -> T? {
        // Safely casts cached data to the expected type T.
        if let cachedData = cache[fileName] as? T {
            return cachedData
        }
        
        let url = getFileURL(for: fileName)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            cache[fileName] = decodedData
            return decodedData
        } catch {
            print("Failed to load data from \(fileName):", error)
            return nil
        }
    }
    
    func clearCache(for fileName: String) {
        cache[fileName] = nil
    }
}
