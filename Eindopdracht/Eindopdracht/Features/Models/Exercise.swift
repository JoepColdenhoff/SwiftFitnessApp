import Foundation

struct Exercise: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: String
    var muscle: String
    var difficulty: String
    
    // Define coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case id, name, type, muscle, difficulty
    }
    
    // Two inits: One for programmatic creation (with default UUID), another for decoding from JSON (with optional ID).
    init(id: UUID = UUID(), name: String, type: String, muscle: String, difficulty: String) {
        self.id = id
        self.name = name
        self.type = type
        self.muscle = muscle
        self.difficulty = difficulty
    }
    
    // Custom initializer for decoding from JSON
    // Handles JSON decoding, generating a UUID if the ID is missing in the data.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(String.self, forKey: .type)
        self.muscle = try container.decode(String.self, forKey: .muscle)
        self.difficulty = try container.decode(String.self, forKey: .difficulty)
    }
}
