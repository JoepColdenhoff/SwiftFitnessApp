import SwiftUI

struct WorkoutDetailView: View {
    // When the value changes, SwiftUI automatically re-renders the view.
    @State var workout: Workout
    @State private var isAddingExercise = false
    var workoutViewModel: WorkoutViewModel
    // Subscribes to an external class (like a ViewModel) that conforms to ObservableObject.
    // Updates the view when the observed object changes.
    @ObservedObject var exerciseViewModel = ExerciseViewModel()
    // Used for initializing and retaining an ObservableObject within a view.
    @StateObject var timerService = TimerService()
    
    // Accesses environment values provided by the system or parent views (e.g., device orientation, dark mode, or presentation mode).
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        VStack {
            // Only display workout name in portrait mode
            if verticalSizeClass != .compact {
                Text(workout.name)
                    .font(.largeTitle)
                    .padding()
            }
            List {
                Section(header: Text("Exercises")) {
                    ForEach(workout.exercises) { exercise in
                        HStack {
                            Text(exercise.name)
                            Spacer()
                            Text(exercise.type)
                                .foregroundColor(.gray)
                        }
                    }
                    .onDelete(perform: removeExercise)
                }
            }
            
            HStack {
                Button(action: {
                    if timerService.isRunning {
                        timerService.stop()
                    } else {
                        timerService.start()
                    }
                }) {
                    Text(timerService.isRunning ? "Stop" : "Start")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(timerService.isRunning ? Color.red : Color.green)
                        .cornerRadius(10)
                }
                
                Text(timerService.formattedTime)
                    .font(.title)
                    .padding()
                
                Button(action: {
                    timerService.reset()
                }) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .onAppear {
            exerciseViewModel.fetchExercises()
        }
        
        // Change navigation title based on orientation:
        // In landscape mode, prepend the workout name to "Workout details".
        .navigationTitle(verticalSizeClass == .compact ? "\(workout.name) - Workout details" : "Workout details")
        .navigationBarItems(trailing: Button(action: {
            isAddingExercise = true
        }) {
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.blue)
        })
        .sheet(isPresented: $isAddingExercise) {
            ExerciseWorkoutListView(workout: $workout, exerciseViewModel: exerciseViewModel, workoutViewModel: workoutViewModel)
        }
    }
    
    private func removeExercise(at offsets: IndexSet) {
        for index in offsets {
            let exercise = workout.exercises[index]
            workoutViewModel.removeExerciseFromWorkout(workoutId: workout.id, exercise: exercise)
        }
        // Updates the local workout state with the latest data from the ViewModel, defaulting to the current workout if not found.
        workout = workoutViewModel.workouts.first(where: { $0.id == workout.id }) ?? workout
    }
}
