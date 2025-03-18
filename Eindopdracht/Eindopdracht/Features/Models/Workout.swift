import Foundation

// Identifiable = er is er maar 1. Codable = voor het en/decoden
struct Workout: Identifiable, Codable {
    var id = UUID()
    var name: String
    var exercises: [Exercise]
}
