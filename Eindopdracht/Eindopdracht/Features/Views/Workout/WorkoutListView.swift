import SwiftUI

struct WorkoutListView: View {
    // Used for initializing and retaining an ObservableObject within a view.
    @StateObject var viewModel = WorkoutViewModel()
    @StateObject var exerciseViewModel = ExerciseViewModel()
    // When the value changes, SwiftUI automatically re-renders the view.
    @State private var workoutName: String = ""
    @State private var isAddingWorkout = false
    @State private var showExerciseManagement = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.workouts) { workout in
                        NavigationLink(destination: WorkoutDetailView(workout: workout, workoutViewModel: viewModel)) {
                            Text(workout.name)
                        }
                    }
                    .onDelete(perform: deleteWorkout)
                }
                .navigationTitle("Workouts")
                
                HStack {
                    Button(action: {
                        isAddingWorkout = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add workout")
                        }
                        .foregroundColor(.white)
                        .frame(width: 160, height: 50)
                        .background(Color.blue)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                    .sheet(isPresented: $isAddingWorkout) {
                        AddWorkoutView(viewModel: viewModel)
                    }
                    
                    NavigationLink(destination: ExerciseListView(viewModel: exerciseViewModel)) {
                        HStack {
                            Image(systemName: "list.bullet.rectangle")
                            Text("My exercises")
                        }
                        .foregroundColor(.white)
                        .frame(width: 180, height: 50)
                        .background(Color.mint)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                }
                .padding(.bottom)
            }
            .onAppear {
                viewModel.fetchWorkouts()
            }
        }
    }
    
    private func deleteWorkout(at offsets: IndexSet) {
        // Represents positions of items to delete in a list (e.g., swiping multiple rows).
        viewModel.deleteWorkout(at: offsets)
    }
}
