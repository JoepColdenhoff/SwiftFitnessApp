import SwiftUI

struct ExerciseWorkoutListView: View {
    // Creates a two-way connection between a parent view’s state and a child view.
    // Changes in the child propagate back to the parent.
    @Binding var workout: Workout
    // Subscribes to an external class (like a ViewModel) that conforms to ObservableObject.
    // Updates the view when the observed object changes.
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    var workoutViewModel: WorkoutViewModel

    @State private var selectedExercises = Set<UUID>()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Text("Here you can add the exercises that are fetched from the internet and your own exercises!")

                List(exerciseViewModel.exercises) { exercise in
                    HStack {
                        Text(exercise.name)
                        Spacer()
                        Text(exercise.type)
                            .foregroundColor(.gray)
                        
                        Image(systemName: selectedExercises.contains(exercise.id) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectedExercises.contains(exercise.id) ? .green : .gray)
                            .onTapGesture {
                                if selectedExercises.contains(exercise.id) {
                                    selectedExercises.remove(exercise.id)
                                } else {
                                    selectedExercises.insert(exercise.id)
                                }
                            }
                    }
                }
                
                Button(action: {
                    for exerciseId in selectedExercises {
                        // Finds the first Exercise in the array with a matching ID.
                        if let exercise = exerciseViewModel.exercises.first(where: { $0.id == exerciseId }) {
                            workout.exercises.append(exercise)
                            workoutViewModel.addExerciseToWorkout(workoutId: workout.id, exercise: exercise)
                        }
                    }
                    selectedExercises.removeAll()
                    // Screen disappears after adding exercise to workout
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add selected exercises")
                    }
                    .foregroundColor(.white)
                    .frame(width: 250, height: 50)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                .disabled(selectedExercises.isEmpty)
            }
            .navigationTitle("Select exercises")
        }
        .onAppear {
            exerciseViewModel.fetchExercises()
        }
    }
}
