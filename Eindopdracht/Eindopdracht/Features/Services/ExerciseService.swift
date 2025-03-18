import Foundation

class ExerciseService {
    private var exercises: [Exercise] = [] // The primary in-memory data store for exercises. - Loads persisted exercises from local storage during initialization (if any exist). - Acts as the single source of truth for exercise data within the service. Changes are explicitly saved to disk via `StorageService`.
    private let apiService = APIService()
    private let storageService = StorageService.shared
    private let storageFile = "exercises.json"
        
    init() {
        // Try to load saved exercises from local storage
        // If no saved exercises are found, initialize with an empty array
        if let savedExercises: [Exercise] = storageService.load(from: storageFile, as: [Exercise].self) {
            exercises = savedExercises
        } else {
            exercises = []
        }
    }
        
    func fetchExercisesFromAPI(completion: @escaping ([Exercise]?) -> Void) {
        apiService.fetchExercisesFromAPI { result in
            switch result {
            case .success(let fetchedExercises):
                completion(fetchedExercises) // Return fetched exercises to the caller
            case .failure(let error):
             // Log the error and return nil in case of failure
                print("Error fetching exercises: \(error)")
                completion(nil) // nil = the application still works
            }
        }
    }
    
    // () -> denotes a function's return type. Here, getExercises() returns [Exercise].
    func getExercises() -> [Exercise] {
        return exercises
    }
    
    // The underscore (_) in func addExercise(_ exercise: ...) omits the parameter label, allowing addExercise(exercise) instead of addExercise(exercise: exercise).
    func addExercise(_ exercise: Exercise) {
        exercises.append(exercise)
        storageService.save(exercises, to: storageFile)  // Save the updated exercises list to local storage
    }
    
    func updateExercise(_ updatedExercise: Exercise) {
        // Search for the exercise by its ID and replace it with the updated one
        if let index = exercises.firstIndex(where: { $0.id == updatedExercise.id }) {
            exercises[index] = updatedExercise
            storageService.save(exercises, to: storageFile)
        }
    }
    
    func deleteExercise(id: UUID) {
        exercises.removeAll { $0.id == id }
        storageService.save(exercises, to: storageFile)
    }
}
