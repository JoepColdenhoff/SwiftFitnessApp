import Foundation

// Ensures that all methods and properties of a class are accessed on the main thread.
// Critical for UI updates, as SwiftUI requires changes to UI elements to happen on the main thread.
@MainActor
// ObservableObject allows a class to be observed by SwiftUI views.
class WorkoutViewModel: ObservableObject {
    // Marks a property as observable. When its value changes, SwiftUI views that reference the enclosing ObservableObject automatically update.
    @Published var workouts: [Workout] = []
    
    // Accesses the singleton instance for centralized data management.
    private var workoutService = WorkoutService.shared
    
    init() {
        fetchWorkouts()
    }
    
    func fetchWorkouts() {
        workouts = workoutService.getWorkouts()
    }
    
    func addWorkout(name: String) {
        let newWorkout = Workout(name: name, exercises: [])
        workoutService.addWorkout(workout: newWorkout)
        fetchWorkouts()
    }
    
    func addExerciseToWorkout(workoutId: UUID, exercise: Exercise) {
           workoutService.addExerciseToWorkout(workoutId: workoutId, exercise: exercise)
           fetchWorkouts()
       }
    
    func removeExerciseFromWorkout(workoutId: UUID, exercise: Exercise) {
        workoutService.removeExerciseFromWorkout(workoutId: workoutId, exercise: exercise)
        fetchWorkouts()
    }
    
    func deleteWorkout(at offsets: IndexSet) {
        // Represents the indices of workouts to delete (e.g., when swiping rows in a list).
        for index in offsets {
            let workout = workouts[index]
            workoutService.deleteWorkout(id: workout.id)
        }
        fetchWorkouts()
    }
}

