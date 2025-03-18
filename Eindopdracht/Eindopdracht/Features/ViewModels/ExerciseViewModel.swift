import Foundation

// Ensures that all methods and properties of a class are accessed on the main thread.
// Critical for UI updates, as SwiftUI requires changes to UI elements to happen on the main thread.
@MainActor
// ObservableObject allows a class to be observed by SwiftUI views.
// Combined with @Published, it enables reactive UI updates. The view model publishes changes to exercises and customExercises.
class ExerciseViewModel: ObservableObject {
    // Marks a property as observable. When its value changes, SwiftUI views that reference the enclosing ObservableObject automatically update.
    // Notifies observers when the exercise list changes.
    @Published var exercises: [Exercise] = []
    @Published var customExercises: [Exercise] = []
    
    private var exerciseService = ExerciseService()

    init() {
        fetchExercises()
    }

    func fetchExercises() {
        let savedExercises = exerciseService.getExercises()
        self.customExercises = savedExercises

        // [weak self]: Prevents memory leaks by avoiding strong references in async closures.
        exerciseService.fetchExercisesFromAPI { [weak self] apiExercises in
            DispatchQueue.main.async {
                if let apiExercises = apiExercises {
                    // Filters duplicates by ensuring each Exercise has a unique ID.
                    self?.exercises = (savedExercises + apiExercises).uniqued(by: { $0.id })
                } else {
                    self?.exercises = savedExercises
                }
            }
        }
    }

    func addExercise(name: String, type: String, muscle: String, difficulty: String) {
        let newExercise = Exercise(name: name, type: type, muscle: muscle, difficulty: difficulty)
        exerciseService.addExercise(newExercise)
        fetchExercises()
    }

    func updateExercise(exercise: Exercise) {
        exerciseService.updateExercise(exercise)
        fetchExercises()
    }

    func deleteExercise(id: UUID) {
        exerciseService.deleteExercise(id: id)
        fetchExercises()
    }
}

// adds a method to deduplicate elements using a Set to track seen IDs.
extension Array {
    func uniqued(by key: (Element) -> UUID) -> [Element] {
        var seen = Set<UUID>()
        // Includes only elements whose IDs are newly added to the Set.
        return filter { seen.insert(key($0)).inserted }
    }
}
