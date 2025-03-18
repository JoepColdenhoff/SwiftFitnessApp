import Foundation

class WorkoutService {
    static let shared = WorkoutService()
    private let storageService = StorageService.shared
    private let storageFile = "workouts.json"
    
    private var workouts: [Workout] = []
    
    // Enforces singleton usage by restricting direct initialization.
    private init() {
        // Specifies the type to decode from JSON (an array of Workout).
        if let savedWorkouts: [Workout] = storageService.load(from: storageFile, as: [Workout].self) {
            workouts = savedWorkouts
        }
    }
    
    func addWorkout(workout: Workout) {
        workouts.append(workout)
        storageService.save(workouts, to: storageFile)
    }
    
    func getWorkouts() -> [Workout] {
        return workouts
    }
    
    func deleteWorkout(id: UUID) {
        // Shorthand to check if a workout's ID matches the target ID.
        if let index = workouts.firstIndex(where: { $0.id == id }) {
            workouts.remove(at: index)
            storageService.save(workouts, to: storageFile)
        }
    }
    
    func addExerciseToWorkout(workoutId: UUID, exercise: Exercise) {
        // Shorthand to check if a workout's ID matches the target ID.
        if let index = workouts.firstIndex(where: { $0.id == workoutId }) {
            workouts[index].exercises.append(exercise)
            storageService.save(workouts, to: storageFile)
        }
    }
    
    func removeExerciseFromWorkout(workoutId: UUID, exercise: Exercise) {
        // Shorthand to check if a workout's ID matches the target ID.
        if let index = workouts.firstIndex(where: { $0.id == workoutId }) {
            // Checks if an exercise's ID matches the target for removal.
            if let exerciseIndex = workouts[index].exercises.firstIndex(where: { $0.id == exercise.id }) {
                workouts[index].exercises.remove(at: exerciseIndex)
                storageService.save(workouts, to: storageFile)
            }
        }
    }
}
